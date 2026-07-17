    document.addEventListener("DOMContentLoaded", () => {

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

            // VALIDAR TELÉFONO
            const telefono = form.querySelector('input[name="telefono"]');

            if (telefono && telefono.value.trim() !== "") {

                if (telefono.value.length !== 9) {

                    e.preventDefault();

                    alert("El teléfono debe tener 9 dígitos.");

                    telefono.focus();

                    return;
                }
            }

            // DESACTIVAR BOTÓN
            const boton = form.querySelector("button[type='submit']");

            if (!form.action.includes("LoginServlet")) {
                boton.disabled = true;
                boton.innerText = "Procesando...";
            }
        });
    });

    // =========================
    // COLORES POR ESTADO
    // =========================

    document.querySelectorAll("table tr").forEach(row => {

        const texto = row.innerText.toUpperCase();

        if (texto.includes("CRITICA")) {
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


