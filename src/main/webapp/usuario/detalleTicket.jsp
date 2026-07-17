<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bean.Ticket"%>
<%@page import="bean.HistorialTicket"%>
<%@page import="bean.SolucionTicket"%>
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

    List<HistorialTicket> historial
            = (List<HistorialTicket>) request.getAttribute("historial");

    SolucionTicket solucion
            = (SolucionTicket) request.getAttribute("solucion");

    String seguimiento
            = request.getParameter("seguimiento");

    boolean mostrarSeguimiento
            = "si".equalsIgnoreCase(seguimiento);

    SimpleDateFormat formatoFecha
            = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    if (ticket == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/TicketServlet?accion=misTickets"
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Detalle del Ticket</title>

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

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=nuevo">

                <i class="fa-solid fa-circle-plus"></i>
                <span>Nueva solicitud</span>
            </a>

            <a class="menu-item <%= !mostrarSeguimiento ? "active" : "" %>"
               href="${pageContext.request.contextPath}/TicketServlet?accion=misTickets">

                <i class="fa-solid fa-ticket"></i>
                <span>Mis tickets</span>
            </a>

            <a class="menu-item <%= mostrarSeguimiento ? "active" : "" %>"
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
                    <h1>Detalle del Ticket</h1>

                    <p>
                        Información completa de la solicitud seleccionada.
                    </p>
                </div>

                <div class="user-badge">
                    USUARIO
                </div>

            </div>

            <div class="page-actions">

                <a class="btn-panel secundario"
                   href="<%= mostrarSeguimiento
                           ? request.getContextPath() + "/TicketServlet?accion=seguimientoUsuario"
                           : request.getContextPath() + "/TicketServlet?accion=misTickets" %>">

                    <i class="fa-solid fa-arrow-left"></i>
                    Volver
                </a>

            </div>

            <section class="detalle-card">

                <div class="detalle-card-header">

                    <div>
                        <span class="ticket-codigo">
                            <%= ticket.getCodigoTicket() %>
                        </span>

                        <h2>
                            <%= ticket.getTitulo() %>
                        </h2>
                    </div>

                    <span class="estado-activo">
                        <%= ticket.getEstado() %>
                    </span>

                </div>

                <div class="detalle-grid">

                    <div class="detalle-item">

                        <span class="detalle-label">
                            Categoría
                        </span>

                        <span>
                            <%= ticket.getNombreCategoria() %>
                        </span>

                    </div>

                    <div class="detalle-item">

                        <span class="detalle-label">
                            Prioridad
                        </span>

                        <span class="badge prioridad-<%= ticket.getPrioridad().toLowerCase() %>">
                            <%= ticket.getPrioridad() %>
                        </span>

                    </div>

                    <div class="detalle-item">

                        <span class="detalle-label">
                            Técnico asignado
                        </span>

                        <span>
                            <%= ticket.getTecnicoAsignado() == null
                                    ? "Sin asignar"
                                    : ticket.getTecnicoAsignado() %>
                        </span>

                    </div>

                    <div class="detalle-item">

                        <span class="detalle-label">
                            Fecha de creación
                        </span>

                        <span>
                            <%= ticket.getFechaCreacion() == null
                                    ? "-"
                                    : formatoFecha.format(ticket.getFechaCreacion()) %>
                        </span>

                    </div>

                </div>

                <div class="detalle-descripcion">

                    <span class="detalle-label">
                        Descripción
                    </span>

                    <p>
                        <%= ticket.getDescripcion() %>
                    </p>

                </div>

            </section>

            <section class="detalle-card">

                <h2>
                    <i class="fa-solid fa-screwdriver-wrench"></i>
                    Solución
                </h2>

                <% if (solucion != null) { %>

                <div class="detalle-solucion-grid">

                    <div>
                        <span class="detalle-label">
                            Diagnóstico
                        </span>

                        <p>
                            <%= solucion.getDiagnostico() %>
                        </p>
                    </div>

                    <div>
                        <span class="detalle-label">
                            Solución aplicada
                        </span>

                        <p>
                            <%= solucion.getSolucionAplicada() %>
                        </p>
                    </div>

                    <div>
                        <span class="detalle-label">
                            Observaciones
                        </span>

                        <p>
                            <%= solucion.getObservaciones() == null
                                    || solucion.getObservaciones().trim().isEmpty()
                                            ? "Sin observaciones"
                                            : solucion.getObservaciones() %>
                        </p>
                    </div>

                    <div>
                        <span class="detalle-label">
                            Fecha de solución
                        </span>

                        <p>
                            <%= solucion.getFechaSolucion() == null
                                    ? "-"
                                    : formatoFecha.format(solucion.getFechaSolucion()) %>
                        </p>
                    </div>

                </div>

                <% } else { %>

                <div class="estado-vacio">

                    <i class="fa-solid fa-hourglass-half"></i>

                    <p>
                        Todavía no se ha registrado una solución para este ticket.
                    </p>

                </div>

                <% } %>

            </section>

            <% if (mostrarSeguimiento) { %>

            <section class="detalle-card">

                <h2>
                    <i class="fa-solid fa-clock-rotate-left"></i>
                    Historial del Ticket
                </h2>

                <div class="table-wrapper">

                    <table class="tabla-historial">

                        <thead>
                            <tr>
                                <th>Etapa</th>
                                <th>Estado anterior</th>
                                <th>Estado nuevo</th>
                                <th>Fecha</th>
                                <th>Responsable</th>
                                <th>Comentario</th>
                            </tr>
                        </thead>

                        <tbody>

                            <% if (historial != null && !historial.isEmpty()) {

                                    for (HistorialTicket h : historial) {
                            %>

                            <tr>

                                <td data-label="Etapa">
                                    <strong>
                                        <%= h.getAccion() %>
                                    </strong>
                                </td>

                                <td data-label="Estado anterior">

                                    <%= h.getEstadoAnterior() == null
                                            ? "-"
                                            : h.getEstadoAnterior() %>

                                </td>

                                <td data-label="Estado nuevo">

                                    <span class="estado-activo">
                                        <%= h.getEstadoNuevo() %>
                                    </span>

                                </td>

                                <td data-label="Fecha">

                                    <%= h.getFechaAccion() == null
                                            ? "-"
                                            : formatoFecha.format(h.getFechaAccion()) %>

                                </td>

                                <td data-label="Responsable">
                                    <%= h.getNombreUsuario() %>
                                </td>

                                <td data-label="Comentario">

                                    <%= h.getComentario() == null
                                            || h.getComentario().trim().isEmpty()
                                                    ? "-"
                                                    : h.getComentario() %>

                                </td>

                            </tr>

                            <%      }
                                } else {
                            %>

                            <tr>
                                <td colspan="6"
                                    class="tabla-vacia">

                                    No existe historial disponible.
                                </td>
                            </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

            </section>

            <% } %>

            <% if ("RESUELTO".equals(ticket.getEstado())
                        && mostrarSeguimiento) { %>

            <section class="detalle-card">

                <h2>
                    <i class="fa-solid fa-list-check"></i>
                    Acciones del Ticket
                </h2>

                <div class="ticket-actions-grid">

                    <form action="${pageContext.request.contextPath}/TicketServlet"
                          method="post"
                          class="action-form">

                        <input type="hidden"
                               name="accion"
                               value="cerrar">

                        <input type="hidden"
                               name="idTicket"
                               value="<%= ticket.getIdTicket() %>">

                        <input type="hidden"
                               name="origen"
                               value="seguimiento">

                        <h3>Cerrar ticket</h3>

                        <p>
                            Confirma que la solución aplicada resolvió el problema.
                        </p>

                        <label for="comentarioCierre">
                            Comentario de cierre
                        </label>

                        <textarea id="comentarioCierre"
                                  name="comentarioCierre"
                                  rows="3"
                                  placeholder="Indique por qué confirma el cierre"
                                  required></textarea>

                        <button type="submit"
                                onclick="return confirm('¿Deseas cerrar este ticket?');">

                            <i class="fa-solid fa-check"></i>
                            Cerrar ticket
                        </button>

                    </form>

                    <form action="${pageContext.request.contextPath}/TicketServlet"
                          method="post"
                          class="action-form">

                        <input type="hidden"
                               name="accion"
                               value="reabrir">

                        <input type="hidden"
                               name="idTicket"
                               value="<%= ticket.getIdTicket() %>">

                        <h3>Reabrir ticket</h3>

                        <p>
                            Utiliza esta opción si el inconveniente continúa.
                        </p>

                        <label for="motivo">
                            Motivo para reabrir
                        </label>

                        <textarea id="motivo"
                                  name="motivo"
                                  rows="3"
                                  placeholder="Explique por qué el problema continúa"
                                  required></textarea>

                        <button type="submit"
                                class="btn-advertencia"
                                onclick="return confirm('¿Deseas reabrir este ticket?');">

                            <i class="fa-solid fa-rotate-left"></i>
                            Reabrir ticket
                        </button>

                    </form>

                </div>

            </section>

            <% } %>

        </main>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>