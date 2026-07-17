document.addEventListener("DOMContentLoaded", () => {

    // =========================
    // MENÚ LATERAL RESPONSIVE
    // =========================

    const menuToggle = document.getElementById("menuToggle");
    const sidebar = document.querySelector(".sidebar");
    const sidebarOverlay = document.getElementById("sidebarOverlay");

    function abrirMenu() {

        if (!sidebar) {
            return;
        }

        sidebar.classList.add("sidebar-open");

        if (sidebarOverlay) {
            sidebarOverlay.classList.add("overlay-active");
        }

        if (menuToggle) {
            menuToggle.setAttribute("aria-expanded", "true");
        }

        document.body.classList.add("menu-open");
    }

    function cerrarMenu() {

        if (!sidebar) {
            return;
        }

        sidebar.classList.remove("sidebar-open");

        if (sidebarOverlay) {
            sidebarOverlay.classList.remove("overlay-active");
        }

        if (menuToggle) {
            menuToggle.setAttribute("aria-expanded", "false");
        }

        document.body.classList.remove("menu-open");
    }

    if (menuToggle && sidebar) {

        menuToggle.addEventListener("click", () => {

            if (sidebar.classList.contains("sidebar-open")) {
                cerrarMenu();
            } else {
                abrirMenu();
            }

        });
    }

    if (sidebarOverlay) {
        sidebarOverlay.addEventListener("click", cerrarMenu);
    }

    document.addEventListener("keydown", event => {

        if (event.key === "Escape") {
            cerrarMenu();
        }

    });

    document.querySelectorAll(".sidebar .menu-item").forEach(enlace => {

        enlace.addEventListener("click", () => {

            if (window.innerWidth <= 900) {
                cerrarMenu();
            }

        });

    });

    window.addEventListener("resize", () => {

        if (window.innerWidth > 900) {
            cerrarMenu();
        }

    });

    // =========================
    // SOLO NÚMEROS EN TELÉFONO
    // =========================

    document.querySelectorAll('input[name="telefono"]').forEach(input => {

        input.addEventListener("input", () => {

            input.value = input.value.replace(/\D/g, "");

            if (input.value.length > 9) {
                input.value = input.value.slice(0, 9);
            }

        });

    });

    // =========================
    // VALIDACIÓN DE FORMULARIOS
    // =========================

    document.querySelectorAll("form").forEach(form => {

        form.addEventListener("submit", function (event) {

            const camposObligatorios = form.querySelectorAll("[required]");

            for (const campo of camposObligatorios) {

                if (!campo.value.trim()) {

                    event.preventDefault();
                    alert("Completa todos los campos obligatorios.");

                    campo.focus();

                    return;
                }

            }

            // VALIDAR TELÉFONO
            const telefono = form.querySelector('input[name="telefono"]');

            if (telefono && telefono.value.trim() !== "") {

                if (telefono.value.length !== 9) {

                    event.preventDefault();

                    alert("El teléfono debe tener 9 dígitos.");

                    telefono.focus();

                    return;
                }

            }

            // EVITAR DOBLE ENVÍO
            const boton = form.querySelector("button[type='submit']");

            if (
                    boton &&
                    !form.action.includes("LoginServlet")
                    ) {

                boton.disabled = true;
                boton.innerText = "Procesando...";

            }

        });

    });

    // =========================
    // COLORES POR PRIORIDAD
    // =========================

    document.querySelectorAll("table tr").forEach(fila => {

        const texto = fila.innerText.toUpperCase();

        if (texto.includes("CRITICA") || texto.includes("CRÍTICA")) {

            fila.style.backgroundColor = "#fee2e2";

        } else if (texto.includes("ALTA")) {

            fila.style.backgroundColor = "#fff7ed";

        } else if (texto.includes("MEDIA")) {

            fila.style.backgroundColor = "#fefce8";

        } else if (texto.includes("BAJA")) {

            fila.style.backgroundColor = "#ecfdf5";

        }

    });

});