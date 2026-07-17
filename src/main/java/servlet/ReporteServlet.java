package servlet;

import bean.Usuario;
import dao.ReporteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ReporteServlet")
public class ReporteServlet extends HttpServlet {

    ReporteDAO dao = new ReporteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");

        try {
            HttpSession session = request.getSession(false);
            Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

            if (usuario == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            if (!usuario.getNombreRol().equals("ADMIN")) {
                response.sendRedirect("accesoDenegado.jsp");
                return;
            }

            if (accion == null || accion.equals("tiempos")) {

                request.setAttribute("reporteTiempos", dao.reporteTiempos());
                request.getRequestDispatcher("admin/reportes.jsp")
                        .forward(request, response);

            } else {
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}