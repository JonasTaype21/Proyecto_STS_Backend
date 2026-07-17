package servlet;

import api.dto.SesionApiResponse;
import bean.Usuario;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

@WebServlet("/api/sesion")
public class SesionApiServlet extends HttpServlet {

    private final Gson gson = new Gson();

    private static final String ORIGEN_ANGULAR =
            "https://sts-angular.onrender.com";

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

        configurarRespuesta(response);

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            SesionApiResponse respuesta =
                    crearRespuestaNoAutenticada(
                            "La sesión no existe o ha expirado."
                    );

            enviarJson(
                    response,
                    HttpServletResponse.SC_UNAUTHORIZED,
                    respuesta
            );

            return;
        }

        Usuario usuario =
                (Usuario) session.getAttribute("usuario");

        if (usuario == null) {

            SesionApiResponse respuesta =
                    crearRespuestaNoAutenticada(
                            "No existe un usuario autenticado."
                    );

            enviarJson(
                    response,
                    HttpServletResponse.SC_UNAUTHORIZED,
                    respuesta
            );

            return;
        }

        SesionApiResponse respuesta =
                new SesionApiResponse();

        respuesta.setAutenticado(true);
        respuesta.setMensaje(
                "Sesión obtenida correctamente."
        );

        respuesta.setIdUsuario(
                usuario.getIdUsuario()
        );

        respuesta.setNombres(
                usuario.getNombres()
        );

        respuesta.setApellidos(
                usuario.getApellidos()
        );

        respuesta.setNombreCompleto(
                construirNombreCompleto(usuario)
        );

        /*
         * Si tu bean Usuario posee getCorreo(),
         * conserva esta línea.
         */
        respuesta.setCorreo(
                usuario.getCorreo()
        );

        respuesta.setRol(
                usuario.getNombreRol()
        );

        enviarJson(
                response,
                HttpServletResponse.SC_OK,
                respuesta
        );
    }

    private String construirNombreCompleto(
            Usuario usuario
    ) {

        String nombres =
                usuario.getNombres() == null
                        ? ""
                        : usuario.getNombres().trim();

        String apellidos =
                usuario.getApellidos() == null
                        ? ""
                        : usuario.getApellidos().trim();

        return (
                nombres + " " + apellidos
        ).trim();
    }

    private SesionApiResponse crearRespuestaNoAutenticada(
            String mensaje
    ) {

        SesionApiResponse respuesta =
                new SesionApiResponse();

        respuesta.setAutenticado(false);
        respuesta.setMensaje(mensaje);
        respuesta.setIdUsuario(null);
        respuesta.setNombres(null);
        respuesta.setApellidos(null);
        respuesta.setNombreCompleto(null);
        respuesta.setCorreo(null);
        respuesta.setRol(null);

        return respuesta;
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
                "GET, OPTIONS"
        );

        response.setHeader(
                "Access-Control-Allow-Headers",
                "Content-Type, Accept"
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