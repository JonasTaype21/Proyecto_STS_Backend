package api.dto;

import java.util.ArrayList;
import java.util.List;

public class ComentarioApiResponse {

    private boolean exito;
    private String mensaje;
    private List<ComentarioTicketResponse> comentarios;

    public ComentarioApiResponse() {
        this.comentarios = new ArrayList<>();
    }

    public ComentarioApiResponse(
            boolean exito,
            String mensaje,
            List<ComentarioTicketResponse> comentarios
    ) {
        this.exito = exito;
        this.mensaje = mensaje;
        this.comentarios = comentarios;
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

    public List<ComentarioTicketResponse> getComentarios() {
        return comentarios;
    }

    public void setComentarios(
            List<ComentarioTicketResponse> comentarios
    ) {
        this.comentarios = comentarios;
    }
}