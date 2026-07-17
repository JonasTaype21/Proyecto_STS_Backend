document.addEventListener("DOMContentLoaded", () => {

    // =========================
    // MENÚ LATERAL RESPONSIVE
    // =========================

    const menuToggle = document.getElementById("menuToggle");
    const sidebar = document.querySelector(".sidebar");
    const sidebarOverlay = document.getElementById("sidebarOverlay");

    const puedeUsarMenu = menuToggle && sidebar && sidebarOverlay;

    function abrirMenu() {

        if (!puedeUsarMenu) return;

        sidebar.classList.add("sidebar-open");
        sidebarOverlay.classList.add("overlay-active");
        menuToggle.setAttribute("aria-expanded", "true");
        document.body.classList.add("menu-open");

    }

    function cerrarMenu() {

        if (!puedeUsarMenu) return;

        sidebar.classList.remove("sidebar-open");
        sidebarOverlay.classList.remove("overlay-active");
        menuToggle.setAttribute("aria-expanded", "false");
        document.body.classList.remove("menu-open");

    }

    if (puedeUsarMenu) {

        menuToggle.addEventListener("click", () => {

            if (sidebar.classList.contains("sidebar-open")) {
                cerrarMenu();
            } else {
                abrirMenu();
            }

        });

        sidebarOverlay.addEventListener("click", cerrarMenu);

        sidebar.querySelectorAll(".menu-item").forEach(item => {

            item.addEventListener("click", () => {

                if (window.innerWidth <= 900) {
                    cerrarMenu();
                }

            });

        });

    }

    document.addEventListener("keydown", (e) => {

        if (e.key === "Escape") {
            cerrarMenu();
        }

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

            input.value = input.value.replace(/\D/g, "").slice(0, 9);

        });

    });

    // =========================
    // VALIDACIÓN FORMULARIOS
    // =========================

    document.querySelectorAll("form").forEach(form => {

        form.addEventListener("submit", function (e) {

            const requireds = form.querySelectorAll("[required]");

            for (const campo of requireds) {

                if (!campo.value.trim()) {

                    e.preventDefault();
                    alert("Completa todos los campos obligatorios.");
                    campo.focus();
                    return;

                }

            }

            const telefono = form.querySelector('input[name="telefono"]');

            if (telefono && telefono.value.trim() !== "") {

                if (telefono.value.length !== 9) {

                    e.preventDefault();
                    alert("El teléfono debe tener 9 dígitos.");
                    telefono.focus();
                    return;

                }

            }

            const boton = form.querySelector("button[type='submit']");

            if (boton && !form.action.includes("LoginServlet")) {

                boton.disabled = true;
                boton.innerText = "Procesando...";

            }

        });

    });

    // =========================
    // COLORES SEGÚN PRIORIDAD
    // =========================

    document.querySelectorAll("table tr").forEach(row => {

        const texto = row.innerText.toUpperCase();

        if (texto.includes("CRÍTICA") || texto.includes("CRITICA")) {

            row.style.backgroundColor = "#fee2e2";

        } else if (texto.includes("ALTA")) {

            row.style.backgroundColor = "#fff7ed";

        } else if (texto.includes("MEDIA")) {

            row.style.backgroundColor = "#fefce8";

        } else if (texto.includes("BAJA")) {

            row.style.backgroundColor = "#ecfdf5";

        }

    });

});