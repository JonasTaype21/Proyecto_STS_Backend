<%@page import="java.util.List"%>
<%@page import="bean.Ticket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Ticket> lista =
            (List<Ticket>) request.getAttribute("listaTickets");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tickets Asignados</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>

    <body class="iframe-body">

        <div class="iframe-content">

            <h1>Tickets Asignados</h1>

            <div class="table-wrapper">
                <table class="tabla-historial">

                    <tr>
                        <th>Código</th>
                        <th>Usuario</th>
                        <th>Categoría</th>
                        <th>Título</th>
                        <th>Prioridad</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>

                    <% if (lista != null && !lista.isEmpty()) {

                        for (Ticket t : lista) {
                    %>

                    <tr>
                        <td>
                            <strong><%= t.getCodigoTicket() %></strong>
                        </td>

                        <td><%= t.getUsuarioReporta() %></td>

                        <td><%= t.getNombreCategoria() %></td>

                        <td><%= t.getTitulo() %></td>

                        <td>
                            <span class="badge">
                                <%= t.getPrioridad() %>
                            </span>
                        </td>

                        <td>
                            <span class="estado-activo">
                                <%= t.getEstado() %>
                            </span>
                        </td>

                        <td>
                            <!-- Abre el detalle reemplazando esta tabla -->
                            <a href="${pageContext.request.contextPath}/TicketServlet?accion=detalle&id=<%= t.getIdTicket() %>"
                               target="_self">
                                Detalle
                            </a>

                            <br>

                            <a
                                href="http://localhost:4200/tickets/<%= t.getIdTicket() %>?origen=tecnico"
                                target="_top">

                                Centro STS

                            </a>

                            <!-- Solo se puede atender si está asignado o en proceso -->
                            <% if ("ASIGNADO".equals(t.getEstado())
                                || "EN_PROCESO".equals(t.getEstado())) { %>

                            <a href="${pageContext.request.contextPath}/TicketServlet?accion=atender&id=<%= t.getIdTicket() %>"
                               target="_self">
                                Atender
                            </a>

                            <% } %>
                        </td>
                    </tr>

                    <%  }

                    } else { %>

                    <tr>
                        <td colspan="7" style="text-align:center;">
                            No tienes tickets asignados actualmente.
                        </td>
                    </tr>

                    <% } %>

                </table>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>