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

    Usuario editar =
            (Usuario) request.getAttribute("usuarioEditar");

    String tituloFormulario = "Nuevo Registro";

    if (editar != null) {

        if ("ADMIN".equals(editar.getNombreRol())) {

            tituloFormulario = "Editar Administrador";

        } else if ("USUARIO".equals(editar.getNombreRol())) {

            tituloFormulario = "Editar Usuario";

        } else if ("TECNICO".equals(editar.getNombreRol())) {

            tituloFormulario = "Editar Técnico";

        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>
            <%= tituloFormulario %>
        </title>

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
                        <i class="fa-solid fa-user-gear"></i>
                        <%= tituloFormulario %>
                    </h1>

                    <p>
                        Complete los datos según el tipo de acceso
                        que desea registrar.
                    </p>

                </div>

                <a class="btn-panel secundario"
                   href="${pageContext.request.contextPath}/UsuarioServlet?accion=listar">

                    <i class="fa-solid fa-arrow-left"></i>
                    Volver

                </a>

            </div>

            <!-- FORMULARIO -->
            <div class="section-panel">

                <div class="section-header">

                    <div>

                        <h2>
                            <i class="fa-solid fa-id-card"></i>
                            Información del usuario
                        </h2>

                        <p>
                            Registre los datos personales y el tipo
                            de acceso que tendrá dentro del sistema.
                        </p>

                    </div>

                </div>

                <form action="${pageContext.request.contextPath}/UsuarioServlet"
                      method="post"
                      class="form-grid"
                      autocomplete="off">

                    <% if (editar != null) { %>

                    <input type="hidden"
                           name="idUsuario"
                           value="<%= editar.getIdUsuario() %>">

                    <% } %>

                    <!-- ROL -->
                    <div>

                        <label for="idRol">
                            Rol asignado:
                        </label>

                        <select class="input-control"
                                name="idRol"
                                id="idRol"
                                required
                                onchange="controlarCamposRol()">

                            <% if (editar == null) { %>

                            <option value="">
                                Seleccione rol
                            </option>

                            <% } %>

                            <option value="1"
                                    <%= editar != null
                                            && editar.getIdRol() == 1
                                                    ? "selected"
                                                    : "" %>>

                                ADMIN

                            </option>

                            <option value="2"
                                    <%= editar != null
                                            && editar.getIdRol() == 2
                                                    ? "selected"
                                                    : "" %>>

                                USUARIO

                            </option>

                            <option value="3"
                                    <%= editar != null
                                            && editar.getIdRol() == 3
                                                    ? "selected"
                                                    : "" %>>

                                TECNICO

                            </option>

                        </select>

                    </div>

                    <!-- NOMBRES -->
                    <div>

                        <label for="nombres">
                            Nombres:
                        </label>

                        <input class="input-control"
                               type="text"
                               name="nombres"
                               id="nombres"
                               required
                               autocomplete="off"
                               value="<%= editar != null
                                       ? editar.getNombres()
                                       : "" %>">

                    </div>

                    <!-- APELLIDOS -->
                    <div>

                        <label for="apellidos">
                            Apellidos:
                        </label>

                        <input class="input-control"
                               type="text"
                               name="apellidos"
                               id="apellidos"
                               required
                               autocomplete="off"
                               value="<%= editar != null
                                       ? editar.getApellidos()
                                       : "" %>">

                    </div>

                    <!-- CORREO -->
                    <div>

                        <label for="correo">
                            Correo:
                        </label>

                        <input class="input-control"
                               type="email"
                               name="correo"
                               id="correo"
                               required
                               autocomplete="off"
                               value="<%= editar != null
                                       ? editar.getCorreo()
                                       : "" %>">

                    </div>

                    <!-- CLAVE -->
                    <% if (editar == null) { %>

                    <div>

                        <label for="clave">
                            Clave:
                        </label>

                        <input class="input-control"
                               type="password"
                               name="clave"
                               id="clave"
                               required
                               autocomplete="new-password">

                    </div>

                    <% } %>

                    <!-- TELÉFONO -->
                    <div>

                        <label for="telefono">
                            Teléfono:
                        </label>

                        <input class="input-control"
                               type="text"
                               name="telefono"
                               id="telefono"
                               maxlength="9"
                               inputmode="numeric"
                               pattern="[0-9]{9}"
                               autocomplete="off"
                               value="<%= editar != null
                                       ? editar.getTelefono()
                                       : "" %>">

                    </div>

                    <!-- ÁREA -->
                    <div id="campoArea">

                        <label for="area">
                            Área:
                        </label>

                        <select class="input-control"
                                name="area"
                                id="area">

                            <option value="">
                                Seleccione área
                            </option>

                            <option value="Sistemas"
                                    <%= editar != null
                                            && "Sistemas".equals(
                                                    editar.getArea()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Sistemas

                            </option>

                            <option value="Soporte TI"
                                    <%= editar != null
                                            && "Soporte TI".equals(
                                                    editar.getArea()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Soporte TI

                            </option>

                            <option value="Contabilidad"
                                    <%= editar != null
                                            && "Contabilidad".equals(
                                                    editar.getArea()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Contabilidad

                            </option>

                            <option value="Finanzas"
                                    <%= editar != null
                                            && "Finanzas".equals(
                                                    editar.getArea()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Finanzas

                            </option>

                            <option value="Operaciones"
                                    <%= editar != null
                                            && "Operaciones".equals(
                                                    editar.getArea()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Operaciones

                            </option>

                            <option value="Administración"
                                    <%= editar != null
                                            && "Administración".equals(
                                                    editar.getArea()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Administración

                            </option>

                        </select>

                    </div>

                    <!-- ESPECIALIDAD -->
                    <div id="campoEspecialidad">

                        <label for="especialidad">
                            Especialidad:
                        </label>

                        <select class="input-control"
                                name="especialidad"
                                id="especialidad">

                            <option value="">
                                Seleccione especialidad
                            </option>

                            <option value="Hardware"
                                    <%= editar != null
                                            && "Hardware".equals(
                                                    editar.getEspecialidad()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Hardware

                            </option>

                            <option value="Software"
                                    <%= editar != null
                                            && "Software".equals(
                                                    editar.getEspecialidad()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Software

                            </option>

                            <option value="Redes"
                                    <%= editar != null
                                            && "Redes".equals(
                                                    editar.getEspecialidad()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Redes

                            </option>

                            <option value="Correo y accesos"
                                    <%= editar != null
                                            && "Correo y accesos".equals(
                                                    editar.getEspecialidad()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Correo y accesos

                            </option>

                            <option value="Soporte general"
                                    <%= editar != null
                                            && "Soporte general".equals(
                                                    editar.getEspecialidad()
                                            )
                                                    ? "selected"
                                                    : "" %>>

                                Soporte general

                            </option>

                        </select>

                    </div>

                    <!-- ESTADO -->
                    <% if (editar != null) { %>

                    <div>

                        <label for="estado">
                            Estado:
                        </label>

                        <select class="input-control"
                                name="estado"
                                id="estado">

                            <option value="1"
                                    <%= editar.getEstado() == 1
                                            ? "selected"
                                            : "" %>>

                                Activo

                            </option>

                            <option value="0"
                                    <%= editar.getEstado() == 0
                                            ? "selected"
                                            : "" %>>

                                Inactivo

                            </option>

                        </select>

                    </div>

                    <% } %>

                    <!-- ACCIONES -->
                    <div class="form-actions">

                        <button type="submit"
                                class="btn-panel">

                            <i class="fa-solid fa-floppy-disk"></i>

                            <%= editar == null
                                    ? "Guardar registro"
                                    : "Actualizar registro" %>

                        </button>

                        <a class="btn-panel secundario"
                           href="${pageContext.request.contextPath}/UsuarioServlet?accion=listar">

                            <i class="fa-solid fa-xmark"></i>
                            Cancelar

                        </a>

                    </div>

                </form>

            </div>

        </div>

        <script>
            const esEdicion =
                    <%= editar != null ? "true" : "false" %>;

            function controlarCamposRol() {

                const rol =
                        document.getElementById("idRol").value;

                const campoArea =
                        document.getElementById("campoArea");

                const campoEspecialidad =
                        document.getElementById(
                                "campoEspecialidad"
                        );

                const area =
                        document.getElementById("area");

                const especialidad =
                        document.getElementById(
                                "especialidad"
                        );

                campoArea.style.display = "none";
                campoEspecialidad.style.display = "none";

                area.required = false;
                especialidad.required = false;

                if (rol === "2") {

                    campoArea.style.display = "block";

                    area.required = true;

                } else if (rol === "3") {

                    campoArea.style.display = "block";

                    campoEspecialidad.style.display =
                            "block";

                    area.required = true;
                    especialidad.required = true;

                } else {

                    area.value = "";
                    especialidad.value = "";

                }
            }

            document.addEventListener(
                    "DOMContentLoaded",
                    function () {

                        controlarCamposRol();

                        const telefono =
                                document.getElementById(
                                        "telefono"
                                );

                        telefono.addEventListener(
                                "input",
                                function () {

                                    this.value =
                                            this.value.replace(
                                                    /\D/g,
                                                    ""
                                            );

                                }
                        );

                        if (!esEdicion) {

                            setTimeout(function () {

                                const correo =
                                        document.getElementById(
                                                "correo"
                                        );

                                const clave =
                                        document.getElementById(
                                                "clave"
                                        );

                                if (correo) {
                                    correo.value = "";
                                }

                                if (clave) {
                                    clave.value = "";
                                }

                            }, 100);

                        }
                    }
            );
        </script>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>