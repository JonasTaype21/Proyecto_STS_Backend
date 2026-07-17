<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Map<String, Object>> reporte = (List<Map<String, Object>>) request.getAttribute("reporteTiempos");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reportes - Administrador</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>

    <body class="dashboard-body">

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

            <a class="menu-item active" href="${pageContext.request.contextPath}/ReporteServlet?accion=tiempos">
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
                    <h1>Reportes de Atención</h1>
                    <p>Indicadores de tiempos de respuesta, resolución y cierre de tickets.</p>
                </div>

                <div class="user-badge">ADMINISTRADOR</div>
            </div>

            <div class="section-panel">

                <div class="section-header">
                    <h2>Reporte de tiempos</h2>
                </div>

                <table>
                    <tr>
                        <th>Código</th>
                        <th>Título</th>
                        <th>Estado</th>
                        <th>Prioridad</th>
                        <th>Categoría</th>
                        <th>Usuario</th>
                        <th>Técnico</th>
                        <th>Min. respuesta</th>
                        <th>Min. resolución</th>
                        <th>Min. total</th>
                    </tr>

                    <% if (reporte != null) {
                for (Map<String, Object> r : reporte) { %>

                    <tr>
                        <td><%= r.get("codigo_ticket") %></td>
                        <td><%= r.get("titulo") %></td>
                        <td><span class="estado-activo"><%= r.get("estado") %></span></td>
                        <td><span class="badge"><%= r.get("prioridad") %></span></td>
                        <td><%= r.get("nombre_categoria") %></td>
                        <td><%= r.get("usuario_reporta") %></td>
                        <td><%= r.get("tecnico_asignado") == null ? "Sin asignar" : r.get("tecnico_asignado") %></td>
                        <td><%= r.get("minutos_respuesta") == null ? "-" : r.get("minutos_respuesta") %></td>
                        <td><%= r.get("minutos_resolucion") == null ? "-" : r.get("minutos_resolucion") %></td>
                        <td><%= r.get("minutos_total") == null ? "-" : r.get("minutos_total") %></td>
                    </tr>

                    <% }} %>
                </table>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>