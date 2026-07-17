<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
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

    List<Map<String, Object>> reporte =
            (List<Map<String, Object>>)
                    request.getAttribute("reporteTiempos");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Reportes - Administrador</title>

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

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/ReporteServlet?accion=tiempos">

                <i class="fa-solid fa-chart-column"></i>

                Reportes

            </a>

            <a class="menu-item"
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
                        Reportes de Atención
                    </h1>

                    <p>
                        Indicadores de tiempos de respuesta,
                        resolución y cierre de tickets.
                    </p>

                </div>

                <div class="user-badge">
                    ADMINISTRADOR
                </div>

            </div>

            <!-- REPORTE -->
            <div class="section-panel">

                <div class="section-header">

                    <div>

                        <h2>
                            <i class="fa-solid fa-chart-column"></i>
                            Reporte de tiempos
                        </h2>

                        <p>
                            Resumen de los tiempos empleados durante
                            la atención de cada incidencia.
                        </p>

                    </div>

                </div>

                <!-- TABLA RESPONSIVE -->
                <div class="table-wrapper">

                    <table class="tabla-reportes">

                        <thead>

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

                        </thead>

                        <tbody>

                            <%
                                if (reporte != null
                                        && !reporte.isEmpty()) {

                                    for (Map<String, Object> r : reporte) {
                            %>

                            <tr>

                                <td>

                                    <strong>
                                        <%= r.get("codigo_ticket") %>
                                    </strong>

                                </td>

                                <td>

                                    <%= r.get("titulo") %>

                                </td>

                                <td>

                                    <span class="estado-activo">

                                        <%= r.get("estado") %>

                                    </span>

                                </td>

                                <td>

                                    <span class="badge">

                                        <%= r.get("prioridad") %>

                                    </span>

                                </td>

                                <td>

                                    <%= r.get("nombre_categoria") %>

                                </td>

                                <td>

                                    <%= r.get("usuario_reporta") %>

                                </td>

                                <td>

                                    <%= r.get("tecnico_asignado") == null
                                            ? "Sin asignar"
                                            : r.get("tecnico_asignado") %>

                                </td>

                                <td class="dato-tiempo">

                                    <%= r.get("minutos_respuesta") == null
                                            ? "-"
                                            : r.get("minutos_respuesta") %>

                                </td>

                                <td class="dato-tiempo">

                                    <%= r.get("minutos_resolucion") == null
                                            ? "-"
                                            : r.get("minutos_resolucion") %>

                                </td>

                                <td class="dato-tiempo">

                                    <%= r.get("minutos_total") == null
                                            ? "-"
                                            : r.get("minutos_total") %>

                                </td>

                            </tr>

                            <%
                                    }
                                } else {
                            %>

                            <tr>

                                <td colspan="10"
                                    class="tabla-vacia">

                                    <div class="empty-message">

                                        <i class="fa-solid fa-chart-simple"></i>

                                        <h3>
                                            No hay información disponible
                                        </h3>

                                        <p>
                                            Todavía no existen tickets con
                                            tiempos suficientes para generar
                                            este reporte.
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