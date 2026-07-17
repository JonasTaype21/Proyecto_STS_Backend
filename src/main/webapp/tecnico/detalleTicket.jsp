<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bean.Ticket"%>
<%@page import="bean.HistorialTicket"%>
<%@page import="bean.SolucionTicket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Ticket ticket = (Ticket) request.getAttribute("ticket");

    List<HistorialTicket> historial =
            (List<HistorialTicket>) request.getAttribute("historial");

    SolucionTicket solucion =
            (SolucionTicket) request.getAttribute("solucion");

    SimpleDateFormat formatoFecha =
            new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Detalle del Ticket</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
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
                    <h1><%= ticket.getCodigoTicket() %></h1>
                    <p><%= ticket.getTitulo() %></p>
                </div>

                <span class="estado-activo">
                    <%= ticket.getEstado() %>
                </span>

            </div>

            <!-- DOS COLUMNAS -->
            <div class="detalle-tecnico-grid">

                <!-- IZQUIERDA -->
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

                            <div>
                                <span>Técnico asignado</span>
                                <strong>
                                    <%= ticket.getTecnicoAsignado() == null
                                            ? "Sin asignar"
                                            : ticket.getTecnicoAsignado() %>
                                </strong>
                            </div>

                            <div>
                                <span>Fecha de creación</span>
                                <strong>
                                    <%= ticket.getFechaCreacion() == null
                                            ? "-"
                                            : formatoFecha.format(ticket.getFechaCreacion()) %>
                                </strong>
                            </div>

                        </div>

                    </div>

                    <div class="detalle-card">

                        <h2>Descripción del problema</h2>

                        <p><%= ticket.getDescripcion() %></p>

                    </div>

                    <div class="detalle-card">

                        <h2>Solución registrada</h2>

                        <% if (solucion != null) { %>

                        <p>
                            <strong>Diagnóstico:</strong>
                            <%= solucion.getDiagnostico() %>
                        </p>

                        <p>
                            <strong>Solución aplicada:</strong>
                            <%= solucion.getSolucionAplicada() %>
                        </p>

                        <p>
                            <strong>Observaciones:</strong>
                            <%= solucion.getObservaciones() == null
                                    || solucion.getObservaciones().trim().isEmpty()
                                    ? "-"
                                    : solucion.getObservaciones() %>
                        </p>

                        <% } else { %>

                        <div class="empty-message">
                            Todavía no se ha registrado una solución.
                        </div>

                        <% } %>

                    </div>

                </div>

                <!-- DERECHA -->
                <div class="detalle-card">

                    <h2>Historial del ticket</h2>

                    <% if (historial != null && !historial.isEmpty()) { %>

                    <div class="timeline">

                        <% for (HistorialTicket h : historial) { %>

                        <div class="timeline-item">

                            <div class="timeline-dot"></div>

                            <div class="timeline-content">

                                <div class="timeline-head">

                                    <strong>
                                        <%= h.getAccion() %>
                                    </strong>

                                    <span>
                                        <%= h.getFechaAccion() == null
                                                ? "-"
                                                : formatoFecha.format(h.getFechaAccion()) %>
                                    </span>

                                </div>

                                <p>
                                    <%= h.getComentario() == null
                                            ? "Sin comentario"
                                            : h.getComentario() %>
                                </p>

                                <div class="timeline-meta">

                                    <span>
                                        Responsable:
                                        <%= h.getNombreUsuario() %>
                                    </span>

                                    <span>
                                        De:
                                        <%= h.getEstadoAnterior() == null
                                                ? "-"
                                                : h.getEstadoAnterior() %>
                                    </span>

                                    <span>
                                        A:
                                        <%= h.getEstadoNuevo() %>
                                    </span>

                                </div>

                            </div>

                        </div>

                        <% } %>

                    </div>

                    <% } else { %>

                    <div class="empty-message">
                        No existen movimientos registrados.
                    </div>

                    <% } %>

                </div>

            </div>

            <!-- BOTONES -->
            <div class="detalle-card">

                <div class="form-actions">

                    <a class="btn-panel secundario"
                       href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados"
                       target="_self">
                        Volver a tickets
                    </a>

                    <% if ("ASIGNADO".equals(ticket.getEstado())
                            || "EN_PROCESO".equals(ticket.getEstado())) { %>

                    <a class="btn-panel"
                       href="${pageContext.request.contextPath}/TicketServlet?accion=atender&id=<%= ticket.getIdTicket() %>"
                       target="_self">
                        Atender ticket
                    </a>

                    <% } %>

                </div>

            </div>

            <% } %>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>