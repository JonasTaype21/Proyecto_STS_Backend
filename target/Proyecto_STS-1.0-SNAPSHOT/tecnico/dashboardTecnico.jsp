<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    String vista = request.getParameter("vista");

    if (vista == null || vista.trim().isEmpty()) {
        vista = "dashboard";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Panel Técnico</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">

        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>

    <body class="dashboard-body">

        <!-- =========================
             MENÚ LATERAL
        ========================== -->
        <div class="sidebar">

            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
            </div>

            <div class="menu-title">MENÚ TÉCNICO</div>

            <a class="menu-item <%= "dashboard".equals(vista) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/tecnico/dashboardTecnico.jsp">
                <i class="fa-solid fa-house"></i>
                Dashboard
            </a>

            <a class="menu-item <%= "tickets".equals(vista) ? "active" : "" %>"
               href="${pageContext.request.contextPath}/tecnico/dashboardTecnico.jsp?vista=tickets">
                <i class="fa-solid fa-screwdriver-wrench"></i>
                Tickets asignados
            </a>

            <a class="menu-item logout"
               href="${pageContext.request.contextPath}/LogoutServlet">
                <i class="fa-solid fa-right-from-bracket"></i>
                Cerrar sesión
            </a>

        </div>

        <!-- =========================
             CONTENIDO PRINCIPAL
        ========================== -->
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

                <div class="user-badge">TÉCNICO</div>

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

                    <a href="${pageContext.request.contextPath}/tecnico/dashboardTecnico.jsp?vista=tickets"
                       class="btn-panel">

                        <i class="fa-solid fa-screwdriver-wrench"></i>
                        Ver tickets asignados

                    </a>

                </div>

            </div>

            <!-- CONTENIDO DEL IFRAME -->
            <div class="section-panel panel-frame-container">

                <iframe
                    id="panelTecnicoFrame"
                    name="panelTecnicoFrame"
                    class="panel-frame">
                </iframe>

            </div>

        </div>

        <!-- =========================
                         CARGA SEGÚN LA VISTA
                    ========================== -->
        <script>
            const vistaActual = "<%= vista %>";
const panelTecnico = document.getElementById("panelTecnicoFrame");

if (vistaActual === "tickets") {
    panelTecnico.src =
        "${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados";
}

/* IMPORTANTE */
window.name = "";
        </script>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>