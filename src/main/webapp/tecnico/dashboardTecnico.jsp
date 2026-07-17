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

        <title>Panel Técnico</title>

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
                MENÚ TÉCNICO
            </div>

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/tecnico/dashboardTecnico.jsp">

                <i class="fa-solid fa-house"></i>
                Dashboard
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                <i class="fa-solid fa-screwdriver-wrench"></i>
                Tickets asignados
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
                    <h1>Panel Técnico</h1>

                    <p>
                        Bienvenido,
                        <strong>
                            <%= usuario.getNombres() %>
                            <%= usuario.getApellidos() %>
                        </strong>
                    </p>
                </div>

                <div class="user-badge">
                    TÉCNICO
                </div>

            </div>

            <!-- TARJETAS -->
            <div class="cards-container">

                <div class="card-dashboard">

                    <div class="card-icon azul">
                        <i class="fa-solid fa-ticket"></i>
                    </div>

                    <div>
                        <h3>Tickets asignados</h3>
                        <p>Consulta las incidencias asignadas para atención.</p>
                    </div>

                </div>

                <div class="card-dashboard">

                    <div class="card-icon verde">
                        <i class="fa-solid fa-screwdriver-wrench"></i>
                    </div>

                    <div>
                        <h3>Atención técnica</h3>
                        <p>Inicia atención, registra diagnóstico y solución.</p>
                    </div>

                </div>

                <div class="card-dashboard">

                    <div class="card-icon naranja">
                        <i class="fa-solid fa-clipboard-check"></i>
                    </div>

                    <div>
                        <h3>Soluciones</h3>
                        <p>Deja constancia del trabajo realizado en cada ticket.</p>
                    </div>

                </div>

            </div>

            <!-- ACCESOS RÁPIDOS -->
            <div class="section-panel">

                <div class="section-header">
                    <h2>Accesos rápidos</h2>
                </div>

                <div class="quick-actions">

                    <a href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados"
                       class="btn-panel">

                        <i class="fa-solid fa-screwdriver-wrench"></i>
                        Ver tickets asignados
                    </a>

                </div>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>