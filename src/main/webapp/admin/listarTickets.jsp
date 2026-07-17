<%@page import="java.util.List"%>
<%@page import="bean.Ticket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Ticket> lista = (List<Ticket>) request.getAttribute("listaTickets");
    String asignado = request.getParameter("asignado");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tickets - Administrador</title>

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

            <a class="menu-item active" href="${pageContext.request.contextPath}/TicketServlet?accion=listar">
                <i class="fa-solid fa-ticket"></i> Tickets
            </a>

            <a class="menu-item" href="${pageContext.request.contextPath}/UsuarioServlet?accion=listar">
                <i class="fa-solid fa-users"></i> Usuarios
            </a>

            <a class="menu-item" href="${pageContext.request.contextPath}/ReporteServlet?accion=tiempos">
                <i class="fa-solid fa-chart-column"></i> Reportes
            </a>

            <a class="menu-item" href="${pageContext.request.contextPath}/HistorialServlet?accion=listar">
                <i class="fa-solid fa-clock-rotate-left"></i> Historial
            </a>

            <a class="menu-item logout" href="${pageContext.request.contextPath}/LogoutServlet">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
            </a>

        </div>

        <div class="main-content">

            <div class="topbar">
                <div>
                    <h1>Gestión de Tickets</h1>
                    <p>Listado general de incidencias registradas en el sistema.</p>
                </div>

                <div class="user-badge">ADMINISTRADOR</div>
            </div>

            <% if ("ok".equals(asignado)) { %>
            <div class="alert-success">
                Técnico asignado correctamente. El ticket fue actualizado a estado ASIGNADO.
            </div>
            <% } %>

            <div class="section-panel">

                <div class="section-header">
                    <h2>Tickets registrados</h2>
                </div>

                <div class="table-wrapper">
                    <table class="tabla-tickets-admin">
                        <tr>
                            <th>Código</th>
                            <th>Solicitante</th>
                            <th>Categoría</th>
                            <th>Título</th>
                            <th>Prioridad</th>
                            <th>Estado actual</th>
                            <th>Técnico asignado</th>
                            <th>Acciones</th>
                        </tr>

                        <% if (lista != null) {
                for (Ticket t : lista) { %>

                        <tr>
                            <td><strong><%= t.getCodigoTicket() %></strong></td>
                            <td><%= t.getUsuarioReporta() %></td>
                            <td><%= t.getNombreCategoria() %></td>
                            <td><%= t.getTitulo() %></td>
                            <td><span class="badge"><%= t.getPrioridad() %></span></td>
                            <td><span class="estado-activo"><%= t.getEstado() %></span></td>
                            <td>
                                <%= t.getTecnicoAsignado() == null ? "Pendiente de asignación" : t.getTecnicoAsignado() %>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/TicketServlet?accion=detalle&id=<%= t.getIdTicket() %>"
                                   target="panelAdminTickets">
                                    Detalle 
                                </a>

                                <br>

                                <a
                                    href="javascript:void(0)"
                                    onclick="window.location.href='http://localhost:4200/tickets/<%= t.getIdTicket() %>?origen=admin'">

                                    Seguimiento STS

                                </a>

                                <% if ("ABIERTO".equals(t.getEstado()) || "REABIERTO".equals(t.getEstado())) { %>
                                <a href="${pageContext.request.contextPath}/TicketServlet?accion=asignar&id=<%= t.getIdTicket() %>"
                                   target="panelAdminTickets">
                                    Asignar técnico
                                </a>
                                <% } %>
                            </td>
                        </tr>

                        <% }} %>
                    </table>
                </div>
            </div>

            <div class="section-panel panel-frame-container">
                <iframe name="panelAdminTickets" class="panel-frame"></iframe>
            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>