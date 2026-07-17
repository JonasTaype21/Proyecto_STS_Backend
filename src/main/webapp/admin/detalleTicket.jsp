<%@page import="java.util.List"%>
<%@page import="bean.Ticket"%>
<%@page import="bean.HistorialTicket"%>
<%@page import="bean.SolucionTicket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Ticket ticket = (Ticket) request.getAttribute("ticket");
    List<HistorialTicket> historial = (List<HistorialTicket>) request.getAttribute("historial");
    SolucionTicket solucion = (SolucionTicket) request.getAttribute("solucion");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Detalle del Ticket</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>
    <body class="iframe-body">

        <div class="iframe-content">
            <h1>Detalle del Ticket</h1>

            <h2><%= ticket.getCodigoTicket() %> - <%= ticket.getTitulo() %></h2>

            <p><strong>Usuario:</strong> <%= ticket.getUsuarioReporta() %></p>
            <p><strong>Técnico:</strong> <%= ticket.getTecnicoAsignado() == null ? "Sin asignar" : ticket.getTecnicoAsignado() %></p>
            <p><strong>Categoría:</strong> <%= ticket.getNombreCategoria() %></p>
            <p><strong>Prioridad:</strong> <%= ticket.getPrioridad() %></p>
            <p><strong>Estado:</strong> <%= ticket.getEstado() %></p>
            <p><strong>Descripción:</strong> <%= ticket.getDescripcion() %></p>
            <p><strong>Fecha creación:</strong> <%= ticket.getFechaCreacion() %></p>

            <hr>

            <h2>Solución</h2>

            <% if (solucion != null) { %>
            <p><strong>Diagnóstico:</strong> <%= solucion.getDiagnostico() %></p>
            <p><strong>Solución aplicada:</strong> <%= solucion.getSolucionAplicada() %></p>
            <p><strong>Observaciones:</strong> <%= solucion.getObservaciones() %></p>
            <p><strong>Fecha solución:</strong> <%= solucion.getFechaSolucion() %></p>
            <% } else { %>
            <p>Aún no se ha registrado solución.</p>
            <% } %>

            <hr>

            <% if ("RESUELTO".equals(ticket.getEstado())) { %>
            <form action="${pageContext.request.contextPath}/TicketServlet" method="post">
                <input type="hidden" name="accion" value="cerrar">
                <input type="hidden" name="idTicket" value="<%= ticket.getIdTicket() %>">
                <button type="submit" onclick="return confirm('¿Deseas cerrar este ticket?');">Cerrar ticket</button>
            </form>
            <% } %>

            <br>

            <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
        </div>
    </body>
</html>