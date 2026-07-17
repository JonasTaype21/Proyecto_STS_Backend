<%@page import="bean.Ticket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Ticket ticket = (Ticket) request.getAttribute("ticket");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Atender Ticket</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
        <link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>

    <body class="iframe-body">

        <div class="iframe-content">

            <% if (ticket == null) { %>

            <div class="detalle-card">
                <h2>Ticket no encontrado</h2>

                <a class="btn-panel"
                   href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados"
                   target="_self">
                    Volver a tickets
                </a>
            </div>

            <% } else { %>

            <div class="ticket-detail-header">

                <div>
                    <h1>Atender Ticket</h1>

                    <p>
                        <%= ticket.getCodigoTicket() %>
                        -
                        <%= ticket.getTitulo() %>
                    </p>
                </div>

                <span class="estado-activo">
                    <%= ticket.getEstado() %>
                </span>

            </div>

            <% if (request.getAttribute("error") != null) { %>

            <p style="color:red;">
                <%= request.getAttribute("error") %>
            </p>

            <% } %>

            <% if ("ASIGNADO".equals(ticket.getEstado())) { %>

            <!-- DOS COLUMNAS EN LA ETAPA INICIAL -->
            <div class="detalle-atencion-grid">

                <div>

                    <div class="detalle-card">

                        <h2>Información del ticket</h2>

                        <div class="info-grid">

                            <div>
                                <span>Usuario</span>
                                <strong><%= ticket.getUsuarioReporta() %></strong>
                            </div>

                            <div>
                                <span>Categoría</span>
                                <strong><%= ticket.getNombreCategoria() %></strong>
                            </div>

                            <div>
                                <span>Prioridad</span>
                                <strong><%= ticket.getPrioridad() %></strong>
                            </div>

                            <div>
                                <span>Estado</span>
                                <strong><%= ticket.getEstado() %></strong>
                            </div>

                        </div>

                    </div>

                </div>

                <div>

                    <div class="detalle-card">

                        <h2>Descripción del problema</h2>

                        <p><%= ticket.getDescripcion() %></p>

                    </div>

                    <div class="detalle-card">

                        <h2>Iniciar atención técnica</h2>

                        <p>
                            Al iniciar, el ticket cambiará de
                            <strong>ASIGNADO</strong> a
                            <strong>EN_PROCESO</strong>.
                        </p>

                        <form action="${pageContext.request.contextPath}/TicketServlet"
                              method="post">

                            <input type="hidden"
                                   name="accion"
                                   value="iniciar">

                            <input type="hidden"
                                   name="idTicket"
                                   value="<%= ticket.getIdTicket() %>">

                            <button type="submit"
                                    onclick="return confirm('¿Deseas iniciar la atención?');">
                                Iniciar atención
                            </button>

                        </form>

                    </div>

                </div>

            </div>

            <% } else if ("EN_PROCESO".equals(ticket.getEstado())) { %>

            <!-- IZQUIERDA INFORMACIÓN / DERECHA SOLUCIÓN -->
            <div class="detalle-atencion-grid">

                <div>

                    <div class="detalle-card">

                        <h2>Información del ticket</h2>

                        <div class="info-grid">

                            <div>
                                <span>Usuario</span>
                                <strong><%= ticket.getUsuarioReporta() %></strong>
                            </div>

                            <div>
                                <span>Categoría</span>
                                <strong><%= ticket.getNombreCategoria() %></strong>
                            </div>

                            <div>
                                <span>Prioridad</span>
                                <strong><%= ticket.getPrioridad() %></strong>
                            </div>

                            <div>
                                <span>Estado</span>
                                <strong><%= ticket.getEstado() %></strong>
                            </div>

                        </div>

                    </div>

                    <div class="detalle-card">

                        <h2>Descripción del problema</h2>

                        <p><%= ticket.getDescripcion() %></p>

                    </div>

                </div>

                <div class="detalle-card">

                    <h2>Registrar solución</h2>

                    <p>
                        Registra el diagnóstico y la solución aplicada.
                    </p>

                    <form action="${pageContext.request.contextPath}/TicketServlet"
                          method="post">

                        <input type="hidden"
                               name="accion"
                               value="solucionar">

                        <input type="hidden"
                               name="idTicket"
                               value="<%= ticket.getIdTicket() %>">

                        <label>Diagnóstico:</label>

                        <textarea name="diagnostico"
                                  rows="4"
                                  required></textarea>

                        <label>Solución aplicada:</label>

                        <textarea name="solucionAplicada"
                                  rows="4"
                                  required></textarea>

                        <label>Observaciones:</label>

                        <textarea name="observaciones"
                                  rows="3"></textarea>

                        <div class="form-actions">

                            <button type="submit"
                                    onclick="return confirm('¿Deseas registrar la solución?');">
                                Registrar solución
                            </button>

                        </div>

                    </form>

                </div>

            </div>

            <% } %>

            <div class="detalle-card">

                <a href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados"
                   class="btn-panel">
                    <i class="fa-solid fa-arrow-left"></i>
                    Volver a tickets
                </a>

            </div>

            <% } %>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>