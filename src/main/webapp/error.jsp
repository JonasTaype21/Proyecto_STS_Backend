<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Error</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>
    <body>

        <h2>Ocurrió un error</h2>
        <p>No se pudo procesar la solicitud.</p>

        <a href="${pageContext.request.contextPath}/login.jsp">Volver al inicio</a>

        <script src="${pageContext.request.contextPath}/recursos/main.js"></script>
    </body>
</html>