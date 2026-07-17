<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel Administrador</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">

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

        <div class="sidebar">

            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
            </div>

            <div class="menu-title">
                MENÚ PRINCIPAL
            </div>

            <a class="menu-item active"
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
            <a class="menu-item" href="${pageContext.request.contextPath}/HistorialServlet?accion=listar">
                <i class="fa-solid fa-clock-rotate-left"></i> Historial
            </a>
            <a class="menu-item logout"
               href="${pageContext.request.contextPath}/LogoutServlet">

                <i class="fa-solid fa-right-from-bracket"></i>
                Cerrar sesión
            </a>

        </div>

        <div class="main-content">

            <div class="topbar">

                <div>
                    <h1>Panel Administrador</h1>
                    <p>
                        Bienvenido al panel de Administrador,
                        <strong>
                            <%= usuario.getNombres() %>
                            <%= usuario.getApellidos() %>
                        </strong>
                    </p>
                </div>

                <div class="user-badge">
                    ADMINISTRADOR
                </div>

            </div>

            <div class="cards-container">

                <div class="card-dashboard">
                    <div class="card-icon azul">
                        <i class="fa-solid fa-ticket"></i>
                    </div>

                    <div>
                        <h3>Tickets</h3>
                        <p>Gestión general de incidencias</p>
                    </div>
                </div>

                <div class="card-dashboard">
                    <div class="card-icon verde">
                        <i class="fa-solid fa-users"></i>
                    </div>

                    <div>
                        <h3>Usuarios</h3>
                        <p>Administrar usuarios y técnicos</p>
                    </div>
                </div>

                <div class="card-dashboard">
                    <div class="card-icon naranja">
                        <i class="fa-solid fa-chart-column"></i>
                    </div>

                    <div>
                        <h3>Reportes</h3>
                        <p>Indicadores y tiempos de atención</p>
                    </div>
                </div>

            </div>

            <div class="section-panel">

                <div class="section-header">

                    <h2>Accesos rápidos</h2>

                </div>

                <div class="quick-actions">

                    <a href="${pageContext.request.contextPath}/TicketServlet?accion=listar"
                       class="btn-panel">

                        <i class="fa-solid fa-ticket"></i>
                        Ver Tickets
                    </a>

                    <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=listar"
                       class="btn-panel">

                        <i class="fa-solid fa-user-plus"></i>
                        Gestionar Usuarios
                    </a>

                    <a href="${pageContext.request.contextPath}/ReporteServlet?accion=tiempos"
                       class="btn-panel">

                        <i class="fa-solid fa-chart-line"></i>
                        Ver Reportes
                    </a>

                </div>

            </div>

        </div>
        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>