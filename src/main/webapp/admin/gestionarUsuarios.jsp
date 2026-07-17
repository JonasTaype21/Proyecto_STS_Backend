<%@page import="java.util.List"%>
<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Usuario> lista = (List<Usuario>) request.getAttribute("listaUsuarios");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

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

        <!-- FONDO OSCURO DEL MENÚ MÓVIL -->
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
                    <h1>Gestión de Usuarios</h1>

                    <p>
                        Administra usuarios, técnicos y administradores del sistema.
                    </p>
                </div>

                <a class="btn-panel"
                   href="${pageContext.request.contextPath}/UsuarioServlet?accion=nuevo">

                    <i class="fa-solid fa-user-plus"></i>
                    Nuevo registro
                </a>

            </div>

            <!-- ADMINISTRADORES -->
            <div class="section-panel">

                <div class="section-header">
                    <h2>Administradores</h2>

                    <p>
                        Cuentas con permisos completos sobre el sistema.
                    </p>
                </div>

                <div class="table-wrapper">

                    <table>

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

                        <%
                            if (lista != null) {

                                int contadorAdmin = 1;

                                for (Usuario u : lista) {

                                    if ("ADMIN".equals(u.getNombreRol())) {
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

                                <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=<%= u.getIdUsuario() %>">
                                    Editar
                                </a>

                                <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=eliminar&id=<%= u.getIdUsuario() %>"
                                   onclick="return confirm('¿Seguro que deseas desactivar este administrador?');">

                                    Desactivar
                                </a>

                            </td>
                        </tr>

                        <%
                                    }
                                }
                            }
                        %>

                    </table>

                </div>

            </div>

            <!-- USUARIOS -->
            <div class="section-panel">

                <div class="section-header">
                    <h2>Usuarios</h2>

                    <p>
                        Personas que registran solicitudes o incidencias de soporte.
                    </p>
                </div>

                <div class="table-wrapper">

                    <table>

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

                        <%
                            if (lista != null) {

                                int contadorUsuarios = 1;

                                for (Usuario u : lista) {

                                    if ("USUARIO".equals(u.getNombreRol())) {
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
                                        ? "-"
                                        : u.getTelefono() %>
                            </td>

                            <td>
                                <%= u.getArea() == null
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

                                <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=<%= u.getIdUsuario() %>">
                                    Editar
                                </a>

                                <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=eliminar&id=<%= u.getIdUsuario() %>"
                                   onclick="return confirm('¿Seguro que deseas desactivar este usuario?');">

                                    Desactivar
                                </a>

                            </td>
                        </tr>

                        <%
                                    }
                                }
                            }
                        %>

                    </table>

                </div>

            </div>

            <!-- TÉCNICOS -->
            <div class="section-panel">

                <div class="section-header">
                    <h2>Técnicos de soporte</h2>

                    <p>
                        Personal encargado de atender, diagnosticar y resolver tickets.
                    </p>
                </div>

                <div class="table-wrapper">

                    <table>

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

                        <%
                            if (lista != null) {

                                int contadorTecnicos = 1;

                                for (Usuario u : lista) {

                                    if ("TECNICO".equals(u.getNombreRol())) {
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
                                        ? "-"
                                        : u.getTelefono() %>
                            </td>

                            <td>
                                <%= u.getArea() == null
                                        ? "-"
                                        : u.getArea() %>
                            </td>

                            <td>
                                <%= u.getEspecialidad() == null
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

                                <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=<%= u.getIdUsuario() %>">
                                    Editar
                                </a>

                                <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=eliminar&id=<%= u.getIdUsuario() %>"
                                   onclick="return confirm('¿Seguro que deseas desactivar este técnico?');">

                                    Desactivar
                                </a>

                            </td>
                        </tr>

                        <%
                                    }
                                }
                            }
                        %>

                    </table>

                </div>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>