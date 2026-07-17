<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bean.Ticket"%>
<%@page import="bean.HistorialTicket"%>
<%@page import="bean.SolucionTicket"%>
<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Ticket ticket
            = (Ticket) request.getAttribute("ticket");

    List<HistorialTicket> historial
            = (List<HistorialTicket>) request.getAttribute("historial");

    SolucionTicket solucion
            = (SolucionTicket) request.getAttribute("solucion");

    SimpleDateFormat formatoFecha
            = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Detalle del Ticket</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>

    <body class="dashboard-body">

        <button type="button"
                class="menu-toggle"
                id="menuToggle"
                aria-label="Abrir menú"
                aria-expanded="false">

            <i class="fa-solid fa-bars"></i>
        </button>

        <div class="sidebar-overlay"
             id="sidebarOverlay">
        </div>

        <aside class="sidebar">

            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
            </div>

            <div class="menu-title">
                MENÚ TÉCNICO
            </div>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/tecnico/dashboardTecnico.jsp">

                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                <i class="fa-solid fa-screwdriver-wrench"></i>
                <span>Tickets asignados</span>
            </a>

            <a class="menu-item logout"
               href="${pageContext.request.contextPath}/LogoutServlet">

                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Cerrar sesión</span>
            </a>

        </aside>

        <main class="main-content">

            <div class="topbar">

                <div>
                    <h1>Detalle del Ticket</h1>

                    <p>
                        Consulta la información, solución e historial del ticket.
                    </p>
                </div>

                <div class="user-badge">
                    TÉCNICO
                </div>

            </div>

            <% if (ticket == null) { %>

            <section class="detalle-card">

                <div class="estado-vacio">

                    <i class="fa-solid fa-circle-exclamation"></i>

                    <h2>Ticket no encontrado</h2>

                    <p>
                        No fue posible cargar la información solicitada.
                    </p>

                    <a class="btn-panel"
                       href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                        <i class="fa-solid fa-arrow-left"></i>
                        Volver a tickets
                    </a>

                </div>

            </section>

            <% } else { %>

            <div class="page-actions">

                <a class="btn-panel secundario"
                   href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                    <i class="fa-solid fa-arrow-left"></i>
                    Volver a tickets
                </a>

                <% if ("ASIGNADO".equals(ticket.getEstado())
                            || "EN_PROCESO".equals(ticket.getEstado())) { %>

                <a class="btn-panel"
                   href="${pageContext.request.contextPath}/TicketServlet?accion=atender&id=<%= ticket.getIdTicket() %>">

                    <i class="fa-solid fa-screwdriver-wrench"></i>
                    Atender ticket
                </a>

                <% } %>

            </div>

            <div class="ticket-detail-header detalle-card-header">

                <div>
                    <span class="ticket-codigo">
                        <%= ticket.getCodigoTicket() %>
                    </span>

                    <h1>
                        <%= ticket.getTitulo() %>
                    </h1>
                </div>

                <span class="estado-activo">
                    <%= ticket.getEstado() %>
                </span>

            </div>

            <div class="detalle-tecnico-grid">

                <div>

                    <section class="detalle-card">

                        <h2>
                            <i class="fa-solid fa-circle-info"></i>
                            Información del ticket
                        </h2>

                        <div class="info-grid">

                            <div>
                                <span>Usuario</span>

                                <strong>
                                    <%= ticket.getUsuarioReporta() %>
                                </strong>
                            </div>

                            <div>
                                <span>Categoría</span>

                                <strong>
                                    <%= ticket.getNombreCategoria() %>
                                </strong>
                            </div>

                            <div>
                                <span>Prioridad</span>

                                <strong>
                                    <span class="badge prioridad-<%= ticket.getPrioridad().toLowerCase() %>">
                                        <%= ticket.getPrioridad() %>
                                    </span>
                                </strong>
                            </div>

                            <div>
                                <span>Estado</span>

                                <strong>
                                    <%= ticket.getEstado() %>
                                </strong>
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

                    </section>

                    <section class="detalle-card">

                        <h2>
                            <i class="fa-solid fa-file-lines"></i>
                            Descripción del problema
                        </h2>

                        <p class="texto-detalle">
                            <%= ticket.getDescripcion() %>
                        </p>

                    </section>

                    <section class="detalle-card">

                        <h2>
                            <i class="fa-solid fa-circle-check"></i>
                            Solución registrada
                        </h2>

                        <% if (solucion != null) { %>

                        <div class="solucion-tecnica">

                            <div>
                                <span class="detalle-label">
                                    Diagnóstico
                                </span>

                                <p>
                                    <%= solucion.getDiagnostico() %>
                                </p>
                            </div>

                            <div>
                                <span class="detalle-label">
                                    Solución aplicada
                                </span>

                                <p>
                                    <%= solucion.getSolucionAplicada() %>
                                </p>
                            </div>

                            <div>
                                <span class="detalle-label">
                                    Observaciones
                                </span>

                                <p>
                                    <%= solucion.getObservaciones() == null
                                            || solucion.getObservaciones().trim().isEmpty()
                                                    ? "Sin observaciones"
                                                    : solucion.getObservaciones() %>
                                </p>
                            </div>

                        </div>

                        <% } else { %>

                        <div class="empty-message">
                            Todavía no se ha registrado una solución.
                        </div>

                        <% } %>

                    </section>

                </div>

                <section class="detalle-card">

                    <h2>
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        Historial del ticket
                    </h2>

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
                                            || h.getComentario().trim().isEmpty()
                                                    ? "Sin comentario"
                                                    : h.getComentario() %>
                                </p>

                                <div class="timeline-meta">

                                    <span>
                                        <strong>Responsable:</strong>
                                        <%= h.getNombreUsuario() %>
                                    </span>

                                    <span>
                                        <strong>Estado anterior:</strong>
                                        <%= h.getEstadoAnterior() == null
                                                ? "-"
                                                : h.getEstadoAnterior() %>
                                    </span>

                                    <span>
                                        <strong>Estado nuevo:</strong>
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

                </section>

            </div>

            <% } %>

        </main>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>