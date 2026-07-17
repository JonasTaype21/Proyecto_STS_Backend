<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bean.HistorialTicket"%>
<%@page import="bean.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<HistorialTicket> historial
            = (List<HistorialTicket>) request.getAttribute("historial");

    SimpleDateFormat formatoFecha
            = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Seguimiento de Tickets</title>

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

            <a class="menu-item"
               href="${pageContext.request.contextPath}/TicketServlet?accion=misTickets">

                <i class="fa-solid fa-ticket"></i>
                <span>Mis tickets</span>
            </a>

            <a class="menu-item active"
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
                    <h1>Seguimiento de Tickets</h1>

                    <p>
                        Consulta el avance y las fechas principales de tus solicitudes.
                    </p>
                </div>

                <div class="user-badge">
                    USUARIO
                </div>

            </div>

            <section class="section-panel">

                <div class="section-header">

                    <h2>Estado general de mis tickets</h2>

                    <p>
                        Revisa la evolución de cada solicitud desde su creación.
                    </p>

                </div>

                <div class="table-wrapper">

                    <table class="tabla-historial">

                        <thead>
                            <tr>
                                <th>Ticket</th>
                                <th>Categoría</th>
                                <th>Prioridad</th>
                                <th>Técnico</th>
                                <th>Creado</th>
                                <th>Asignado</th>
                                <th>En proceso</th>
                                <th>Resuelto</th>
                                <th>Cerrado</th>
                                <th>Estado actual</th>
                                <th>Acción</th>
                            </tr>
                        </thead>

                        <tbody>

                            <% if (historial != null && !historial.isEmpty()) {

                                    for (HistorialTicket h : historial) {
                            %>

                            <tr>

                                <td data-label="Ticket">
                                    <strong>
                                        <%= h.getCodigoTicket() %>
                                    </strong>
                                </td>

                                <td data-label="Categoría">
                                    <%= h.getCategoria() %>
                                </td>

                                <td data-label="Prioridad">

                                    <span class="badge prioridad-<%= h.getPrioridad().toLowerCase() %>">
                                        <%= h.getPrioridad() %>
                                    </span>

                                </td>

                                <td data-label="Técnico">

                                    <%= h.getTecnicoAsignado() == null
                                            ? "Sin asignar"
                                            : h.getTecnicoAsignado() %>

                                </td>

                                <td data-label="Creado">

                                    <%= h.getFechaCreacion() == null
                                            ? "-"
                                            : formatoFecha.format(h.getFechaCreacion()) %>

                                </td>

                                <td data-label="Asignado">

                                    <%= h.getFechaAsignacion() == null
                                            ? "-"
                                            : formatoFecha.format(h.getFechaAsignacion()) %>

                                </td>

                                <td data-label="En proceso">

                                    <%= h.getFechaInicio() == null
                                            ? "-"
                                            : formatoFecha.format(h.getFechaInicio()) %>

                                </td>

                                <td data-label="Resuelto">

                                    <%= h.getFechaSolucion() == null
                                            ? "-"
                                            : formatoFecha.format(h.getFechaSolucion()) %>

                                </td>

                                <td data-label="Cerrado">

                                    <%= h.getFechaCierre() == null
                                            ? "-"
                                            : formatoFecha.format(h.getFechaCierre()) %>

                                </td>

                                <td data-label="Estado actual">

                                    <span class="estado-activo">
                                        <%= h.getEstadoActual() %>
                                    </span>

                                </td>

                                <td data-label="Acción">

                                    <% if ("RESUELTO".equals(h.getEstadoActual())) { %>

                                    <button type="button"
                                            class="btn-table"
                                            onclick="abrirModalCierre(
                                                            '<%= h.getIdTicket() %>',
                                                            '<%= h.getCodigoTicket() %>'
                                                            )">

                                        <i class="fa-solid fa-check"></i>
                                        Cerrar ticket
                                    </button>

                                    <% } else if ("CERRADO".equals(h.getEstadoActual())) { %>

                                    <span class="texto-cerrado">
                                        <i class="fa-solid fa-circle-check"></i>
                                        Cerrado
                                    </span>

                                    <% } else { %>

                                    <a class="btn-table secundario"
                                       href="${pageContext.request.contextPath}/TicketServlet?accion=seguimientoTicket&id=<%= h.getIdTicket() %>&seguimiento=si">

                                        <i class="fa-solid fa-eye"></i>
                                        Ver detalle
                                    </a>

                                    <% } %>

                                </td>

                            </tr>

                            <%      }
                                } else {
                            %>

                            <tr>
                                <td colspan="11"
                                    class="tabla-vacia">

                                    <i class="fa-solid fa-chart-line"></i>

                                    <p>
                                        No existen tickets para mostrar en seguimiento.
                                    </p>

                                </td>
                            </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

            </section>

        </main>

        <!-- MODAL PARA CERRAR TICKET -->
        <div id="modalCierre"
             class="modal-cierre"
             aria-hidden="true">

            <div class="modal-cierre-content">

                <button type="button"
                        class="modal-close"
                        aria-label="Cerrar ventana"
                        onclick="cerrarModalCierre()">

                    <i class="fa-solid fa-xmark"></i>
                </button>

                <h2>Cerrar ticket</h2>

                <p id="textoTicketCierre"></p>

                <form action="${pageContext.request.contextPath}/TicketServlet"
                      method="post">

                    <input type="hidden"
                           name="accion"
                           value="cerrar">

                    <input type="hidden"
                           name="idTicket"
                           id="idTicketCerrar">

                    <input type="hidden"
                           name="origen"
                           value="seguimiento">

                    <label for="comentarioCierre">
                        Comentario de cierre
                    </label>

                    <textarea id="comentarioCierre"
                              name="comentarioCierre"
                              rows="4"
                              placeholder="Ejemplo: Validé la solución y el ticket puede cerrarse."
                              required></textarea>

                    <div class="modal-actions">

                        <button type="submit"
                                onclick="return confirm('¿Deseas cerrar este ticket?');">

                            <i class="fa-solid fa-check"></i>
                            Confirmar cierre
                        </button>

                        <button type="button"
                                class="btn-secundario"
                                onclick="cerrarModalCierre()">

                            Cancelar
                        </button>

                    </div>

                </form>

            </div>

        </div>

        <script>
            function abrirModalCierre(idTicket, codigoTicket) {
                const modal = document.getElementById("modalCierre");
                const inputIdTicket = document.getElementById("idTicketCerrar");
                const textoTicket = document.getElementById("textoTicketCierre");
                const comentario = document.getElementById("comentarioCierre");

                if (!modal || !inputIdTicket || !textoTicket) {
                    return;
                }

                inputIdTicket.value = idTicket;
                textoTicket.textContent = "Ticket seleccionado: " + codigoTicket;

                if (comentario) {
                    comentario.value = "";
                }

                modal.style.display = "flex";
                modal.setAttribute("aria-hidden", "false");
            }

            function cerrarModalCierre() {
                const modal = document.getElementById("modalCierre");

                if (!modal) {
                    return;
                }

                modal.style.display = "none";
                modal.setAttribute("aria-hidden", "true");
            }

            document.addEventListener("keydown", function (event) {
                if (event.key === "Escape") {
                    cerrarModalCierre();
                }
            });

            document.addEventListener("click", function (event) {
                const modal = document.getElementById("modalCierre");

                if (modal && event.target === modal) {
                    cerrarModalCierre();
                }
            });
        </script>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>

    </body>
</html>