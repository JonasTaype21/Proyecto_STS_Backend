<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">

        <meta name="viewport"
              content="width=device-width, initial-scale=1.0">

        <title>Error</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
    </head>

    <body class="error-page">

        <div class="error-card">

            <h2>Ocurrió un error</h2>

            <p>
                No se pudo procesar la solicitud.
            </p>

            <a class="btn-panel"
               href="${pageContext.request.contextPath}/login.jsp">

                Volver al inicio
            </a>

        </div>

    </body>
</html>