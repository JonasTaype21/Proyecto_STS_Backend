<%@page import="java.util.List"%>
<%@page import="bean.Categoria"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("listaCategorias");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Registrar Solicitud</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    </head>

    <body class="dashboard-body">

        <div class="sidebar">

            <div class="logo-area">
                <h2>STS</h2>
                <span>Soporte TI</span>
            </div>

            <div class="menu-title">MENÚ USUARIO</div>

            <a class="menu-item" href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp">
                <i class="fa-solid fa-house"></i> Dashboard
            </a>

            <a class="menu-item active" href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo">
                <i class="fa-solid fa-circle-plus"></i> Nueva solicitud
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp?vista=misTickets">
                <i class="fa-solid fa-ticket"></i> Mis tickets
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp?vista=seguimiento">
                <i class="fa-solid fa-clock-rotate-left"></i> Seguimiento de Tickets
            </a>

            <a class="menu-item logout" href="${pageContext.request.contextPath}/LogoutServlet">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar sesión
            </a>

        </div>

        <div class="main-content">

            <div class="topbar">
                <div>
                    <h1>Registrar Solicitud de Soporte</h1>
                    <p>Complete los datos de la incidencia para generar un nuevo ticket.</p>
                </div>

                <div class="user-badge">USUARIO</div>
            </div>

            <div class="section-panel">

                <% if (request.getAttribute("error") != null) { %>
                <p style="color:red;"><%= request.getAttribute("error") %></p>
                <% } %>

                <form action="${pageContext.request.contextPath}/TicketServlet" method="post" class="form-grid">
                    <input type="hidden" name="accion" value="registrar">

                    <div>
                        <label>Categoría:</label>
                        <select name="idCategoria" required>
                            <option value="">Seleccione una categoría</option>
                            <% if (categorias != null) {
                        for (Categoria c : categorias) { %>
                            <option value="<%= c.getIdCategoria() %>">
                                <%= c.getNombreCategoria() %>
                            </option>
                            <% }} %>
                        </select>
                    </div>

                    <div>
                        <label>Prioridad:</label>
                        <select name="prioridad" required>
                            <option value="">Seleccione prioridad</option>
                            <option value="BAJA">BAJA</option>
                            <option value="MEDIA">MEDIA</option>
                            <option value="ALTA">ALTA</option>
                            <option value="CRITICA">CRITICA</option>
                        </select>
                    </div>

                    <div class="form-full">
                        <label>Título:</label>
                        <input type="text" name="titulo" maxlength="150" required>
                    </div>

                    <div class="form-full">
                        <label>Descripción del problema:</label>
                        <textarea name="descripcion" rows="5" required></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" onclick="return confirm('¿Deseas registrar esta solicitud?');">
                            Registrar solicitud
                        </button>

                        <a class="btn-panel secundario" href="${pageContext.request.contextPath}/usuario/dashboardUsuario.jsp">
                            Cancelar
                        </a>
                    </div>
                </form>

            </div>

        </div>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>