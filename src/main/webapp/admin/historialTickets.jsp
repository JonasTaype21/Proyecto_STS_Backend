<%@page import="java.util.List"%>
<%@page import="bean.HistorialTicket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    List<HistorialTicket> historial =
            (List<HistorialTicket>) request.getAttribute("historial");
%>
<%
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Historial de Tickets</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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

        <div class="sidebar">
            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
            </div>

            <div class="menu-title">MENÚ PRINCIPAL</div>

            <a class="menu-item" href="${pageContext.request.contextPath}/admin/dashboardAdmin.jsp">
                <i class="fa-solid fa-chart-line"></i> Dashboard
            </a>

            <a class="menu-item" href="${pageContext.request.contextPath}/TicketServlet?accion=listar">
                <i class="fa-solid fa-ticket"></i> Tickets
            </a>

            <a class="menu-item" href="${pageContext.request.contextPath}/UsuarioServlet?accion=listar">
                <i class="fa-solid fa-users"></i> Usuarios
            </a>

            <a class="menu-item" href="${pageContext.request.contextPath}/ReporteServlet?accion=tiempos">
                <i class="fa-solid fa-chart-column"></i> Reportes
            </a>

            <a class="menu-item active" href="${pageContext.request.contextPath}/HistorialServlet?accion=listar">
                <i class="fa-solid fa-clock-rotate-left"></i> Historial
            </a>

            <a class="menu-item logout" href="${pageContext.request.contextPath}/LogoutServlet">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
            </a>
        </div>

        <div class="main-content">

            <div class="topbar">
                <div>
                    <h1>Historial de Tickets</h1>
                    <p>Trazabilidad general de acciones realizadas en el sistema.</p>
                </div>

                <div class="user-badge">ADMINISTRADOR</div>
            </div>

            <div class="section-panel">
                <div class="section-header">
                    <h2>Movimientos registrados</h2>
                </div>
                <div class="table-wrapper">
                    <table class="tabla-historial">
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

                        <% if (historial != null) {
        for (HistorialTicket h : historial) { %>

                        <tr>
                            <td><strong><%= h.getCodigoTicket() %></strong></td>
                            <td><%= h.getCategoria() %></td>
                            <td><span class="badge"><%= h.getPrioridad() %></span></td>
                            <td><%= h.getNombreUsuario() %></td>
                            <td><%= h.getTecnicoAsignado() == null ? "Sin asignar" : h.getTecnicoAsignado() %></td>
                            <td><%= h.getFechaCreacion() == null ? "-" : formatoFecha.format(h.getFechaCreacion()) %></td>
                            <td><%= h.getFechaAsignacion() == null ? "-" : formatoFecha.format(h.getFechaAsignacion()) %></td>
                            <td><%= h.getFechaInicio() == null ? "-" : formatoFecha.format(h.getFechaInicio()) %></td>
                            <td><%= h.getFechaSolucion() == null ? "-" : formatoFecha.format(h.getFechaSolucion()) %></td>
                            <td><%= h.getFechaCierre() == null ? "-" : formatoFecha.format(h.getFechaCierre()) %></td>

                            <td><span class="estado-activo"><%= h.getEstadoNuevo() %></span></td>
                        </tr>

                        <% }} %>
                    </table>
                </div>
            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>