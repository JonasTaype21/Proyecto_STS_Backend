<%@page import="java.util.List"%>
<%@page import="bean.Ticket"%>
<%@page import="bean.HistorialTicket"%>
<%@page import="bean.SolucionTicket"%>
<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Ticket ticket =
            (Ticket) request.getAttribute("ticket");

    List<HistorialTicket> historial =
            (List<HistorialTicket>) request.getAttribute("historial");

    SolucionTicket solucion =
            (SolucionTicket) request.getAttribute("solucion");

    if (ticket == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/TicketServlet?accion=listar"
        );

        return;
    }
%>

<!DOCTYPE html>
<html>
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

        <!-- BOTÓN MENÚ MÓVIL -->
        <button type="button"
                class="menu-toggle"
                id="menuToggle"
                aria-label="Abrir menú"
                aria-expanded="false">

            <i class="fa-solid fa-bars"></i>

        </button>

        <!-- FONDO OSCURO DEL MENÚ -->
        <div class="sidebar-overlay"
             id="sidebarOverlay">
        </div>

        <!-- MENÚ LATERAL -->
        <div class="sidebar">

            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
            </div>

            <div class="menu-title">
                MENÚ PRINCIPAL
            </div>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/admin/dashboardAdmin.jsp">

                <i class="fa-solid fa-chart-line"></i>
                Dashboard
            </a>

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/TicketServlet?accion=listar">

                <i class="fa-solid fa-ticket"></i>
                Tickets
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/UsuarioServlet?accion=listar">

                <i class="fa-solid fa-users"></i>
                Usuarios
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/ReporteServlet?accion=tiempos">

                <i class="fa-solid fa-chart-column"></i>
                Reportes
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/HistorialServlet?accion=listar">

                <i class="fa-solid fa-clock-rotate-left"></i>
                Historial
            </a>

            <a class="menu-item logout"
               href="${pageContext.request.contextPath}/LogoutServlet">

                <i class="fa-solid fa-right-from-bracket"></i>
                Cerrar sesión
            </a>

        </div>

        <!-- CONTENIDO PRINCIPAL -->
        <div class="main-content">

            <!-- CABECERA -->
            <div class="topbar">

                <div>
                    <h1>Detalle del Ticket</h1>

                    <p>
                        Información completa de la incidencia
                        <strong>
                            <%= ticket.getCodigoTicket() %>
                        </strong>
                    </p>
                </div>

                <div class="user-badge">
                    ADMINISTRADOR
                </div>

            </div>

            <!-- INFORMACIÓN GENERAL -->
            <div class="section-panel">

                <div class="section-header">

                    <h2>
                        <i class="fa-solid fa-circle-info"></i>
                        Información general
                    </h2>

                    <p>
                        Datos registrados por el usuario al crear el ticket.
                    </p>

                </div>

                <div class="ticket-detail-grid">

                    <div class="info-item">
                        <span class="info-label">
                            Código
                        </span>

                        <strong>
                            <%= ticket.getCodigoTicket() %>
                        </strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">
                            Título
                        </span>

                        <strong>
                            <%= ticket.getTitulo() %>
                        </strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">
                            Usuario
                        </span>

                        <strong>
                            <%= ticket.getUsuarioReporta() %>
                        </strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">
                            Técnico asignado
                        </span>

                        <strong>
                            <%= ticket.getTecnicoAsignado() == null
                                    ? "Sin asignar"
                                    : ticket.getTecnicoAsignado() %>
                        </strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">
                            Categoría
                        </span>

                        <strong>
                            <%= ticket.getNombreCategoria() %>
                        </strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">
                            Prioridad
                        </span>

                        <span class="badge">
                            <%= ticket.getPrioridad() %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">
                            Estado actual
                        </span>

                        <span class="estado-activo">
                            <%= ticket.getEstado() %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">
                            Fecha de creación
                        </span>

                        <strong>
                            <%= ticket.getFechaCreacion() %>
                        </strong>
                    </div>

                    <div class="info-item form-full">

                        <span class="info-label">
                            Descripción
                        </span>

                        <p class="texto-detalle">
                            <%= ticket.getDescripcion() %>
                        </p>

                    </div>

                </div>

            </div>

            <!-- SOLUCIÓN -->
            <div class="section-panel">

                <div class="section-header">

                    <h2>
                        <i class="fa-solid fa-screwdriver-wrench"></i>
                        Solución del ticket
                    </h2>

                    <p>
                        Diagnóstico y acciones registradas por el técnico.
                    </p>

                </div>

                <% if (solucion != null) { %>

                <div class="detalle-tecnico-grid">

                    <div class="info-item">

                        <span class="info-label">
                            Diagnóstico
                        </span>

                        <p class="texto-detalle">
                            <%= solucion.getDiagnostico() %>
                        </p>

                    </div>

                    <div class="info-item">

                        <span class="info-label">
                            Solución aplicada
                        </span>

                        <p class="texto-detalle">
                            <%= solucion.getSolucionAplicada() %>
                        </p>

                    </div>

                    <div class="info-item">

                        <span class="info-label">
                            Observaciones
                        </span>

                        <p class="texto-detalle">
                            <%= solucion.getObservaciones() == null
                                    || solucion.getObservaciones().trim().isEmpty()
                                    ? "Sin observaciones"
                                    : solucion.getObservaciones() %>
                        </p>

                    </div>

                    <div class="info-item">

                        <span class="info-label">
                            Fecha de solución
                        </span>

                        <strong>
                            <%= solucion.getFechaSolucion() %>
                        </strong>

                    </div>

                </div>

                <% } else { %>

                <div class="empty-message">

                    <i class="fa-solid fa-hourglass-half"></i>

                    <h3>
                        Aún no se ha registrado una solución
                    </h3>

                    <p>
                        El ticket continúa pendiente de atención
                        o resolución por parte del técnico asignado.
                    </p>

                </div>

                <% } %>

            </div>

            <!-- HISTORIAL -->
            <div class="section-panel">

                <div class="section-header">

                    <h2>
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        Historial relacionado
                    </h2>

                    <p>
                        Cantidad de movimientos registrados para este ticket.
                    </p>

                </div>

                <div class="info-grid">

                    <div class="info-item">

                        <span class="info-label">
                            Movimientos registrados
                        </span>

                        <strong>
                            <%= historial == null
                                    ? 0
                                    : historial.size() %>
                        </strong>

                    </div>

                    <div class="info-item">

                        <span class="info-label">
                            Estado actual
                        </span>

                        <span class="estado-activo">
                            <%= ticket.getEstado() %>
                        </span>

                    </div>

                </div>

                <div class="page-actions">

                    <a class="btn-panel secundario"
                       href="${pageContext.request.contextPath}/HistorialServlet?accion=listar">

                        <i class="fa-solid fa-clock-rotate-left"></i>
                        Ver historial general
                    </a>

                </div>

            </div>

            <!-- ACCIONES -->
            <div class="section-panel">

                <div class="section-header">

                    <h2>
                        <i class="fa-solid fa-gears"></i>
                        Acciones
                    </h2>

                </div>

                <div class="page-actions">

                    <% if ("ABIERTO".equals(ticket.getEstado())
                            || "REABIERTO".equals(ticket.getEstado())) { %>

                    <a class="btn-panel"
                       href="${pageContext.request.contextPath}/TicketServlet?accion=asignar&id=<%= ticket.getIdTicket() %>">

                        <i class="fa-solid fa-user-gear"></i>
                        Asignar técnico
                    </a>

                    <% } %>

                    <% if ("RESUELTO".equals(ticket.getEstado())) { %>

                    <form action="${pageContext.request.contextPath}/TicketServlet"
                          method="post"
                          class="inline-form">

                        <input type="hidden"
                               name="accion"
                               value="cerrar">

                        <input type="hidden"
                               name="idTicket"
                               value="<%= ticket.getIdTicket() %>">

                        <button type="submit"
                                onclick="return confirm('¿Deseas cerrar este ticket?');">

                            <i class="fa-solid fa-circle-check"></i>
                            Cerrar ticket
                        </button>

                    </form>

                    <% } %>

                    <a class="btn-panel secundario"
                       href="${pageContext.request.contextPath}/TicketServlet?accion=listar">

                        <i class="fa-solid fa-arrow-left"></i>
                        Volver a tickets
                    </a>

                </div>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>