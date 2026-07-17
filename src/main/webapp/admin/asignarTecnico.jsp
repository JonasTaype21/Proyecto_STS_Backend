<%@page import="java.util.List"%>
<%@page import="bean.Usuario"%>
<%@page import="bean.Ticket"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Ticket ticket = (Ticket) request.getAttribute("ticket");
    List<Usuario> tecnicos = (List<Usuario>) request.getAttribute("listaTecnicos");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Asignar Técnico</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>
    <body class="iframe-body">

        <div class="iframe-content">

            <h1>Asignar Técnico</h1>

            <p><strong>Ticket:</strong> <%= ticket.getCodigoTicket() %></p>
            <p><strong>Título:</strong> <%= ticket.getTitulo() %></p>
            <p><strong>Estado:</strong> <%= ticket.getEstado() %></p>

            <form action="${pageContext.request.contextPath}/TicketServlet" method="post" target="_top">
                <input type="hidden" name="accion" value="asignar">
                <input type="hidden" name="idTicket" value="<%= ticket.getIdTicket() %>">

                <label>Técnico:</label><br>
                <select name="idTecnico" required>
                    <option value="">Seleccione</option>
                    <% if (tecnicos != null) {
            for (Usuario tec : tecnicos) { %>
                    <option value="<%= tec.getIdUsuario() %>">
                        <%= tec.getNombres() %> <%= tec.getApellidos() %> - <%= tec.getEspecialidad() %>
                    </option>
                    <% }} %>
                </select>

                <br><br>
                <button type="submit">Asignar</button>
            </form>

            <br>
            
        </div>
        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>