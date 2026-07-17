<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Panel Usuario</title>

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
                MENÚ USUARIO
            </div>

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp">

                <i class="fa-solid fa-house"></i>
                Dashboard
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo">

                <i class="fa-solid fa-circle-plus"></i>
                Nueva solicitud
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=misTickets">

                <i class="fa-solid fa-ticket"></i>
                Mis tickets
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=seguimientoUsuario">

                <i class="fa-solid fa-clock-rotate-left"></i>
                Seguimiento de tickets
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
                    <h1>Panel Usuario</h1>

                    <p>
                        Bienvenido al panel de usuario,
                        <strong>
                            <%= usuario.getNombres() %>
                            <%= usuario.getApellidos() %>
                        </strong>
                    </p>
                </div>

                <div class="user-badge">
                    USUARIO
                </div>

            </div>

            <!-- TARJETAS -->
            <div class="cards-container">

                <div class="card-dashboard">

                    <div class="card-icon azul">
                        <i class="fa-solid fa-circle-plus"></i>
                    </div>

                    <div>
                        <h3>Nueva solicitud</h3>

                        <p>
                            Registra una incidencia o requerimiento de soporte.
                        </p>
                    </div>

                </div>

                <div class="card-dashboard">

                    <div class="card-icon verde">
                        <i class="fa-solid fa-ticket"></i>
                    </div>

                    <div>
                        <h3>Mis tickets</h3>

                        <p>
                            Consulta el estado de tus solicitudes registradas.
                        </p>
                    </div>

                </div>

                <div class="card-dashboard">

                    <div class="card-icon naranja">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                    </div>

                    <div>
                        <h3>Seguimiento</h3>

                        <p>
                            Revisa el avance, solución y cierre de tus tickets.
                        </p>
                    </div>

                </div>

            </div>

            <!-- ACCESOS RÁPIDOS -->
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

                    <a href="${pageContext.request.contextPath}/TicketServlet?accion=misTickets"
                       class="btn-panel">

                        <i class="fa-solid fa-ticket"></i>
                        Ver mis tickets
                    </a>

                    <a href="${pageContext.request.contextPath}/TicketServlet?accion=seguimientoUsuario"
                       class="btn-panel">

                        <i class="fa-solid fa-clock-rotate-left"></i>
                        Seguimiento
                    </a>

                </div>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>