package api.dto;

import bean.HistorialTicket;
import bean.SolucionTicket;
import bean.Ticket;
import java.util.List;

public class SeguimientoTicketResponse {

    private boolean exito;
    private String mensaje;
    private Ticket ticket;
    private List<HistorialTicket> historial;
    private SolucionTicket solucion;

    public SeguimientoTicketResponse() {
    }

    public SeguimientoTicketResponse(
            boolean exito,
            String mensaje,
            Ticket ticket,
            List<HistorialTicket> historial,
            SolucionTicket solucion
    ) {
        this.exito = exito;
        this.mensaje = mensaje;
        this.ticket = ticket;
        this.historial = historial;
        this.solucion = solucion;
    }

    public boolean isExito() {
        return exito;
    }

    public void setExito(boolean exito) {
        this.exito = exito;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    public List<HistorialTicket> getHistorial() {
        return historial;
    }

    public void setHistorial(List<HistorialTicket> historial) {
        this.historial = historial;
    }

    public SolucionTicket getSolucion() {
        return solucion;
    }

    public void setSolucion(SolucionTicket solucion) {
        this.solucion = solucion;
    }
}