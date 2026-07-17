package api.dto;

public class ArchivoTicketResponse {

    private int idArchivo;
    private int idTicket;
    private int idUsuario;

    private String nombreArchivo;
    private String tipoArchivo;
    private long tamanioBytes;
    private String tamanioLegible;

    private String nombreUsuario;
    private String fechaSubida;
    private String urlDescarga;

    public ArchivoTicketResponse() {
    }

    public ArchivoTicketResponse(
            int idArchivo,
            int idTicket,
            int idUsuario,
            String nombreArchivo,
            String tipoArchivo,
            long tamanioBytes,
            String tamanioLegible,
            String nombreUsuario,
            String fechaSubida,
            String urlDescarga
    ) {
        this.idArchivo = idArchivo;
        this.idTicket = idTicket;
        this.idUsuario = idUsuario;
        this.nombreArchivo = nombreArchivo;
        this.tipoArchivo = tipoArchivo;
        this.tamanioBytes = tamanioBytes;
        this.tamanioLegible = tamanioLegible;
        this.nombreUsuario = nombreUsuario;
        this.fechaSubida = fechaSubida;
        this.urlDescarga = urlDescarga;
    }

    public int getIdArchivo() {
        return idArchivo;
    }

    public void setIdArchivo(int idArchivo) {
        this.idArchivo = idArchivo;
    }

    public int getIdTicket() {
        return idTicket;
    }

    public void setIdTicket(int idTicket) {
        this.idTicket = idTicket;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getNombreArchivo() {
        return nombreArchivo;
    }

    public void setNombreArchivo(String nombreArchivo) {
        this.nombreArchivo = nombreArchivo;
    }

    public String getTipoArchivo() {
        return tipoArchivo;
    }

    public void setTipoArchivo(String tipoArchivo) {
        this.tipoArchivo = tipoArchivo;
    }

    public long getTamanioBytes() {
        return tamanioBytes;
    }

    public void setTamanioBytes(long tamanioBytes) {
        this.tamanioBytes = tamanioBytes;
    }

    public String getTamanioLegible() {
        return tamanioLegible;
    }

    public void setTamanioLegible(String tamanioLegible) {
        this.tamanioLegible = tamanioLegible;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getFechaSubida() {
        return fechaSubida;
    }

    public void setFechaSubida(String fechaSubida) {
        this.fechaSubida = fechaSubida;
    }

    public String getUrlDescarga() {
        return urlDescarga;
    }

    public void setUrlDescarga(String urlDescarga) {
        this.urlDescarga = urlDescarga;
    }
}