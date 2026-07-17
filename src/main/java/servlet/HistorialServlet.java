package servlet;

import bean.Usuario;
import dao.HistorialTicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/HistorialServlet")
public class HistorialServlet extends HttpServlet {

    HistorialTicketDAO historialDAO = new HistorialTicketDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            HttpSession session = request.getSession(false);
            Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

            if (usuario == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            if (!"ADMIN".equals(usuario.getNombreRol())) {
                response.sendRedirect("accesoDenegado.jsp");
                return;
            }

            request.setAttribute("historial", historialDAO.listarResumenPorTicket());
            request.getRequestDispatcher("admin/historialTickets.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}