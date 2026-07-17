package servlet;

import api.dto.SeguimientoTicketResponse;
import bean.HistorialTicket;
import bean.SolucionTicket;
import bean.Ticket;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import dao.HistorialTicketDAO;
import dao.SolucionTicketDAO;
import dao.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "SeguimientoApiServlet", urlPatterns = {"/api/seguimiento"})
public class SeguimientoApiServlet extends HttpServlet {

    private TicketDAO ticketDAO;
    private HistorialTicketDAO historialDAO;
    private SolucionTicketDAO solucionDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
        historialDAO = new HistorialTicketDAO();
        solucionDAO = new SolucionTicketDAO();

        gson = new GsonBuilder()
                .setDateFormat("dd/MM/yyyy HH:mm")
                .serializeNulls()
                .create();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        configurarRespuesta(response);

        String parametroId = request.getParameter("idTicket");

        if (parametroId == null || parametroId.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

            escribirJson(
                    response,
                    new SeguimientoTicketResponse(
                            false,
                            "Debe enviar el parámetro idTicket.",
                            null,
                            Collections.emptyList(),
                            null
                    )
            );
            return;
        }

        final int idTicket;

        try {
            idTicket = Integer.parseInt(parametroId);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);

            escribirJson(
                    response,
                    new SeguimientoTicketResponse(
                            false,
                            "El idTicket debe ser un número válido.",
                            null,
                            Collections.emptyList(),
                            null
                    )
            );
            return;
        }

        try {
            Ticket ticket = ticketDAO.obtener(idTicket);

            if (ticket == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);

                escribirJson(
                        response,
                        new SeguimientoTicketResponse(
                                false,
                                "No se encontró el ticket solicitado.",
                                null,
                                Collections.emptyList(),
                                null
                        )
                );
                return;
            }

            List<HistorialTicket> historial =
                    historialDAO.listarPorTicket(idTicket);

            SolucionTicket solucion =
                    solucionDAO.obtenerPorTicket(idTicket);

            SeguimientoTicketResponse resultado =
                    new SeguimientoTicketResponse(
                            true,
                            "Seguimiento obtenido correctamente.",
                            ticket,
                            historial,
                            solucion
                    );

            response.setStatus(HttpServletResponse.SC_OK);
            escribirJson(response, resultado);

        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );

            escribirJson(
                    response,
                    new SeguimientoTicketResponse(
                            false,
                            "Ocurrió un error al consultar el seguimiento.",
                            null,
                            Collections.emptyList(),
                            null
                    )
            );
        }
    }

    private void configurarRespuesta(HttpServletResponse response) {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        /*
         * Temporal durante el desarrollo:
         * Angular está en localhost:4200.
         */
        response.setHeader(
                "Access-Control-Allow-Origin",
                "https://sts-angular.onrender.com"
        );

        response.setHeader(
                "Access-Control-Allow-Methods",
                "GET, OPTIONS"
        );

        response.setHeader(
                "Access-Control-Allow-Headers",
                "Content-Type"
        );
    }

    private void escribirJson(
            HttpServletResponse response,
            Object objeto
    ) throws IOException {

        response.getWriter().write(gson.toJson(objeto));
    }
}