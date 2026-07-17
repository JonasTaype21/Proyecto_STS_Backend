<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bean.HistorialTicket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<HistorialTicket> historial =
            (List<HistorialTicket>) request.getAttribute("historial");

    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Seguimiento de Tickets</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>

    <body class="iframe-body">

        <div class="iframe-content">

            <h1>Seguimiento de Tickets</h1>

            <div class="detalle-card">
                <h2>Estado general de mis tickets</h2>

                <table class="tabla-historial">
                    <tr>
                        <th>Ticket</th>
                        <th>Categoría</th>
                        <th>Prioridad</th>
                        <th>Técnico</th>
                        <th>Creado</th>
                        <th>Asignado</th>
                        <th>En proceso</th>
                        <th>Resuelto</th>
                        <th>Cerrado</th>
                        <th>Estado actual</th>
                        <th>Acción</th>
                    </tr>

                    <% if (historial != null) {
                for (HistorialTicket h : historial) { %>

                    <tr>
                        <td><strong><%= h.getCodigoTicket() %></strong></td>
                        <td><%= h.getCategoria() %></td>
                        <td><span class="badge"><%= h.getPrioridad() %></span></td>
                        <td><%= h.getTecnicoAsignado() == null ? "Sin asignar" : h.getTecnicoAsignado() %></td>

                        <td><%= h.getFechaCreacion() == null ? "-" : formatoFecha.format(h.getFechaCreacion()) %></td>
                        <td><%= h.getFechaAsignacion() == null ? "-" : formatoFecha.format(h.getFechaAsignacion()) %></td>
                        <td><%= h.getFechaInicio() == null ? "-" : formatoFecha.format(h.getFechaInicio()) %></td>
                        <td><%= h.getFechaSolucion() == null ? "-" : formatoFecha.format(h.getFechaSolucion()) %></td>
                        <td><%= h.getFechaCierre() == null ? "-" : formatoFecha.format(h.getFechaCierre()) %></td>

                        <td>
                            <span class="estado-activo"><%= h.getEstadoActual() %></span>
                        </td>

                        <td>
                            <% if ("RESUELTO".equals(h.getEstadoActual())) { %>

                            <button type="button"
                                    onclick="abrirModalCierre('<%= h.getIdTicket() %>', '<%= h.getCodigoTicket() %>')">
                                Cerrar ticket
                            </button>

                            <% } else if ("CERRADO".equals(h.getEstadoActual())) { %>

                            Cerrado

                            <% } else { %>

                            En seguimiento

                            <% } %>
                        </td>
                    </tr>

                    <% }} %>
                </table>
            </div>

        </div>

        <div id="modalCierre" class="modal-cierre">
            <div class="modal-cierre-content">
                <h2>Cerrar ticket</h2>
                <p id="textoTicketCierre"></p>
              <form action="${pageContext.request.contextPath}/TicketServlet" method="post" target="panelUsuarioFrame">
                    <input type="hidden" name="accion" value="cerrar">
                    <input type="hidden" name="idTicket" id="idTicketCerrar">
                    <input type="hidden" name="origen" value="seguimiento">

                    <label>Comentario de cierre:</label>
                    <textarea name="comentarioCierre"
                              rows="4"
                              placeholder="Ejemplo: Validé la solución y el ticket puede cerrarse."
                              required></textarea>

                    <div class="modal-actions">
                        <button type="submit"
                                onclick="return confirm('¿Deseas cerrar este ticket?');">
                            Confirmar cierre
                        </button>

                        <button type="button" onclick="cerrarModalCierre()">
                            Cancelar
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function abrirModalCierre(idTicket, codigoTicket) {
                document.getElementById("idTicketCerrar").value = idTicket;
                document.getElementById("textoTicketCierre").innerText =
                        "Ticket seleccionado: " + codigoTicket;

                document.getElementById("modalCierre").style.display = "flex";
            }

            function cerrarModalCierre() {
                document.getElementById("modalCierre").style.display = "none";
            }
        </script>

    </body>
</html>