<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bean.HistorialTicket"%>
<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    List<HistorialTicket> historial =
            (List<HistorialTicket>)
                    request.getAttribute("historial");

    SimpleDateFormat formatoFecha =
            new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Historial de Tickets</title>

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

        <!-- FONDO DEL MENÚ MÓVIL -->
        <div class="sidebar-overlay"
             id="sidebarOverlay">
        </div>

        <!-- MENÚ LATERAL -->
        <div class="sidebar">

            <div class="logo-area">

                <h2>STS</h2>

                <span>
                    Soporte TI
                </span>

            </div>

            <div class="menu-title">
                MENÚ PRINCIPAL
            </div>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/admin/dashboardAdmin.jsp">

                <i class="fa-solid fa-chart-line"></i>

                Dashboard

            </a>

            <a class="menu-item"
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

            <a class="menu-item active"
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

                    <h1>
                        Historial de Tickets
                    </h1>

                    <p>
                        Trazabilidad general de las acciones realizadas
                        durante el ciclo de atención de cada incidencia.
                    </p>

                </div>

                <div class="user-badge">
                    ADMINISTRADOR
                </div>

            </div>

            <!-- HISTORIAL -->
            <div class="section-panel">

                <div class="section-header">

                    <div>

                        <h2>

                            <i class="fa-solid fa-clock-rotate-left"></i>

                            Movimientos registrados

                        </h2>

                        <p>
                            Fechas principales y estado actual
                            de cada ticket registrado.
                        </p>

                    </div>

                    <span class="contador-registros">

                        <i class="fa-solid fa-list"></i>

                        <%= historial == null ? 0 : historial.size() %>
                        registros

                    </span>

                </div>

                <div class="table-wrapper">

                    <table class="tabla-historial">

                        <thead>

                            <tr>

                                <th>Ticket</th>

                                <th>Categoría</th>

                                <th>Prioridad</th>

                                <th>Solicitante</th>

                                <th>Técnico</th>

                                <th>Creado</th>

                                <th>Asignado</th>

                                <th>En proceso</th>

                                <th>Resuelto</th>

                                <th>Cerrado</th>

                                <th>Estado actual</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                if (historial != null
                                        && !historial.isEmpty()) {

                                    for (HistorialTicket h : historial) {
                            %>

                            <tr>

                                <td>

                                    <strong>
                                        <%= h.getCodigoTicket() %>
                                    </strong>

                                </td>

                                <td>
                                    <%= h.getCategoria() %>
                                </td>

                                <td>

                                    <span class="badge">
                                        <%= h.getPrioridad() %>
                                    </span>

                                </td>

                                <td>
                                    <%= h.getNombreUsuario() %>
                                </td>

                                <td>

                                    <%
                                        if (h.getTecnicoAsignado() == null
                                                || h.getTecnicoAsignado().trim().isEmpty()) {
                                    %>

                                    <span class="texto-pendiente">

                                        <i class="fa-solid fa-user-clock"></i>

                                        Sin asignar

                                    </span>

                                    <% } else { %>

                                    <span class="tecnico-asignado">

                                        <i class="fa-solid fa-user-gear"></i>

                                        <%= h.getTecnicoAsignado() %>

                                    </span>

                                    <% } %>

                                </td>

                                <td class="fecha-historial">

                                    <%= h.getFechaCreacion() == null
                                            ? "-"
                                            : formatoFecha.format(
                                                    h.getFechaCreacion()
                                            ) %>

                                </td>

                                <td class="fecha-historial">

                                    <%= h.getFechaAsignacion() == null
                                            ? "-"
                                            : formatoFecha.format(
                                                    h.getFechaAsignacion()
                                            ) %>

                                </td>

                                <td class="fecha-historial">

                                    <%= h.getFechaInicio() == null
                                            ? "-"
                                            : formatoFecha.format(
                                                    h.getFechaInicio()
                                            ) %>

                                </td>

                                <td class="fecha-historial">

                                    <%= h.getFechaSolucion() == null
                                            ? "-"
                                            : formatoFecha.format(
                                                    h.getFechaSolucion()
                                            ) %>

                                </td>

                                <td class="fecha-historial">

                                    <%= h.getFechaCierre() == null
                                            ? "-"
                                            : formatoFecha.format(
                                                    h.getFechaCierre()
                                            ) %>

                                </td>

                                <td>

                                    <span class="estado-activo">
                                        <%= h.getEstadoNuevo() %>
                                    </span>

                                </td>

                            </tr>

                            <%
                                    }

                                } else {
                            %>

                            <tr>

                                <td colspan="11"
                                    class="tabla-vacia">

                                    <div class="empty-message">

                                        <i class="fa-solid fa-clock"></i>

                                        <h3>
                                            No hay movimientos registrados
                                        </h3>

                                        <p>
                                            El historial aparecerá cuando
                                            los tickets cambien de estado
                                            o sean atendidos.
                                        </p>

                                    </div>

                                </td>

                            </tr>

                            <%
                                }
                            %>

                        </tbody>

                    </table>

                </div>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>