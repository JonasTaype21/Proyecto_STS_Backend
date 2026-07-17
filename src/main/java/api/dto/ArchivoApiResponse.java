package api.dto;

import java.util.ArrayList;
import java.util.List;

public class ArchivoApiResponse {

    private boolean exito;
    private String mensaje;
    private List<ArchivoTicketResponse> archivos;

    public ArchivoApiResponse() {
        this.archivos = new ArrayList<>();
    }

    public ArchivoApiResponse(
            boolean exito,
            String mensaje,
            List<ArchivoTicketResponse> archivos
    ) {
        this.exito = exito;
        this.mensaje = mensaje;
        this.archivos = archivos;
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

    public List<ArchivoTicketResponse> getArchivos() {
        return archivos;
    }

    public void setArchivos(
            List<ArchivoTicketResponse> archivos
    ) {
        this.archivos = archivos;
    }
}