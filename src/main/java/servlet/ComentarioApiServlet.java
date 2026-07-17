package servlet;

import api.dto.ComentarioApiResponse;
import api.dto.ComentarioTicketResponse;

import bean.ComentarioTicket;
import bean.Usuario;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import dao.ComentarioTicketDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import java.nio.charset.StandardCharsets;

import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.List;

@WebServlet("/api/comentarios")
public class ComentarioApiServlet extends HttpServlet {

    private final Gson gson = new Gson();

    private final ComentarioTicketDAO comentarioDAO =
            new ComentarioTicketDAO();

    private static final String ORIGEN_ANGULAR =
            "https://sts-angular.onrender.com";

    private static final SimpleDateFormat FORMATO_FECHA =
            new SimpleDateFormat("dd/MM/yyyy HH:mm");

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

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        configurarRespuesta(response);

        try {

            String idTicketTexto
                    = request.getParameter("idTicket");

            if (idTicketTexto == null
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
                idTicket = Integer.parseInt(idTicketTexto);

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
            String accion = request.getParameter("accion");

            if ("cantidad".equals(accion)) {

                int cantidad
                        = comentarioDAO.contarComentariosPorTicket(idTicket);

                JsonObject json = new JsonObject();

                json.addProperty("exito", true);
                json.addProperty("cantidad", cantidad);

                enviarJson(
                        response,
                        HttpServletResponse.SC_OK,
                        json
                );

                return;
            }
            List<ComentarioTicket> comentarios
                    = comentarioDAO.listarPorTicket(idTicket);

            List<ComentarioTicketResponse> comentariosApi
                    = convertirLista(comentarios);

            ComentarioApiResponse respuesta
                    = new ComentarioApiResponse(
                            true,
                            "Comentarios obtenidos correctamente.",
                            comentariosApi
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
                    "Ocurrió un error al consultar los comentarios."
            );
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        configurarRespuesta(response);

        try {

            /*
             * Angular utilizará la misma sesión iniciada
             * en el sistema JSP.
             */
            HttpSession session
                    = request.getSession(false);

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

            String cuerpo = leerCuerpo(request);

            if (cuerpo == null || cuerpo.trim().isEmpty()) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "La solicitud no contiene información."
                );
                return;
            }

            JsonObject json =
                    JsonParser.parseString(cuerpo)
                            .getAsJsonObject();

            if (
                    !json.has("idTicket")
                    || !json.has("comentario")
            ) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Debe indicar el ticket y el comentario."
                );
                return;
            }

            int idTicket =
                    json.get("idTicket").getAsInt();

            String textoComentario =
                    json.get("comentario")
                            .getAsString()
                            .trim();

            if (idTicket <= 0) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El idTicket no es válido."
                );
                return;
            }

            if (textoComentario.isEmpty()) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El comentario no puede estar vacío."
                );
                return;
            }

            if (textoComentario.length() > 500) {
                enviarError(
                        response,
                        HttpServletResponse.SC_BAD_REQUEST,
                        "El comentario no puede superar los 500 caracteres."
                );
                return;
            }

            ComentarioTicket comentario =
                    new ComentarioTicket();

            comentario.setIdTicket(idTicket);

            /*
             * Verifica el nombre real de este getter
             * dentro de tu bean Usuario.
             */
            comentario.setIdUsuario(
                    usuario.getIdUsuario()
            );

            comentario.setComentario(textoComentario);

            int idComentario =
                    comentarioDAO.registrar(comentario);

            ComentarioTicket comentarioGuardado =
                    comentarioDAO.buscarPorId(idComentario);

            if (comentarioGuardado == null) {
                enviarError(
                        response,
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "El comentario se registró, pero no pudo recuperarse."
                );
                return;
            }

            ComentarioTicketResponse comentarioApi =
                    convertirComentario(
                            comentarioGuardado
                    );

            JsonObject respuesta = new JsonObject();

            respuesta.addProperty("exito", true);

            respuesta.addProperty(
                    "mensaje",
                    "Comentario publicado correctamente."
            );

            respuesta.add(
                    "comentario",
                    gson.toJsonTree(comentarioApi)
            );

            enviarJson(
                    response,
                    HttpServletResponse.SC_CREATED,
                    respuesta
            );

        } catch (Exception e) {

            e.printStackTrace();

            enviarError(
                    response,
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Ocurrió un error al registrar el comentario."
            );
        }
    }

    private List<ComentarioTicketResponse> convertirLista(
            List<ComentarioTicket> comentarios
    ) {

        List<ComentarioTicketResponse> resultado =
                new ArrayList<>();

        for (ComentarioTicket comentario : comentarios) {
            resultado.add(
                    convertirComentario(comentario)
            );
        }

        return resultado;
    }

    private ComentarioTicketResponse convertirComentario(
            ComentarioTicket comentario
    ) {

        String fecha = null;

        if (comentario.getFechaComentario() != null) {
            fecha = FORMATO_FECHA.format(
                    comentario.getFechaComentario()
            );
        }

        return new ComentarioTicketResponse(
        comentario.getIdComentario(),
        comentario.getIdTicket(),
        comentario.getIdUsuario(),
        comentario.getNombreUsuario(),
        comentario.getRol(),
        comentario.getComentario(),
        fecha
);
    }

    private String leerCuerpo(
            HttpServletRequest request
    ) throws IOException {

        StringBuilder cuerpo = new StringBuilder();

        try (
                BufferedReader reader =
                        request.getReader()
        ) {

            String linea;

            while ((linea = reader.readLine()) != null) {
                cuerpo.append(linea);
            }
        }

        return cuerpo.toString();
    }

    private void configurarRespuesta(
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

        JsonObject error = new JsonObject();

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
            out.print(gson.toJson(contenido));
            out.flush();
        }
    }
}