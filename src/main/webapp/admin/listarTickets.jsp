<%@page import="java.util.List"%>
<%@page import="bean.Ticket"%>
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

    List<Ticket> lista =
            (List<Ticket>) request.getAttribute("listaTickets");

    String asignado =
            request.getParameter("asignado");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Tickets - Administrador</title>

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

        <!-- FONDO DEL MENÚ MÓVIL -->
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

            <a class="menu-item active"
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
                        Gestión de Tickets
                    </h1>

                    <p>
                        Listado general de incidencias registradas
                        en el sistema.
                    </p>

                </div>

                <div class="user-badge">
                    ADMINISTRADOR
                </div>

            </div>

            <!-- MENSAJE DE ASIGNACIÓN -->
            <% if ("ok".equals(asignado)) { %>

            <div class="alert-success">

                <i class="fa-solid fa-circle-check"></i>

                <div>

                    <strong>
                        Técnico asignado correctamente.
                    </strong>

                    <p>
                        El ticket fue actualizado al estado ASIGNADO.
                    </p>

                </div>

            </div>

            <% } %>

            <!-- LISTADO DE TICKETS -->
            <div class="section-panel">

                <div class="section-header">

                    <div>

                        <h2>

                            <i class="fa-solid fa-ticket"></i>

                            Tickets registrados

                        </h2>

                        <p>
                            Consulta el detalle de cada ticket y asigna
                            técnicos cuando la incidencia lo requiera.
                        </p>

                    </div>

                    <span class="contador-registros">

                        <i class="fa-solid fa-list"></i>

                        <%= lista == null ? 0 : lista.size() %>
                        registros

                    </span>

                </div>

                <div class="table-wrapper">

                    <table class="tabla-tickets-admin">

                        <thead>

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

                        </thead>

                        <tbody>

                            <%
                                if (lista != null
                                        && !lista.isEmpty()) {

                                    for (Ticket t : lista) {
                            %>

                            <tr>

                                <td>

                                    <strong>
                                        <%= t.getCodigoTicket() %>
                                    </strong>

                                </td>

                                <td>
                                    <%= t.getUsuarioReporta() %>
                                </td>

                                <td>
                                    <%= t.getNombreCategoria() %>
                                </td>

                                <td class="ticket-titulo">

                                    <%= t.getTitulo() %>

                                </td>

                                <td>

                                    <span class="badge">

                                        <%= t.getPrioridad() %>

                                    </span>

                                </td>

                                <td>

                                    <span class="estado-activo">

                                        <%= t.getEstado() %>

                                    </span>

                                </td>

                                <td>

                                    <%
                                        if (t.getTecnicoAsignado() == null
                                                || t.getTecnicoAsignado().trim().isEmpty()) {
                                    %>

                                    <span class="texto-pendiente">

                                        <i class="fa-solid fa-user-clock"></i>

                                        Pendiente de asignación

                                    </span>

                                    <% } else { %>

                                    <span class="tecnico-asignado">

                                        <i class="fa-solid fa-user-gear"></i>

                                        <%= t.getTecnicoAsignado() %>

                                    </span>

                                    <% } %>

                                </td>

                                <td>

                                    <div class="table-actions">

                                        <!-- VER DETALLE -->
                                        <a class="action-link detalle"
                                           href="${pageContext.request.contextPath}/TicketServlet?accion=detalle&id=<%= t.getIdTicket() %>"
                                           title="Ver detalle del ticket">

                                            <i class="fa-solid fa-eye"></i>

                                            Detalle

                                        </a>

                                        <!-- ASIGNAR TÉCNICO -->
                                        <% if ("ABIERTO".equals(t.getEstado())
                                                || "REABIERTO".equals(t.getEstado())) { %>

                                        <a class="action-link asignar"
                                           href="${pageContext.request.contextPath}/TicketServlet?accion=asignar&id=<%= t.getIdTicket() %>"
                                           title="Asignar técnico">

                                            <i class="fa-solid fa-user-plus"></i>

                                            Asignar

                                        </a>

                                        <% } %>

                                    </div>

                                </td>

                            </tr>

                            <%
                                    }

                                } else {
                            %>

                            <tr>

                                <td colspan="8"
                                    class="tabla-vacia">

                                    <div class="empty-message">

                                        <i class="fa-solid fa-ticket-simple"></i>

                                        <h3>
                                            No hay tickets registrados
                                        </h3>

                                        <p>
                                            Cuando los usuarios registren
                                            nuevas incidencias aparecerán
                                            en este listado.
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