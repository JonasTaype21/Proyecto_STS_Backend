<%@page import="bean.Ticket"%>
<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Ticket ticket
            = (Ticket) request.getAttribute("ticket");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Atender Ticket</title>

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
                MENÚ TÉCNICO
            </div>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/tecnico/dashboardTecnico.jsp">

                <i class="fa-solid fa-house"></i>
                <span>Dashboard</span>
            </a>

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                <i class="fa-solid fa-screwdriver-wrench"></i>
                <span>Tickets asignados</span>
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
                    <h1>Atender Ticket</h1>

                    <p>
                        Inicia la atención o registra la solución técnica.
                    </p>
                </div>

                <div class="user-badge">
                    TÉCNICO
                </div>

            </div>

            <% if (ticket == null) { %>

            <section class="detalle-card">

                <div class="estado-vacio">

                    <i class="fa-solid fa-circle-exclamation"></i>

                    <h2>Ticket no encontrado</h2>

                    <p>
                        No fue posible cargar el ticket seleccionado.
                    </p>

                    <a class="btn-panel"
                       href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                        <i class="fa-solid fa-arrow-left"></i>
                        Volver a tickets
                    </a>

                </div>

            </section>

            <% } else { %>

            <div class="page-actions">

                <a class="btn-panel secundario"
                   href="${pageContext.request.contextPath}/TicketServlet?accion=ticketsAsignados">

                    <i class="fa-solid fa-arrow-left"></i>
                    Volver a tickets
                </a>

                <a class="btn-panel secundario"
                   href="${pageContext.request.contextPath}/TicketServlet?accion=detalle&id=<%= ticket.getIdTicket() %>">

                    <i class="fa-solid fa-eye"></i>
                    Ver detalle
                </a>

            </div>

            <div class="ticket-detail-header detalle-card-header">

                <div>
                    <span class="ticket-codigo">
                        <%= ticket.getCodigoTicket() %>
                    </span>

                    <h1>
                        <%= ticket.getTitulo() %>
                    </h1>
                </div>

                <span class="estado-activo">
                    <%= ticket.getEstado() %>
                </span>

            </div>

            <% if (request.getAttribute("error") != null) { %>

            <div class="mensaje-error">

                <i class="fa-solid fa-circle-exclamation"></i>

                <span>
                    <%= request.getAttribute("error") %>
                </span>

            </div>

            <% } %>

            <% if ("ASIGNADO".equals(ticket.getEstado())) { %>

            <div class="detalle-atencion-grid">

                <div>

                    <section class="detalle-card">

                        <h2>
                            <i class="fa-solid fa-circle-info"></i>
                            Información del ticket
                        </h2>

                        <div class="info-grid">

                            <div>
                                <span>Usuario</span>

                                <strong>
                                    <%= ticket.getUsuarioReporta() %>
                                </strong>
                            </div>

                            <div>
                                <span>Categoría</span>

                                <strong>
                                    <%= ticket.getNombreCategoria() %>
                                </strong>
                            </div>

                            <div>
                                <span>Prioridad</span>

                                <strong>
                                    <span class="badge prioridad-<%= ticket.getPrioridad().toLowerCase() %>">
                                        <%= ticket.getPrioridad() %>
                                    </span>
                                </strong>
                            </div>

                            <div>
                                <span>Estado</span>

                                <strong>
                                    <%= ticket.getEstado() %>
                                </strong>
                            </div>

                        </div>

                    </section>

                    <section class="detalle-card">

                        <h2>
                            <i class="fa-solid fa-file-lines"></i>
                            Descripción del problema
                        </h2>

                        <p class="texto-detalle">
                            <%= ticket.getDescripcion() %>
                        </p>

                    </section>

                </div>

                <section class="detalle-card">

                    <h2>
                        <i class="fa-solid fa-play"></i>
                        Iniciar atención técnica
                    </h2>

                    <p>
                        Al iniciar la atención, el ticket cambiará de
                        <strong>ASIGNADO</strong> a
                        <strong>EN_PROCESO</strong>.
                    </p>

                    <form action="${pageContext.request.contextPath}/TicketServlet"
                          method="post"
                          class="form-atencion">

                        <input type="hidden"
                               name="accion"
                               value="iniciar">

                        <input type="hidden"
                               name="idTicket"
                               value="<%= ticket.getIdTicket() %>">

                        <button type="submit"
                                onclick="return confirm('¿Deseas iniciar la atención de este ticket?');">

                            <i class="fa-solid fa-play"></i>
                            Iniciar atención
                        </button>

                    </form>

                </section>

            </div>

            <% } else if ("EN_PROCESO".equals(ticket.getEstado())) { %>

            <div class="detalle-atencion-grid">

                <div>

                    <section class="detalle-card">

                        <h2>
                            <i class="fa-solid fa-circle-info"></i>
                            Información del ticket
                        </h2>

                        <div class="info-grid">

                            <div>
                                <span>Usuario</span>

                                <strong>
                                    <%= ticket.getUsuarioReporta() %>
                                </strong>
                            </div>

                            <div>
                                <span>Categoría</span>

                                <strong>
                                    <%= ticket.getNombreCategoria() %>
                                </strong>
                            </div>

                            <div>
                                <span>Prioridad</span>

                                <strong>
                                    <span class="badge prioridad-<%= ticket.getPrioridad().toLowerCase() %>">
                                        <%= ticket.getPrioridad() %>
                                    </span>
                                </strong>
                            </div>

                            <div>
                                <span>Estado</span>

                                <strong>
                                    <%= ticket.getEstado() %>
                                </strong>
                            </div>

                        </div>

                    </section>

                    <section class="detalle-card">

                        <h2>
                            <i class="fa-solid fa-file-lines"></i>
                            Descripción del problema
                        </h2>

                        <p class="texto-detalle">
                            <%= ticket.getDescripcion() %>
                        </p>

                    </section>

                </div>

                <section class="detalle-card">

                    <h2>
                        <i class="fa-solid fa-clipboard-check"></i>
                        Registrar solución
                    </h2>

                    <p>
                        Registra el diagnóstico y la solución aplicada al ticket.
                    </p>

                    <form action="${pageContext.request.contextPath}/TicketServlet"
                          method="post"
                          class="form-atencion">

                        <input type="hidden"
                               name="accion"
                               value="solucionar">

                        <input type="hidden"
                               name="idTicket"
                               value="<%= ticket.getIdTicket() %>">

                        <label for="diagnostico">
                            Diagnóstico
                        </label>

                        <textarea id="diagnostico"
                                  name="diagnostico"
                                  rows="4"
                                  placeholder="Describe la causa identificada del problema"
                                  required></textarea>

                        <label for="solucionAplicada">
                            Solución aplicada
                        </label>

                        <textarea id="solucionAplicada"
                                  name="solucionAplicada"
                                  rows="4"
                                  placeholder="Describe las acciones realizadas para resolverlo"
                                  required></textarea>

                        <label for="observaciones">
                            Observaciones
                        </label>

                        <textarea id="observaciones"
                                  name="observaciones"
                                  rows="3"
                                  placeholder="Información adicional opcional"></textarea>

                        <div class="form-actions">

                            <button type="submit"
                                    onclick="return confirm('¿Deseas registrar esta solución?');">

                                <i class="fa-solid fa-floppy-disk"></i>
                                Registrar solución
                            </button>

                        </div>

                    </form>

                </section>

            </div>

            <% } else { %>

            <section class="detalle-card">

                <div class="estado-vacio">

                    <i class="fa-solid fa-circle-check"></i>

                    <h2>El ticket ya no requiere atención</h2>

                    <p>
                        El estado actual del ticket es
                        <strong><%= ticket.getEstado() %></strong>.
                    </p>

                    <a class="btn-panel"
                       href="${pageContext.request.contextPath}/TicketServlet?accion=detalle&id=<%= ticket.getIdTicket() %>">

                        <i class="fa-solid fa-eye"></i>
                        Consultar detalle
                    </a>

                </div>

            </section>

            <% } %>

            <% } %>

        </main>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>