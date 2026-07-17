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
<html lang="es">
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

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/tecnico/dashboardTecnico.jsp">

                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>

            <a class="menu-item"
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

            <div class="cards-container">

                <a class="card-dashboard card-dashboard-link"
                   href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                    <div class="card-icon azul">
                        <i class="fa-solid fa-ticket"></i>
                    </div>

                    <div>
                        <h3>Tickets asignados</h3>

                        <p>
                            Consulta las incidencias que requieren atención.
                        </p>
                    </div>

                    <i class="fa-solid fa-chevron-right card-arrow"></i>
                </a>

                <a class="card-dashboard card-dashboard-link"
                   href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                    <div class="card-icon verde">
                        <i class="fa-solid fa-screwdriver-wrench"></i>
                    </div>

                    <div>
                        <h3>Atención técnica</h3>

                        <p>
                            Inicia la atención y registra el diagnóstico.
                        </p>
                    </div>

                    <i class="fa-solid fa-chevron-right card-arrow"></i>
                </a>

                <a class="card-dashboard card-dashboard-link"
                   href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                    <div class="card-icon naranja">
                        <i class="fa-solid fa-clipboard-check"></i>
                    </div>

                    <div>
                        <h3>Soluciones</h3>

                        <p>
                            Registra la solución aplicada en cada ticket.
                        </p>
                    </div>

                    <i class="fa-solid fa-chevron-right card-arrow"></i>
                </a>

            </div>

            <section class="section-panel quick-access-panel">

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

            </section>

        </main>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>