package servlet;

import bean.Usuario;
import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");

        try {
            Usuario usuario = dao.validarLogin(correo, clave);

            if (usuario == null) {
                request.setAttribute("error", "Correo o contraseña incorrectos.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);

            String rol = usuario.getNombreRol();

            if (rol.equals("ADMIN")) {
                response.sendRedirect("admin/dashboardAdmin.jsp");
            } else if (rol.equals("USUARIO")) {
                response.sendRedirect("usuario/dashboardUsuario.jsp");
            } else if (rol.equals("TECNICO")) {
                response.sendRedirect("tecnico/dashboardTecnico.jsp");
            } else {
                request.setAttribute("error", "Rol no válido.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}