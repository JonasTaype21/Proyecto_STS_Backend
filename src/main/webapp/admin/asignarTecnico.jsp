<%@page import="java.util.List"%>
<%@page import="bean.Usuario"%>
<%@page import="bean.Ticket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");

    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Ticket ticket = (Ticket) request.getAttribute("ticket");
    List<Usuario> tecnicos
            = (List<Usuario>) request.getAttribute("listaTecnicos");

    if (ticket == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/TicketServlet?accion=listar"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Asignar Técnico</title>

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

        <!-- SIDEBAR -->
        <div class="sidebar">

            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
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
                    <h1>Asignar Técnico</h1>

                    <p>
                        Selecciona al técnico responsable de atender
                        la incidencia.
                    </p>
                </div>

                <div class="user-badge">
                    ADMINISTRADOR
                </div>

            </div>

            <!-- INFORMACIÓN DEL TICKET -->
            <div class="section-panel">

                <div class="section-header">
                    <h2>
                        <i class="fa-solid fa-circle-info"></i>
                        Información del ticket
                    </h2>

                    <p>
                        Revisa los datos antes de realizar la asignación.
                    </p>
                </div>

                <div class="info-grid">

                    <div class="info-item">
                        <span class="info-label">Código</span>

                        <strong>
                            <%= ticket.getCodigoTicket() %>
                        </strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Título</span>

                        <strong>
                            <%= ticket.getTitulo() %>
                        </strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Categoría</span>

                        <strong>
                            <%= ticket.getNombreCategoria() %>
                        </strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Prioridad</span>

                        <span class="badge">
                            <%= ticket.getPrioridad() %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Estado actual</span>

                        <span class="estado-activo">
                            <%= ticket.getEstado() %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Solicitante</span>

                        <strong>
                            <%= ticket.getUsuarioReporta() %>
                        </strong>
                    </div>

                </div>

            </div>

            <!-- FORMULARIO DE ASIGNACIÓN -->
            <div class="section-panel">

                <div class="section-header">

                    <h2>
                        <i class="fa-solid fa-user-gear"></i>
                        Técnico responsable
                    </h2>

                    <p>
                        Solo se muestran los técnicos disponibles
                        registrados en el sistema.
                    </p>

                </div>

                <% if (tecnicos != null && !tecnicos.isEmpty()) { %>

                <form action="${pageContext.request.contextPath}/TicketServlet"
                      method="post"
                      class="form-grid">

                    <input type="hidden"
                           name="accion"
                           value="asignar">

                    <input type="hidden"
                           name="idTicket"
                           value="<%= ticket.getIdTicket() %>">

                    <div class="form-full">
                        <label for="idTecnico">
                            Técnico:
                        </label>

                        <select name="idTecnico"
                                id="idTecnico"
                                required>

                            <option value="">
                                Seleccione un técnico
                            </option>

                            <%
                                for (Usuario tecnico : tecnicos) {
                            %>

                            <option value="<%= tecnico.getIdUsuario() %>">

                                <%= tecnico.getNombres() %>
                                <%= tecnico.getApellidos() %>

                                <% if (tecnico.getEspecialidad() != null
                                            && !tecnico.getEspecialidad().trim().isEmpty()) { %>

                                - <%= tecnico.getEspecialidad() %>

                                <% } %>

                            </option>

                            <%
                                }
                            %>

                        </select>
                    </div>

                    <div class="form-actions">

                        <button type="submit"
                                onclick="return confirm('¿Deseas asignar este técnico al ticket?');">

                            <i class="fa-solid fa-user-check"></i>
                            Asignar técnico
                        </button>

                        <a class="btn-panel secundario"
                           href="${pageContext.request.contextPath}/TicketServlet?accion=listar">

                            <i class="fa-solid fa-arrow-left"></i>
                            Cancelar
                        </a>

                    </div>

                </form>

                <% } else { %>

                <div class="empty-message">

                    <i class="fa-solid fa-user-slash"></i>

                    <h3>No hay técnicos disponibles</h3>

                    <p>
                        Debes registrar o activar un técnico antes de
                        asignar este ticket.
                    </p>

                    <div class="page-actions">

                        <a class="btn-panel"
                           href="${pageContext.request.contextPath}/UsuarioServlet?accion=nuevo">

                            <i class="fa-solid fa-user-plus"></i>
                            Registrar técnico
                        </a>

                        <a class="btn-panel secundario"
                           href="${pageContext.request.contextPath}/TicketServlet?accion=listar">

                            <i class="fa-solid fa-arrow-left"></i>
                            Volver a tickets
                        </a>

                    </div>

                </div>

                <% } %>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>