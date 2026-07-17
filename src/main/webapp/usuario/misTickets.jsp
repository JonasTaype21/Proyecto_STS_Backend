<%@page import="java.util.List"%>
<%@page import="bean.Ticket"%>
<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Ticket> lista
            = (List<Ticket>) request.getAttribute("listaTickets");

    String angularBaseUrl = "https://sts-angular.onrender.com";
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mis Tickets</title>

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

        <div class="sidebar-overlay" id="sidebarOverlay"></div>

        <aside class="sidebar">

            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
            </div>

            <div class="menu-title">MENÚ USUARIO</div>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp">
                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo">
                <i class="fa-solid fa-circle-plus"></i>
                <span>Nueva solicitud</span>
            </a>

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/TicketServlet?accion=misTickets">
                <i class="fa-solid fa-ticket"></i>
                <span>Mis tickets</span>
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=seguimientoUsuario">
                <i class="fa-solid fa-clock-rotate-left"></i>
                <span>Seguimiento de tickets</span>
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
                    <h1>Mis Tickets</h1>
                    <p>Consulta todas las solicitudes de soporte que registraste.</p>
                </div>

                <div class="user-badge">USUARIO</div>
            </div>

            <section class="section-panel">

                <div class="section-header section-header-actions">
                    <div>
                        <h2>Solicitudes registradas</h2>
                        <p>Selecciona un ticket para visualizar sus detalles.</p>
                    </div>

                    <a class="btn-panel"
                       href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo">
                        <i class="fa-solid fa-circle-plus"></i>
                        Nueva solicitud
                    </a>
                </div>

                <div class="table-wrapper">

                    <table class="tabla-historial">

                        <thead>
                            <tr>
                                <th>Código</th>
                                <th>Categoría</th>
                                <th>Título</th>
                                <th>Prioridad</th>
                                <th>Estado</th>
                                <th>Técnico</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>

                        <tbody>

                            <% if (lista != null && !lista.isEmpty()) {
                                    for (Ticket t : lista) {
                            %>

                            <tr>
                                <td data-label="Código">
                                    <strong><%= t.getCodigoTicket() %></strong>
                                </td>

                                <td data-label="Categoría">
                                    <%= t.getNombreCategoria() %>
                                </td>

                                <td data-label="Título">
                                    <%= t.getTitulo() %>
                                </td>

                                <td data-label="Prioridad">
                                    <span class="badge prioridad-<%= t.getPrioridad().toLowerCase() %>">
                                        <%= t.getPrioridad() %>
                                    </span>
                                </td>

                                <td data-label="Estado">
                                    <span class="estado-activo">
                                        <%= t.getEstado() %>
                                    </span>
                                </td>

                                <td data-label="Técnico">
                                    <%= t.getTecnicoAsignado() == null
                                            ? "Sin asignar"
                                            : t.getTecnicoAsignado() %>
                                </td>

                                <td data-label="Acciones">
                                    <div class="table-actions">

                                        <a class="btn-table"
                                           href="${pageContext.request.contextPath}/TicketServlet?accion=detalle&id=<%= t.getIdTicket() %>">
                                            <i class="fa-solid fa-eye"></i>
                                            Detalle
                                        </a>

                                        <a class="btn-table secundario"
                                           href="<%= angularBaseUrl %>/tickets/<%= t.getIdTicket() %>?origen=usuario">

                                            <i class="fa-solid fa-clock-rotate-left"></i>
                                            Seguimiento
                                        </a>

                                    </div>
                                </td>
                            </tr>

                            <%      }
                                } else {
                            %>

                            <tr>
                                <td colspan="7" class="tabla-vacia">
                                    <i class="fa-solid fa-inbox"></i>
                                    <p>Todavía no tienes tickets registrados.</p>

                                    <a class="btn-panel"
                                       href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo">
                                        Registrar primera solicitud
                                    </a>
                                </td>
                            </tr>

                            <% } %>

                        </tbody>
                    </table>
                </div>
            </section>
        </main>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>