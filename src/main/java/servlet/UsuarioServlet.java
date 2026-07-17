package servlet;

import bean.Usuario;
import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLIntegrityConstraintViolationException;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        try {
            if (accion == null || accion.equals("listar")) {

                request.setAttribute("listaUsuarios", dao.listar());
                request.getRequestDispatcher("admin/gestionarUsuarios.jsp")
                        .forward(request, response);

            } else if (accion.equals("nuevo")) {

                request.removeAttribute("usuarioEditar");
                request.getRequestDispatcher("admin/formUsuario.jsp")
                        .forward(request, response);

            } else if (accion.equals("editar")) {

                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("usuarioEditar", dao.obtener(id));
                request.getRequestDispatcher("admin/formUsuario.jsp")
                        .forward(request, response);

            } else if (accion.equals("eliminar")) {

                int id = Integer.parseInt(request.getParameter("id"));
                dao.eliminarLogico(id);
                response.sendRedirect("UsuarioServlet?accion=listar");

            } else {
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        String idTxt = request.getParameter("idUsuario");

        Usuario u = new Usuario();

        u.setIdRol(Integer.parseInt(request.getParameter("idRol")));
        u.setNombres(request.getParameter("nombres"));
        u.setApellidos(request.getParameter("apellidos"));
        u.setCorreo(request.getParameter("correo"));
        u.setTelefono(request.getParameter("telefono"));
        u.setArea(request.getParameter("area"));
        u.setEspecialidad(request.getParameter("especialidad"));

        try {
            if (idTxt == null || idTxt.trim().isEmpty()) {

                u.setClave(request.getParameter("clave"));
                dao.agregar(u);

            } else {

                u.setIdUsuario(Integer.parseInt(idTxt));
                u.setEstado(Integer.parseInt(request.getParameter("estado")));
                dao.actualizar(u);
            }

            response.sendRedirect("UsuarioServlet?accion=listar");

        } catch (SQLIntegrityConstraintViolationException e) {

            request.setAttribute("error", "El correo ya se encuentra registrado.");
            request.setAttribute("usuarioEditar", u);
            request.getRequestDispatcher("admin/formUsuario.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}