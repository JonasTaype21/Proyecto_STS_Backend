<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Acceso denegado</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>

    <body class="error-page">

        <div class="error-card">

            <h2>Acceso denegado</h2>

            <p>
                No tienes permisos para ingresar a esta sección.
            </p>

            <a class="btn-panel"
               href="${pageContext.request.contextPath}/login.jsp">

                Volver al login
            </a>

        </div>

    </body>
</html>