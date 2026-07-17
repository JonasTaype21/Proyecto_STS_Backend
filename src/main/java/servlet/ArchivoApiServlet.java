package servlet;

import api.dto.ArchivoApiResponse;
import api.dto.ArchivoTicketResponse;

import bean.ArchivoTicket;
import bean.Usuario;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import dao.ArchivoTicketDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@WebServlet("/api/archivos")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10L * 1024L * 1024L,
        maxRequestSize = 12L * 1024L * 1024L
)
public class ArchivoApiServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final long TAMANIO_MAXIMO =
            10L * 1024L * 1024L;

    private static final String ORIGEN_ANGULAR =
            "http://localhost:4200";

    private static final SimpleDateFormat FORMATO_FECHA =
            new SimpleDateFormat(
                    "dd/MM/yyyy HH:mm",
                    Locale.forLanguageTag("es-PE")
            );

    private final Gson gson = new Gson();

    private final ArchivoTicketDAO archivoDAO =
            new ArchivoTicketDAO();

    /*
     * Los archivos se guardan fuera del proyecto y fuera
     * del despliegue de GlassFish.
     */
    private final Path directorioBase = Paths.get(
            System.getProperty("user.home"),
            "STS_Archivos"
    );

    @Override
    public void init() throws ServletException {

        try {
            Files.createDirectories(directorioBase);

        } catch (IOException e) {
            throw new ServletException(
                    "No fue posible crear el directorio de archivos.",
                    e
            );
        }
    }

    @Override
    protected void doOptions(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        configurarCors(response);
        response.setStatus(HttpServletResponse.SC_OK);
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding(
                StandardCharsets.UTF_8.name()
        );

        String accion = request.getParameter("accion");

        if ("descargar".equalsIgnoreCase(accion)) {
            descargarArchivo(request, response);
            return;
        }

        listarArchivos(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding(
                StandardCharsets.UTF_8.name()
        );

        configurarRespuestaJson(response);

        Path archivoFisicoGuardado = null;

        try {

            HttpSession session =
                    request.getSession(false);

            if (session == null) {
                enviarError(
                        response,
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "La sesión ha expirado."
                );
                return;
            }

            Usuario usuario =
                    (Usuario) session.getAttribute("usuario");

            if (usuario == null) {
                enviarError(
                        response,
                        HttpServletResponse.SC_UNAUTHORIZED,
                        "No existe un usuario autenticado."
                );
                return;
            }

            String idTicketTexto =
                    request.getParameter("idTicket");

            if (
                    idTicketTexto == null
                    || idTicketTexto.trim().isEmpty()
            ) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Debe indicar el ticket."
                );
                return;
            }

            int idTicket;

            try {
                idTicket = Integer.parseInt(
                        idTicketTexto.trim()
                );

            } catch (NumberFormatException e) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El identificador del ticket no es válido."
                );
                return;
            }

            if (idTicket <= 0) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El identificador del ticket debe ser mayor que cero."
                );
                return;
            }

            Part archivoPart;

            try {
                archivoPart = request.getPart("archivo");

            } catch (IllegalStateException e) {
                enviarError(
                        response,
                        HttpServletResponse.SC_REQUEST_ENTITY_TOO_LARGE,
                        "El archivo supera el límite permitido de 10 MB."
                );
                return;
            }

            if (
                    archivoPart == null
                    || archivoPart.getSize() <= 0
            ) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Debe seleccionar un archivo."
                );
                return;
            }

            if (archivoPart.getSize() > TAMANIO_MAXIMO) {
                enviarError(
                        response,
                        HttpServletResponse.SC_REQUEST_ENTITY_TOO_LARGE,
                        "El archivo no puede superar los 10 MB."
                );
                return;
            }

            String nombreOriginal =
                    obtenerNombreSeguro(
                            archivoPart.getSubmittedFileName()
                    );

            if (
                    nombreOriginal == null
                    || nombreOriginal.trim().isEmpty()
            ) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El archivo no tiene un nombre válido."
                );
                return;
            }

            String extension =
                    obtenerExtension(nombreOriginal);

            if (!extensionPermitida(extension)) {
                enviarError(
                        response,
                        HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE,
                        "Solo se permiten archivos PDF, PNG, JPG y JPEG."
                );
                return;
            }

            String tipoMime =
                    archivoPart.getContentType();

            if (!tipoMimePermitido(tipoMime)) {
                enviarError(
                        response,
                        HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE,
                        "El tipo de archivo seleccionado no está permitido."
                );
                return;
            }

            Path carpetaTicket =
                    directorioBase.resolve(
                            "ticket_" + idTicket
                    );

            Files.createDirectories(carpetaTicket);

            String nombreGuardado =
                    UUID.randomUUID()
                            .toString()
                            .replace("-", "")
                    + "."
                    + extension;

            archivoFisicoGuardado =
                    carpetaTicket.resolve(nombreGuardado);

            Files.copy(
                    archivoPart.getInputStream(),
                    archivoFisicoGuardado,
                    StandardCopyOption.REPLACE_EXISTING
            );

            ArchivoTicket archivo =
                    new ArchivoTicket();

            archivo.setIdTicket(idTicket);

            /*
             * Confirma que tu bean Usuario utilice este getter.
             */
            archivo.setIdUsuario(
                    usuario.getIdUsuario()
            );

            archivo.setNombreArchivo(nombreOriginal);
            archivo.setNombreGuardado(nombreGuardado);
            archivo.setTipoArchivo(tipoMime);
            archivo.setTamanioBytes(
                    archivoPart.getSize()
            );

            archivo.setRutaArchivo(
                    archivoFisicoGuardado
                            .toAbsolutePath()
                            .toString()
            );

            int idArchivo =
                    archivoDAO.registrar(archivo);

            ArchivoTicket archivoGuardado =
                    archivoDAO.buscarPorId(idArchivo);

            if (archivoGuardado == null) {
                eliminarArchivoFisico(
                        archivoFisicoGuardado
                );

                enviarError(
                        response,
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "El archivo se guardó, pero no pudo recuperarse."
                );
                return;
            }

            ArchivoTicketResponse archivoApi =
                    convertirArchivo(
                            request,
                            archivoGuardado
                    );

            JsonObject respuesta =
                    new JsonObject();

            respuesta.addProperty("exito", true);

            respuesta.addProperty(
                    "mensaje",
                    "Archivo adjuntado correctamente."
            );

            respuesta.add(
                    "archivo",
                    gson.toJsonTree(archivoApi)
            );

            enviarJson(
                    response,
                    HttpServletResponse.SC_CREATED,
                    respuesta
            );

        } catch (Exception e) {

            eliminarArchivoFisico(
                    archivoFisicoGuardado
            );

            e.printStackTrace();

            enviarError(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Ocurrió un error al guardar el archivo."
            );
        }
    }

    private void listarArchivos(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        configurarRespuestaJson(response);

        try {

            String idTicketTexto =
                    request.getParameter("idTicket");

            if (
                    idTicketTexto == null
                    || idTicketTexto.trim().isEmpty()
            ) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Debe indicar el idTicket."
                );
                return;
            }

            int idTicket;

            try {
                idTicket = Integer.parseInt(
                        idTicketTexto.trim()
                );

            } catch (NumberFormatException e) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El idTicket no es válido."
                );
                return;
            }

            if (idTicket <= 0) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El idTicket debe ser mayor que cero."
                );
                return;
            }

            List<ArchivoTicket> archivos =
                    archivoDAO.listarPorTicket(idTicket);

            List<ArchivoTicketResponse> archivosApi =
                    new ArrayList<>();

            for (ArchivoTicket archivo : archivos) {
                archivosApi.add(
                        convertirArchivo(
                                request,
                                archivo
                        )
                );
            }

            ArchivoApiResponse respuesta =
                    new ArchivoApiResponse(
                            true,
                            "Archivos obtenidos correctamente.",
                            archivosApi
                    );

            enviarJson(
                    response,
                    HttpServletResponse.SC_OK,
                    respuesta
            );

        } catch (Exception e) {

            e.printStackTrace();

            enviarError(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Ocurrió un error al consultar los archivos."
            );
        }
    }

    private void descargarArchivo(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        configurarCors(response);

        try {

            String idArchivoTexto =
                    request.getParameter("idArchivo");

            if (
                    idArchivoTexto == null
                    || idArchivoTexto.trim().isEmpty()
            ) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Debe indicar el idArchivo."
                );
                return;
            }

            int idArchivo;

            try {
                idArchivo = Integer.parseInt(
                        idArchivoTexto.trim()
                );

            } catch (NumberFormatException e) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El idArchivo no es válido."
                );
                return;
            }

            ArchivoTicket archivo =
                    archivoDAO.buscarPorId(idArchivo);

            if (archivo == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "El archivo no existe."
                );
                return;
            }

            File archivoFisico =
                    new File(
                            archivo.getRutaArchivo()
                    );

            if (
                    !archivoFisico.exists()
                    || !archivoFisico.isFile()
            ) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "El archivo físico no está disponible."
                );
                return;
            }

            String tipoContenido =
                    archivo.getTipoArchivo();

            if (
                    tipoContenido == null
                    || tipoContenido.trim().isEmpty()
            ) {
                tipoContenido =
                        "application/octet-stream";
            }

            response.setCharacterEncoding("UTF-8");
            response.setContentType(tipoContenido);
            response.setContentLengthLong(
                    archivoFisico.length()
            );

            String nombreCodificado =
                    java.net.URLEncoder.encode(
                            archivo.getNombreArchivo(),
                            StandardCharsets.UTF_8
                    ).replace("+", "%20");

            response.setHeader(
                    "Content-Disposition",
                    "attachment; filename*=UTF-8''"
                    + nombreCodificado
            );

            try (
                    FileInputStream input =
                            new FileInputStream(
                                    archivoFisico
                            );

                    OutputStream output =
                            response.getOutputStream()
            ) {

                byte[] buffer = new byte[8192];
                int bytesLeidos;

                while (
                        (bytesLeidos = input.read(buffer)) != -1
                ) {
                    output.write(
                            buffer,
                            0,
                            bytesLeidos
                    );
                }

                output.flush();
            }

        } catch (Exception e) {

            e.printStackTrace();

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "No fue posible descargar el archivo."
                );
            }
        }
    }

    private ArchivoTicketResponse convertirArchivo(
            HttpServletRequest request,
            ArchivoTicket archivo
    ) {

        String fechaSubida = null;

        if (archivo.getFechaSubida() != null) {
            fechaSubida = FORMATO_FECHA.format(
                    archivo.getFechaSubida()
            );
        }

        String urlDescarga =
                request.getContextPath()
                + "/api/archivos"
                + "?accion=descargar"
                + "&idArchivo="
                + archivo.getIdArchivo();

        return new ArchivoTicketResponse(
                archivo.getIdArchivo(),
                archivo.getIdTicket(),
                archivo.getIdUsuario(),
                archivo.getNombreArchivo(),
                archivo.getTipoArchivo(),
                archivo.getTamanioBytes(),
                convertirTamanio(
                        archivo.getTamanioBytes()
                ),
                archivo.getNombreUsuario(),
                fechaSubida,
                urlDescarga
        );
    }

    private String obtenerNombreSeguro(
            String nombre
    ) {

        if (nombre == null) {
            return null;
        }

        String nombreLimpio =
                Paths.get(nombre)
                        .getFileName()
                        .toString();

        nombreLimpio =
                nombreLimpio.replaceAll(
                        "[\\r\\n]",
                        ""
                );

        nombreLimpio =
                nombreLimpio.replaceAll(
                        "[^a-zA-Z0-9áéíóúÁÉÍÓÚñÑüÜ._()\\- ]",
                        "_"
                );

        return nombreLimpio.trim();
    }

    private String obtenerExtension(
            String nombreArchivo
    ) {

        int posicionPunto =
                nombreArchivo.lastIndexOf('.');

        if (
                posicionPunto < 0
                || posicionPunto ==
                   nombreArchivo.length() - 1
        ) {
            return "";
        }

        return nombreArchivo
                .substring(posicionPunto + 1)
                .toLowerCase(Locale.ROOT);
    }

    private boolean extensionPermitida(
            String extension
    ) {

        return "pdf".equals(extension)
                || "png".equals(extension)
                || "jpg".equals(extension)
                || "jpeg".equals(extension);
    }

    private boolean tipoMimePermitido(
            String tipoMime
    ) {

        if (tipoMime == null) {
            return false;
        }

        return "application/pdf".equalsIgnoreCase(
                    tipoMime
                )
                || "image/png".equalsIgnoreCase(
                    tipoMime
                )
                || "image/jpeg".equalsIgnoreCase(
                    tipoMime
                );
    }

    private String convertirTamanio(
            long bytes
    ) {

        if (bytes < 1024) {
            return bytes + " B";
        }

        double kilobytes =
                bytes / 1024.0;

        if (kilobytes < 1024) {
            return String.format(
                    Locale.US,
                    "%.1f KB",
                    kilobytes
            );
        }

        double megabytes =
                kilobytes / 1024.0;

        return String.format(
                Locale.US,
                "%.1f MB",
                megabytes
        );
    }

    private void eliminarArchivoFisico(
            Path ruta
    ) {

        if (ruta == null) {
            return;
        }

        try {
            Files.deleteIfExists(ruta);

        } catch (IOException e) {
            System.err.println(
                    "No se pudo eliminar el archivo físico: "
                    + ruta
            );
        }
    }

    private void configurarRespuestaJson(
            HttpServletResponse response
    ) {

        configurarCors(response);

        response.setCharacterEncoding(
                StandardCharsets.UTF_8.name()
        );

        response.setContentType(
                "application/json;charset=UTF-8"
        );
    }

    private void configurarCors(
            HttpServletResponse response
    ) {

        response.setHeader(
                "Access-Control-Allow-Origin",
                ORIGEN_ANGULAR
        );

        response.setHeader(
                "Access-Control-Allow-Credentials",
                "true"
        );

        response.setHeader(
                "Access-Control-Allow-Methods",
                "GET, POST, OPTIONS"
        );

        response.setHeader(
                "Access-Control-Allow-Headers",
                "Content-Type, Accept"
        );
    }

    private void enviarError(
            HttpServletResponse response,
            int estadoHttp,
            String mensaje
    ) throws IOException {

        JsonObject error =
                new JsonObject();

        error.addProperty("exito", false);
        error.addProperty("mensaje", mensaje);

        enviarJson(
                response,
                estadoHttp,
                error
        );
    }

    private void enviarJson(
            HttpServletResponse response,
            int estadoHttp,
            Object contenido
    ) throws IOException {

        response.setStatus(estadoHttp);

        try (PrintWriter out = response.getWriter()) {
            out.print(
                    gson.toJson(contenido)
            );
            out.flush();
        }
    }
}