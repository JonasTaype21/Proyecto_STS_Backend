<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String vista = request.getParameter("vista");

    if (vista == null) {
        vista = "dashboard";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Panel Usuario</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>

    <body class="dashboard-body">

        <div class="sidebar">

            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
            </div>

            <div class="menu-title">MENÚ USUARIO</div>

            <a class="menu-item <%= "dashboard".equals(vista) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp">
                <i class="fa-solid fa-house"></i> Dashboard
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo">
                <i class="fa-solid fa-circle-plus"></i> Nueva solicitud
            </a>

            <a class="menu-item <%= "misTickets".equals(vista) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp?vista=misTickets">
                <i class="fa-solid fa-ticket"></i> Mis tickets
            </a>

            <a class="menu-item <%= "seguimiento".equals(vista) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp?vista=seguimiento">
                <i class="fa-solid fa-clock-rotate-left"></i> Seguimiento de Tickets
            </a>

            <a class="menu-item logout" href="${pageContext.request.contextPath}/LogoutServlet">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
            </a>

        </div>

        <div class="main-content">

            <div class="topbar">
                <div>
                    <h1>Panel Usuario</h1>
                    <p>
                        Bienvenido al panel de usuario,
                        <strong><%= usuario.getNombres() %> <%= usuario.getApellidos() %></strong>
                    </p>
                </div>

                <div class="user-badge">USUARIO</div>
            </div>

            <div class="cards-container">

                <div class="card-dashboard">
                    <div class="card-icon azul">
                        <i class="fa-solid fa-circle-plus"></i>
                    </div>

                    <div>
                        <h3>Nueva solicitud</h3>
                        <p>Registra una incidencia o requerimiento de soporte.</p>
                    </div>
                </div>

                <div class="card-dashboard">
                    <div class="card-icon verde">
                        <i class="fa-solid fa-ticket"></i>
                    </div>

                    <div>
                        <h3>Mis tickets</h3>
                        <p>Consulta el estado de tus solicitudes registradas.</p>
                    </div>
                </div>

                <div class="card-dashboard">
                    <div class="card-icon naranja">
                        <i class="fa-solid fa-clock"></i>
                    </div>

                    <div>
                        <h3>Seguimiento</h3>
                        <p>Revisa el avance, solución y cierre del ticket.</p>
                    </div>
                </div>

            </div>

            <div class="section-panel">

                <div class="section-header">
                    <h2>Accesos rápidos</h2>
                </div>

                <div class="quick-actions">

                    <a href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo"
                       class="btn-panel">
                        <i class="fa-solid fa-circle-plus"></i>
                        Registrar solicitud
                    </a>

                    <a href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp?vista=misTickets"
                       class="btn-panel">
                        <i class="fa-solid fa-ticket"></i>
                        Ver mis tickets
                    </a>

                    <a href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp?vista=seguimiento"
                       class="btn-panel">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        Seguimiento
                    </a>

                </div>

            </div>

            <% if ("misTickets".equals(vista) || "seguimiento".equals(vista)) { %>
            <div class="section-panel panel-frame-container">
                <iframe
                    id="panelUsuarioFrame"
                    name="panelUsuarioFrame"
                    class="panel-frame">
                </iframe>
            </div>
            <% } %>

        </div>

        <script>
    const vista = "<%= vista %>";
const frame = document.getElementById("panelUsuarioFrame");

if (frame && vista === "misTickets") {
    frame.src =
        "${pageContext.request.contextPath}/TicketServlet?accion=misTickets&modo=detalle";
}

if (frame && vista === "seguimiento") {
    frame.src =
        "${pageContext.request.contextPath}/TicketServlet?accion=seguimientoUsuario";
}

/* ESTA ES LA LÍNEA IMPORTANTE */
window.name = "";
        </script>

    </body>
</html>