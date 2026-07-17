<%@page import="java.util.List"%>
<%@page import="bean.Categoria"%>
<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Categoria> categorias
            = (List<Categoria>) request.getAttribute("listaCategorias");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Registrar Solicitud</title>

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
                MENÚ USUARIO
            </div>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp">

                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo">

                <i class="fa-solid fa-circle-plus"></i>
                <span>Nueva solicitud</span>
            </a>

            <a class="menu-item"
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
                    <h1>Registrar solicitud de soporte</h1>

                    <p>
                        Complete los datos de la incidencia para generar un ticket.
                    </p>
                </div>

                <div class="user-badge">
                    USUARIO
                </div>

            </div>

            <section class="section-panel">

                <% if (request.getAttribute("error") != null) { %>

                <div class="mensaje-error">
                    <i class="fa-solid fa-circle-exclamation"></i>

                    <span>
                        <%= request.getAttribute("error") %>
                    </span>
                </div>

                <% } %>

                <form action="${pageContext.request.contextPath}/TicketServlet"
                      method="post"
                      class="form-grid">

                    <input type="hidden"
                           name="accion"
                           value="registrar">

                    <div>
                        <label for="idCategoria">
                            Categoría
                        </label>

                        <select id="idCategoria"
                                name="idCategoria"
                                required>

                            <option value="">
                                Seleccione una categoría
                            </option>

                            <% if (categorias != null) {
                                    for (Categoria c : categorias) {
                            %>

                            <option value="<%= c.getIdCategoria() %>">
                                <%= c.getNombreCategoria() %>
                            </option>

                            <%      }
                                } %>

                        </select>
                    </div>

                    <div>
                        <label for="prioridad">
                            Prioridad
                        </label>

                        <select id="prioridad"
                                name="prioridad"
                                required>

                            <option value="">
                                Seleccione prioridad
                            </option>

                            <option value="BAJA">
                                BAJA
                            </option>

                            <option value="MEDIA">
                                MEDIA
                            </option>

                            <option value="ALTA">
                                ALTA
                            </option>

                            <option value="CRITICA">
                                CRÍTICA
                            </option>

                        </select>
                    </div>

                    <div class="form-full">

                        <label for="titulo">
                            Título
                        </label>

                        <input type="text"
                               id="titulo"
                               name="titulo"
                               maxlength="150"
                               placeholder="Ejemplo: No puedo acceder al sistema"
                               required>

                    </div>

                    <div class="form-full">

                        <label for="descripcion">
                            Descripción del problema
                        </label>

                        <textarea id="descripcion"
                                  name="descripcion"
                                  rows="5"
                                  placeholder="Describa el inconveniente con la mayor claridad posible"
                                  required></textarea>

                    </div>

                    <div class="form-actions">

                        <button type="submit"
                                onclick="return confirm('¿Deseas registrar esta solicitud?');">

                            <i class="fa-solid fa-floppy-disk"></i>
                            Registrar solicitud
                        </button>

                        <a class="btn-panel secundario"
                           href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp">

                            <i class="fa-solid fa-xmark"></i>
                            Cancelar
                        </a>

                    </div>

                </form>

            </section>

        </main>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>