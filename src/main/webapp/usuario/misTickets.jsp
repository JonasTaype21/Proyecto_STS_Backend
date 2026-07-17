<%@page import="java.util.List"%>
<%@page import="bean.Ticket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Ticket> lista = (List<Ticket>) request.getAttribute("listaTickets");
    String modo = request.getParameter("modo");
    boolean esSeguimiento = "seguimiento".equals(modo);
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title><%= esSeguimiento ? "Seguimiento de Tickets" : "Mis Tickets" %></title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>

    <body class="iframe-body">

        <div class="iframe-content">

            <h1><%= esSeguimiento ? "Seguimiento de Tickets" : "Mis Tickets" %></h1>

            <table class="tabla-historial">
                <tr>
                    <th>Código</th>
                    <th>Categoría</th>
                    <th>Título</th>
                    <th>Prioridad</th>
                    <th>Estado</th>
                    <th>Técnico</th>
                    <th>Acciones</th>
                </tr>

                <% if (lista != null) {
            for (Ticket t : lista) { %>

                <tr>
                    <td><strong><%= t.getCodigoTicket() %></strong></td>
                    <td><%= t.getNombreCategoria() %></td>
                    <td><%= t.getTitulo() %></td>
                    <td><span class="badge"><%= t.getPrioridad() %></span></td>
                    <td><span class="estado-activo"><%= t.getEstado() %></span></td>
                    <td><%= t.getTecnicoAsignado() == null ? "Sin asignar" : t.getTecnicoAsignado() %></td>
                    <td>
                        <% if (esSeguimiento) { %>

                        <a href="${pageContext.request.contextPath}/TicketServlet?accion=seguimientoTicket&id=<%= t.getIdTicket() %>"
                           target="panelUsuarioFrame">
                            Ver seguimiento
                        </a>

                        <% } else { %>

                        <a href="${pageContext.request.contextPath}/TicketServlet?accion=detalle&id=<%= t.getIdTicket() %>"
                           target="panelUsuarioFrame">
                            Detalle
                        </a>

                        <br>

                        <a
                            href="http://localhost:4200/tickets/<%= t.getIdTicket() %>?origen=usuario"
                            target="_top">

                            Seguimiento STS

                        </a>

                        <% } %>
                    </td>
                </tr>

                <% }} %>
            </table>

        </div>

    </body>
</html>