package api.dto;

public class ComentarioTicketResponse {

    private int idComentario;
    private int idTicket;
    private int idUsuario;

    private String nombreUsuario;
    private String comentario;
    private String fechaComentario;
    private String rol;

    public ComentarioTicketResponse(
            int idComentario,
            int idTicket,
            int idUsuario,
            String nombreUsuario,
            String rol,
            String comentario,
            String fechaComentario
    ) {
        this.idComentario = idComentario;
        this.idTicket = idTicket;
        this.idUsuario = idUsuario;
        this.nombreUsuario = nombreUsuario;
        this.rol = rol;
        this.comentario = comentario;
        this.fechaComentario = fechaComentario;
    }

    public int getIdComentario() {
        return idComentario;
    }

    public void setIdComentario(int idComentario) {
        this.idComentario = idComentario;
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

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getComentario() {
        return comentario;
    }

    public void setComentario(String comentario) {
        this.comentario = comentario;
    }

    public String getFechaComentario() {
        return fechaComentario;
    }

    public void setFechaComentario(String fechaComentario) {
        this.fechaComentario = fechaComentario;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }
}
