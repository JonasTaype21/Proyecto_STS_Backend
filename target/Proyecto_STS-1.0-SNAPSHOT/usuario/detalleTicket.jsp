<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bean.Ticket"%>
<%@page import="bean.HistorialTicket"%>
<%@page import="bean.SolucionTicket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Ticket ticket = (Ticket) request.getAttribute("ticket");
    List<HistorialTicket> historial = (List<HistorialTicket>) request.getAttribute("historial");
    SolucionTicket solucion = (SolucionTicket) request.getAttribute("solucion");
    String seguimiento = request.getParameter("seguimiento");
    
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Detalle del Ticket</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>

    <body class="iframe-body">

        <div class="iframe-content">

            <h1>Detalle del Ticket</h1>
            
            <div class="detalle-card">
                <h2><%= ticket.getCodigoTicket() %> - <%= ticket.getTitulo() %></h2>

                <div class="detalle-grid">
                    <p><strong>Categoría:</strong> <%= ticket.getNombreCategoria() %></p>
                    <p><strong>Prioridad:</strong> <%= ticket.getPrioridad() %></p>
                    <p><strong>Estado:</strong> <span class="estado-activo"><%= ticket.getEstado() %></span></p>
                    <p><strong>Técnico:</strong> <%= ticket.getTecnicoAsignado() == null ? "Sin asignar" : ticket.getTecnicoAsignado() %></p>
                    <p><strong>Fecha creación:</strong> <%= ticket.getFechaCreacion() == null ? "-" : formatoFecha.format(ticket.getFechaCreacion()) %></p>
                </div>

                <p><strong>Descripción:</strong> <%= ticket.getDescripcion() %></p>
            </div>

            <div class="detalle-card">
                <h2>Solución</h2>

                <% if (solucion != null) { %>
                <p><strong>Diagnóstico:</strong> <%= solucion.getDiagnostico() %></p>
                <p><strong>Solución aplicada:</strong> <%= solucion.getSolucionAplicada() %></p>
                <p><strong>Observaciones:</strong> <%= solucion.getObservaciones() %></p>
                <p><strong>Fecha solución:</strong> <%= solucion.getFechaSolucion() == null ? "-" : formatoFecha.format(solucion.getFechaSolucion()) %></p>
                <% } else { %>
                <p>Aún no se ha registrado solución.</p>
                <% } %>
            </div>
            
            <% if ("si".equals(seguimiento)) { %>
            <div class="detalle-card">
                <h2>Seguimiento del Ticket</h2>

                <table class="tabla-historial">
                    <tr>
                        <th>Etapa</th>
                        <th>Estado anterior</th>
                        <th>Estado nuevo</th>
                        <th>Fecha</th>
                        <th>Responsable</th>
                        <th>Comentario</th>
                    </tr>

                    <% if (historial != null) {
                for (HistorialTicket h : historial) { %>

                    <tr>
                        <td><strong><%= h.getAccion() %></strong></td>
                        <td><%= h.getEstadoAnterior() == null ? "-" : h.getEstadoAnterior() %></td>
                        <td><span class="estado-activo"><%= h.getEstadoNuevo() %></span></td>
                        <td><%= h.getFechaAccion() == null ? "-" : formatoFecha.format(h.getFechaAccion()) %></td>
                        <td><%= h.getNombreUsuario() %></td>
                        <td><%= h.getComentario() %></td>
                    </tr>

                    <% }} %>
                </table>
            </div>
        <% } %>
            <% if ("RESUELTO".equals(ticket.getEstado()) && "si".equals(seguimiento)) { %>

            <div class="detalle-card">
                <h2>Acciones del ticket</h2>

                <form action="${pageContext.request.contextPath}/TicketServlet" method="post">
                    <input type="hidden" name="accion" value="cerrar">
                    <input type="hidden" name="idTicket" value="<%= ticket.getIdTicket() %>">

                    <button type="submit" onclick="return confirm('¿Deseas cerrar este ticket?');">
                        Cerrar ticket
                    </button>
                </form>

                <form action="${pageContext.request.contextPath}/TicketServlet" method="post">
                    <input type="hidden" name="accion" value="reabrir">
                    <input type="hidden" name="idTicket" value="<%= ticket.getIdTicket() %>">

                    <label>Motivo para reabrir:</label>
                    <textarea name="motivo" rows="3" required></textarea>

                    <button type="submit" onclick="return confirm('¿Deseas reabrir este ticket?');">
                        Reabrir ticket
                    </button>
                </form>
            </div>

            <% } %>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>