<%@page import="java.util.List"%>
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

    List<Usuario> lista =
            (List<Usuario>) request.getAttribute("listaUsuarios");

    int totalAdministradores = 0;
    int totalUsuarios = 0;
    int totalTecnicos = 0;

    if (lista != null) {

        for (Usuario u : lista) {

            if ("ADMIN".equals(u.getNombreRol())) {
                totalAdministradores++;
            } else if ("USUARIO".equals(u.getNombreRol())) {
                totalUsuarios++;
            } else if ("TECNICO".equals(u.getNombreRol())) {
                totalTecnicos++;
            }
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Usuarios - Administrador</title>

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

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=listar">

                <i class="fa-solid fa-ticket"></i>
                Tickets

            </a>

            <a class="menu-item active"
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
                        Gestión de Usuarios
                    </h1>

                    <p>
                        Administra usuarios, técnicos y administradores
                        registrados en el sistema.
                    </p>

                </div>

                <a class="btn-panel"
                   href="${pageContext.request.contextPath}/UsuarioServlet?accion=nuevo">

                    <i class="fa-solid fa-user-plus"></i>
                    Nuevo registro

                </a>

            </div>

            <!-- RESUMEN -->
            <div class="dashboard-cards">

                <div class="dashboard-card">

                    <div class="card-icon">

                        <i class="fa-solid fa-user-shield"></i>

                    </div>

                    <div>

                        <span>
                            Administradores
                        </span>

                        <strong>
                            <%= totalAdministradores %>
                        </strong>

                    </div>

                </div>

                <div class="dashboard-card">

                    <div class="card-icon">

                        <i class="fa-solid fa-user"></i>

                    </div>

                    <div>

                        <span>
                            Usuarios
                        </span>

                        <strong>
                            <%= totalUsuarios %>
                        </strong>

                    </div>

                </div>

                <div class="dashboard-card">

                    <div class="card-icon">

                        <i class="fa-solid fa-user-gear"></i>

                    </div>

                    <div>

                        <span>
                            Técnicos
                        </span>

                        <strong>
                            <%= totalTecnicos %>
                        </strong>

                    </div>

                </div>

            </div>

            <!-- ADMINISTRADORES -->
            <div class="section-panel">

                <div class="section-header">

                    <div>

                        <h2>

                            <i class="fa-solid fa-user-shield"></i>

                            Administradores

                        </h2>

                        <p>
                            Cuentas con permisos completos
                            sobre la administración del sistema.
                        </p>

                    </div>

                    <span class="contador-registros">

                        <i class="fa-solid fa-list"></i>

                        <%= totalAdministradores %>
                        registros

                    </span>

                </div>

                <div class="table-wrapper">

                    <table class="tabla-usuarios">

                        <thead>

                            <tr>

                                <th>N°</th>

                                <th>Nombres</th>

                                <th>Apellidos</th>

                                <th>Rol</th>

                                <th>Correo</th>

                                <th>Teléfono</th>

                                <th>Estado</th>

                                <th>Acciones</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                int contadorAdmin = 1;

                                if (lista != null
                                        && totalAdministradores > 0) {

                                    for (Usuario u : lista) {

                                        if ("ADMIN".equals(
                                                u.getNombreRol()
                                        )) {
                            %>

                            <tr>

                                <td>
                                    <%= contadorAdmin++ %>
                                </td>

                                <td>
                                    <%= u.getNombres() %>
                                </td>

                                <td>
                                    <%= u.getApellidos() %>
                                </td>

                                <td>

                                    <span class="badge">

                                        <%= u.getNombreRol() %>

                                    </span>

                                </td>

                                <td>
                                    <%= u.getCorreo() %>
                                </td>

                                <td>

                                    <%= u.getTelefono() == null
                                            || u.getTelefono().trim().isEmpty()
                                                    ? "-"
                                                    : u.getTelefono() %>

                                </td>

                                <td>

                                    <span class="<%= u.getEstado() == 1
                                            ? "estado-activo"
                                            : "estado-inactivo" %>">

                                        <%= u.getEstado() == 1
                                                ? "Activo"
                                                : "Inactivo" %>

                                    </span>

                                </td>

                                <td>

                                    <div class="table-actions">

                                        <a class="action-link editar"
                                           href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=<%= u.getIdUsuario() %>">

                                            <i class="fa-solid fa-pen-to-square"></i>
                                            Editar

                                        </a>

                                        <% if (u.getEstado() == 1) { %>

                                        <a class="action-link eliminar"
                                           href="${pageContext.request.contextPath}/UsuarioServlet?accion=eliminar&id=<%= u.getIdUsuario() %>"
                                           onclick="return confirm('¿Seguro que deseas desactivar este administrador?');">

                                            <i class="fa-solid fa-user-slash"></i>
                                            Desactivar

                                        </a>

                                        <% } else { %>

                                        <span class="action-disabled">

                                            <i class="fa-solid fa-ban"></i>
                                            Inactivo

                                        </span>

                                        <% } %>

                                    </div>

                                </td>

                            </tr>

                            <%
                                        }
                                    }

                                } else {
                            %>

                            <tr>

                                <td colspan="8"
                                    class="tabla-vacia">

                                    <div class="empty-message">

                                        <i class="fa-solid fa-user-shield"></i>

                                        <h3>
                                            No hay administradores
                                        </h3>

                                        <p>
                                            No existen cuentas administrativas
                                            registradas en este momento.
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

            <!-- USUARIOS -->
            <div class="section-panel">

                <div class="section-header">

                    <div>

                        <h2>

                            <i class="fa-solid fa-users"></i>

                            Usuarios

                        </h2>

                        <p>
                            Personas que registran solicitudes
                            o incidencias de soporte.
                        </p>

                    </div>

                    <span class="contador-registros">

                        <i class="fa-solid fa-list"></i>

                        <%= totalUsuarios %>
                        registros

                    </span>

                </div>

                <div class="table-wrapper">

                    <table class="tabla-usuarios">

                        <thead>

                            <tr>

                                <th>N°</th>

                                <th>Nombres</th>

                                <th>Apellidos</th>

                                <th>Rol</th>

                                <th>Correo</th>

                                <th>Teléfono</th>

                                <th>Área</th>

                                <th>Estado</th>

                                <th>Acciones</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                int contadorUsuarios = 1;

                                if (lista != null
                                        && totalUsuarios > 0) {

                                    for (Usuario u : lista) {

                                        if ("USUARIO".equals(
                                                u.getNombreRol()
                                        )) {
                            %>

                            <tr>

                                <td>
                                    <%= contadorUsuarios++ %>
                                </td>

                                <td>
                                    <%= u.getNombres() %>
                                </td>

                                <td>
                                    <%= u.getApellidos() %>
                                </td>

                                <td>

                                    <span class="badge">

                                        <%= u.getNombreRol() %>

                                    </span>

                                </td>

                                <td>
                                    <%= u.getCorreo() %>
                                </td>

                                <td>

                                    <%= u.getTelefono() == null
                                            || u.getTelefono().trim().isEmpty()
                                                    ? "-"
                                                    : u.getTelefono() %>

                                </td>

                                <td>

                                    <%= u.getArea() == null
                                            || u.getArea().trim().isEmpty()
                                                    ? "-"
                                                    : u.getArea() %>

                                </td>

                                <td>

                                    <span class="<%= u.getEstado() == 1
                                            ? "estado-activo"
                                            : "estado-inactivo" %>">

                                        <%= u.getEstado() == 1
                                                ? "Activo"
                                                : "Inactivo" %>

                                    </span>

                                </td>

                                <td>

                                    <div class="table-actions">

                                        <a class="action-link editar"
                                           href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=<%= u.getIdUsuario() %>">

                                            <i class="fa-solid fa-pen-to-square"></i>
                                            Editar

                                        </a>

                                        <% if (u.getEstado() == 1) { %>

                                        <a class="action-link eliminar"
                                           href="${pageContext.request.contextPath}/UsuarioServlet?accion=eliminar&id=<%= u.getIdUsuario() %>"
                                           onclick="return confirm('¿Seguro que deseas desactivar este usuario?');">

                                            <i class="fa-solid fa-user-slash"></i>
                                            Desactivar

                                        </a>

                                        <% } else { %>

                                        <span class="action-disabled">

                                            <i class="fa-solid fa-ban"></i>
                                            Inactivo

                                        </span>

                                        <% } %>

                                    </div>

                                </td>

                            </tr>

                            <%
                                        }
                                    }

                                } else {
                            %>

                            <tr>

                                <td colspan="9"
                                    class="tabla-vacia">

                                    <div class="empty-message">

                                        <i class="fa-solid fa-users"></i>

                                        <h3>
                                            No hay usuarios registrados
                                        </h3>

                                        <p>
                                            Los usuarios registrados aparecerán
                                            en esta sección.
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

            <!-- TÉCNICOS -->
            <div class="section-panel">

                <div class="section-header">

                    <div>

                        <h2>

                            <i class="fa-solid fa-user-gear"></i>

                            Técnicos de soporte

                        </h2>

                        <p>
                            Personal encargado de atender,
                            diagnosticar y resolver tickets.
                        </p>

                    </div>

                    <span class="contador-registros">

                        <i class="fa-solid fa-list"></i>

                        <%= totalTecnicos %>
                        registros

                    </span>

                </div>

                <div class="table-wrapper">

                    <table class="tabla-usuarios">

                        <thead>

                            <tr>

                                <th>N°</th>

                                <th>Nombres</th>

                                <th>Apellidos</th>

                                <th>Rol</th>

                                <th>Correo</th>

                                <th>Teléfono</th>

                                <th>Área</th>

                                <th>Especialidad</th>

                                <th>Estado</th>

                                <th>Acciones</th>

                            </tr>

                        </thead>

                        <tbody>

                            <%
                                int contadorTecnicos = 1;

                                if (lista != null
                                        && totalTecnicos > 0) {

                                    for (Usuario u : lista) {

                                        if ("TECNICO".equals(
                                                u.getNombreRol()
                                        )) {
                            %>

                            <tr>

                                <td>
                                    <%= contadorTecnicos++ %>
                                </td>

                                <td>
                                    <%= u.getNombres() %>
                                </td>

                                <td>
                                    <%= u.getApellidos() %>
                                </td>

                                <td>

                                    <span class="badge">

                                        <%= u.getNombreRol() %>

                                    </span>

                                </td>

                                <td>
                                    <%= u.getCorreo() %>
                                </td>

                                <td>

                                    <%= u.getTelefono() == null
                                            || u.getTelefono().trim().isEmpty()
                                                    ? "-"
                                                    : u.getTelefono() %>

                                </td>

                                <td>

                                    <%= u.getArea() == null
                                            || u.getArea().trim().isEmpty()
                                                    ? "-"
                                                    : u.getArea() %>

                                </td>

                                <td>

                                    <%= u.getEspecialidad() == null
                                            || u.getEspecialidad().trim().isEmpty()
                                                    ? "-"
                                                    : u.getEspecialidad() %>

                                </td>

                                <td>

                                    <span class="<%= u.getEstado() == 1
                                            ? "estado-activo"
                                            : "estado-inactivo" %>">

                                        <%= u.getEstado() == 1
                                                ? "Activo"
                                                : "Inactivo" %>

                                    </span>

                                </td>

                                <td>

                                    <div class="table-actions">

                                        <a class="action-link editar"
                                           href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=<%= u.getIdUsuario() %>">

                                            <i class="fa-solid fa-pen-to-square"></i>
                                            Editar

                                        </a>

                                        <% if (u.getEstado() == 1) { %>

                                        <a class="action-link eliminar"
                                           href="${pageContext.request.contextPath}/UsuarioServlet?accion=eliminar&id=<%= u.getIdUsuario() %>"
                                           onclick="return confirm('¿Seguro que deseas desactivar este técnico?');">

                                            <i class="fa-solid fa-user-slash"></i>
                                            Desactivar

                                        </a>

                                        <% } else { %>

                                        <span class="action-disabled">

                                            <i class="fa-solid fa-ban"></i>
                                            Inactivo

                                        </span>

                                        <% } %>

                                    </div>

                                </td>

                            </tr>

                            <%
                                        }
                                    }

                                } else {
                            %>

                            <tr>

                                <td colspan="10"
                                    class="tabla-vacia">

                                    <div class="empty-message">

                                        <i class="fa-solid fa-user-gear"></i>

                                        <h3>
                                            No hay técnicos registrados
                                        </h3>

                                        <p>
                                            Los técnicos de soporte registrados
                                            aparecerán en esta sección.
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