<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Acceso denegado</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>
    <body>

        <h2>Acceso denegado</h2>
        <p>No tienes permisos para ingresar a esta sección.</p>

        <a href="${pageContext.request.contextPath}/login.jsp">Volver al login</a>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>