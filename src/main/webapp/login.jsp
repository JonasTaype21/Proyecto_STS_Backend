<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Sistema de Tickets</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/recursos/style.css?v=<%= System.currentTimeMillis() %>">
</head>

<body class="login-page">

<div class="login-container">

    <section class="login-left">

    <div class="login-brand centered-brand">

        <div class="brand-icon">
            <i class="fa-solid fa-headset"></i>
        </div>

        <h1>Soporte De Seguimiento de Tickets</h1>

        <p>
                        Registra, atiende y realiza seguimiento a tus tickets
                        de soporte de forma rápida, ordenada y segura.
        </p>

        <div class="brand-features">
            <span><i class="fa-solid fa-ticket"></i> Tickets</span>
            <span><i class="fa-solid fa-user-gear"></i> Técnicos</span>
            <span><i class="fa-solid fa-clock"></i> Seguimiento</span>
        </div>

    </div>

    <div class="login-footer">
        © 2026 Sistema de Seguimiento de Tickets
    </div>

</section>

    <section class="login-right">

        <div class="login-card">

            <h2>Bienvenido</h2>
            <p class="login-subtitle">Ingresa tus credenciales para continuar</p>

            <% if (request.getAttribute("error") != null) { %>  
                <div class="login-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="LoginServlet" method="post" autocomplete="on">

                <label>Correo electrónico</label>
                <input type="email" name="correo" required autocomplete="on">

                <label>Contraseña</label>
                <input type="password" name="clave" required autocomplete="current-password">
                <button type="submit">Iniciar sesión</button>

            </form>

            <div class="login-links">
                <span>¿Olvidaste tu contraseña?</span>
                <a href="#" onclick="alert('Comuníquese con el administrador del sistema para restablecer su contraseña.'); return false;">
                    Solicitar ayuda
                </a>
            </div>

        </div>

    </section>

</div>

<script src="${pageContext.request.contextPath}/recursos/main.js"></script>
</body>
</html>