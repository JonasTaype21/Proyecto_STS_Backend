package servlet;

import bean.HistorialTicket;
import bean.SolucionTicket;
import bean.Ticket;
import bean.Usuario;
import dao.CategoriaDAO;
import dao.HistorialTicketDAO;
import dao.SolucionTicketDAO;
import dao.TicketDAO;
import dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/TicketServlet")
public class TicketServlet extends HttpServlet {

    TicketDAO ticketDAO = new TicketDAO();
    CategoriaDAO categoriaDAO = new CategoriaDAO();
    UsuarioDAO usuarioDAO = new UsuarioDAO();
    HistorialTicketDAO historialDAO = new HistorialTicketDAO();
    SolucionTicketDAO solucionDAO = new SolucionTicketDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion");

        try {
            HttpSession session = request.getSession(false);
            Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

            if (usuario == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            if (accion == null || accion.equals("listar")) {

                if (!usuario.getNombreRol().equals("ADMIN")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                request.setAttribute("listaTickets", ticketDAO.listarTodos());
                request.getRequestDispatcher("admin/listarTickets.jsp")
                        .forward(request, response);

            } else if (accion.equals("nuevo")) {

                if (!usuario.getNombreRol().equals("USUARIO")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                request.setAttribute("listaCategorias", categoriaDAO.listarActivas());
                request.getRequestDispatcher("usuario/registrarTicket.jsp")
                        .forward(request, response);

            } else if (accion.equals("misTickets")) {

                if (!usuario.getNombreRol().equals("USUARIO")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                request.setAttribute("listaTickets", ticketDAO.listarPorUsuario(usuario.getIdUsuario()));
                request.getRequestDispatcher("usuario/misTickets.jsp")
                        .forward(request, response);

            } else if (accion.equals("asignar")) {

                if (!usuario.getNombreRol().equals("ADMIN")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                int idTicket = Integer.parseInt(request.getParameter("id"));

                request.setAttribute("ticket", ticketDAO.obtener(idTicket));
                request.setAttribute("listaTecnicos", usuarioDAO.listarTecnicos());

                request.getRequestDispatcher("admin/asignarTecnico.jsp")
                        .forward(request, response);

            } else if (accion.equals("ticketsAsignados")) {

                if (!usuario.getNombreRol().equals("TECNICO")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                request.setAttribute("listaTickets", ticketDAO.listarPorTecnico(usuario.getIdUsuario()));
                request.getRequestDispatcher("tecnico/ticketsAsignados.jsp")
                        .forward(request, response);

            } else if (accion.equals("atender")) {

                if (!usuario.getNombreRol().equals("TECNICO")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                int idTicket = Integer.parseInt(request.getParameter("id"));

                Ticket ticket = ticketDAO.obtener(idTicket);

                if (ticket == null || ticket.getIdTecnico() != usuario.getIdUsuario()) {
                    response.sendRedirect("TicketServlet?accion=ticketsAsignados");
                    return;
                }

                request.setAttribute("ticket", ticket);
                request.getRequestDispatcher("tecnico/atenderTicket.jsp")
                        .forward(request, response);

            } else if (accion.equals("detalle")) {

                int idTicket = Integer.parseInt(request.getParameter("id"));

                request.setAttribute("ticket", ticketDAO.obtener(idTicket));
                request.setAttribute("historial", historialDAO.listarPorTicket(idTicket));
                request.setAttribute("solucion", solucionDAO.obtenerPorTicket(idTicket));

                if (usuario.getNombreRol().equals("ADMIN")) {
                    request.getRequestDispatcher("admin/detalleTicket.jsp")
                            .forward(request, response);
                } else if (usuario.getNombreRol().equals("TECNICO")) {
                    request.getRequestDispatcher("tecnico/detalleTicket.jsp")
                            .forward(request, response);
                } else {
                    request.getRequestDispatcher("usuario/detalleTicket.jsp")
                            .forward(request, response);
                }

            } else if (accion.equals("seguimientoUsuario")) {

                if (!usuario.getNombreRol().equals("USUARIO")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                List<HistorialTicket> historial = historialDAO.listarResumenPorUsuario(usuario.getIdUsuario());

                request.setAttribute("historial", historial);

                request.getRequestDispatcher("usuario/seguimientoTickets.jsp")
                        .forward(request, response);

            } else if (accion.equals("seguimientoTicket")) {

                int idTicket = Integer.parseInt(request.getParameter("id"));

                request.setAttribute("ticket", ticketDAO.obtener(idTicket));
                request.setAttribute("historial", historialDAO.listarPorTicket(idTicket));
                request.setAttribute("solucion", solucionDAO.obtenerPorTicket(idTicket));

                request.getRequestDispatcher("usuario/seguimientoTicket.jsp")
                        .forward(request, response);

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
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");

        try {
            HttpSession session = request.getSession(false);
            Usuario usuario = (session != null) ? (Usuario) session.getAttribute("usuario") : null;

            if (usuario == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            if (accion.equals("registrar")) {

                if (!usuario.getNombreRol().equals("USUARIO")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                String titulo = request.getParameter("titulo");
                String descripcion = request.getParameter("descripcion");
                String prioridad = request.getParameter("prioridad");
                String idCategoriaTxt = request.getParameter("idCategoria");

                if (campoVacio(titulo) || campoVacio(descripcion) || campoVacio(prioridad) || campoVacio(idCategoriaTxt)) {
                    request.setAttribute("error", "Todos los campos son obligatorios.");
                    request.setAttribute("listaCategorias", categoriaDAO.listarActivas());
                    request.getRequestDispatcher("usuario/registrarTicket.jsp")
                            .forward(request, response);
                    return;
                }

                Ticket t = new Ticket();
                t.setCodigoTicket(ticketDAO.generarCodigoTicket());
                t.setIdUsuario(usuario.getIdUsuario());
                t.setIdCategoria(Integer.parseInt(idCategoriaTxt));
                t.setTitulo(titulo.trim());
                t.setDescripcion(descripcion.trim());
                t.setPrioridad(prioridad);

                ticketDAO.registrar(t);

                Ticket ticketRegistrado = ticketDAO.obtenerPorCodigo(t.getCodigoTicket());

                HistorialTicket h = new HistorialTicket();
                h.setIdTicket(ticketRegistrado.getIdTicket());
                h.setIdUsuario(usuario.getIdUsuario());
                h.setEstadoAnterior(null);
                h.setEstadoNuevo("ABIERTO");
                h.setAccion("Ticket registrado");
                h.setComentario("El usuario registró una nueva solicitud de soporte.");
                historialDAO.registrar(h);

                response.sendRedirect("usuario/dashboardUsuario.jsp?vista=misTickets");

            } else if (accion.equals("asignar")) {

                if (!usuario.getNombreRol().equals("ADMIN")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                int idTicket = Integer.parseInt(request.getParameter("idTicket"));
                int idTecnico = Integer.parseInt(request.getParameter("idTecnico"));

                Ticket ticket = ticketDAO.obtener(idTicket);

                if (ticket == null || idTecnico <= 0) {
                    response.sendRedirect("TicketServlet?accion=listar");
                    return;
                }

                if (ticket.getEstado().equals("CERRADO") || ticket.getEstado().equals("RESUELTO")) {
                    response.sendRedirect("TicketServlet?accion=listar");
                    return;
                }

                ticketDAO.asignarTecnico(idTicket, idTecnico);

                HistorialTicket h = new HistorialTicket();
                h.setIdTicket(idTicket);
                h.setIdUsuario(usuario.getIdUsuario());
                h.setEstadoAnterior(ticket.getEstado());
                h.setEstadoNuevo("ASIGNADO");
                h.setAccion("Técnico asignado");
                h.setComentario("El administrador asignó un técnico responsable.");
                historialDAO.registrar(h);

                response.sendRedirect("TicketServlet?accion=listar&asignado=ok");

            } else if (accion.equals("iniciar")) {

                if (!usuario.getNombreRol().equals("TECNICO")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                int idTicket = Integer.parseInt(request.getParameter("idTicket"));

                Ticket ticket = ticketDAO.obtener(idTicket);

                if (ticket == null || ticket.getIdTecnico() != usuario.getIdUsuario()) {
                    response.sendRedirect("TicketServlet?accion=ticketsAsignados");
                    return;
                }

                if (!ticket.getEstado().equals("ASIGNADO")) {
                    response.sendRedirect("TicketServlet?accion=ticketsAsignados");
                    return;
                }

                ticketDAO.iniciarAtencion(idTicket, usuario.getIdUsuario());

                HistorialTicket h = new HistorialTicket();
                h.setIdTicket(idTicket);
                h.setIdUsuario(usuario.getIdUsuario());
                h.setEstadoAnterior(ticket.getEstado());
                h.setEstadoNuevo("EN_PROCESO");
                h.setAccion("Atención iniciada");
                h.setComentario("El técnico inició la atención del ticket.");
                historialDAO.registrar(h);

                response.sendRedirect("TicketServlet?accion=ticketsAsignados");

            } else if (accion.equals("solucionar")) {

                if (!usuario.getNombreRol().equals("TECNICO")) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                int idTicket = Integer.parseInt(request.getParameter("idTicket"));
                String diagnostico = request.getParameter("diagnostico");
                String solucionAplicada = request.getParameter("solucionAplicada");
                String observaciones = request.getParameter("observaciones");

                Ticket ticket = ticketDAO.obtener(idTicket);

                if (ticket == null || ticket.getIdTecnico() != usuario.getIdUsuario()) {
                    response.sendRedirect("TicketServlet?accion=ticketsAsignados");
                    return;
                }

                if (!ticket.getEstado().equals("EN_PROCESO")) {
                    request.setAttribute("error", "Solo se puede registrar solución si el ticket está EN PROCESO.");
                    request.setAttribute("ticket", ticket);
                    request.getRequestDispatcher("tecnico/atenderTicket.jsp")
                            .forward(request, response);
                    return;
                }

                if (campoVacio(diagnostico) || campoVacio(solucionAplicada)) {
                    request.setAttribute("error", "El diagnóstico y la solución son obligatorios.");
                    request.setAttribute("ticket", ticket);
                    request.getRequestDispatcher("tecnico/atenderTicket.jsp")
                            .forward(request, response);
                    return;
                }

                SolucionTicket solucion = new SolucionTicket();
                solucion.setIdTicket(idTicket);
                solucion.setIdTecnico(usuario.getIdUsuario());
                solucion.setDiagnostico(diagnostico.trim());
                solucion.setSolucionAplicada(solucionAplicada.trim());
                solucion.setObservaciones(observaciones);

                solucionDAO.registrar(solucion);
                ticketDAO.marcarResuelto(idTicket, usuario.getIdUsuario());

                HistorialTicket h = new HistorialTicket();
                h.setIdTicket(idTicket);
                h.setIdUsuario(usuario.getIdUsuario());
                h.setEstadoAnterior(ticket.getEstado());
                h.setEstadoNuevo("RESUELTO");
                h.setAccion("Solución registrada");
                h.setComentario("El técnico registró la solución aplicada y marcó el ticket como resuelto.");
                historialDAO.registrar(h);

                response.sendRedirect("TicketServlet?accion=ticketsAsignados");

            } else if (accion.equals("cerrar")) {

                int idTicket = Integer.parseInt(request.getParameter("idTicket"));
                String comentarioCierre = request.getParameter("comentarioCierre");

                Ticket ticket = ticketDAO.obtener(idTicket);

                if (ticket == null) {
                    response.sendRedirect("TicketServlet?accion=misTickets");
                    return;
                }

                boolean puedeCerrar = usuario.getNombreRol().equals("ADMIN")
                        || ticket.getIdUsuario() == usuario.getIdUsuario();

                if (!puedeCerrar) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                if (!ticket.getEstado().equals("RESUELTO")) {
                    response.sendRedirect("TicketServlet?accion=detalle&id=" + idTicket);
                    return;
                }

                if (campoVacio(comentarioCierre)) {
                    comentarioCierre = "El ticket fue cerrado después de validar la atención.";
                }

                ticketDAO.cerrarTicket(idTicket);

                HistorialTicket h = new HistorialTicket();
                h.setIdTicket(idTicket);
                h.setIdUsuario(usuario.getIdUsuario());
                h.setEstadoAnterior(ticket.getEstado());
                h.setEstadoNuevo("CERRADO");
                h.setAccion("Ticket cerrado");
                h.setComentario(comentarioCierre.trim());
                historialDAO.registrar(h);

                String origen = request.getParameter("origen");

                if ("seguimiento".equals(origen)) {

                    List<HistorialTicket> historial
                            = historialDAO.listarResumenPorUsuario(usuario.getIdUsuario());

                    request.setAttribute("historial", historial);

                    request.getRequestDispatcher("usuario/seguimientoTickets.jsp")
                            .forward(request, response);
                    return;

                } else {
                    response.sendRedirect("TicketServlet?accion=detalle&id=" + idTicket);
                    return;
                }

            } else if (accion.equals("reabrir")) {

                int idTicket = Integer.parseInt(request.getParameter("idTicket"));
                String motivo = request.getParameter("motivo");

                Ticket ticket = ticketDAO.obtener(idTicket);

                if (ticket == null) {
                    response.sendRedirect("TicketServlet?accion=misTickets");
                    return;
                }

                boolean puedeReabrir = usuario.getNombreRol().equals("ADMIN")
                        || ticket.getIdUsuario() == usuario.getIdUsuario();

                if (!puedeReabrir) {
                    response.sendRedirect("accesoDenegado.jsp");
                    return;
                }

                if (!ticket.getEstado().equals("RESUELTO") && !ticket.getEstado().equals("CERRADO")) {
                    response.sendRedirect("TicketServlet?accion=detalle&id=" + idTicket);
                    return;
                }

                if (campoVacio(motivo)) {
                    response.sendRedirect("TicketServlet?accion=detalle&id=" + idTicket);
                    return;
                }

                ticketDAO.reabrirTicket(idTicket);

                HistorialTicket h = new HistorialTicket();
                h.setIdTicket(idTicket);
                h.setIdUsuario(usuario.getIdUsuario());
                h.setEstadoAnterior(ticket.getEstado());
                h.setEstadoNuevo("REABIERTO");
                h.setAccion("Ticket reabierto");
                h.setComentario(motivo.trim());
                historialDAO.registrar(h);

                response.sendRedirect("TicketServlet?accion=detalle&id=" + idTicket);

            } else {
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private boolean campoVacio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }
}
