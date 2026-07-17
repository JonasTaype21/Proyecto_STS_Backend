package dao;

import bean.Ticket;
import config.ConexionMYSQL;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO {

    public void registrar(Ticket t) throws Exception {

        String sql = "INSERT INTO ticket "
                + "(codigo_ticket, id_usuario, id_categoria, titulo, descripcion, prioridad, estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'ABIERTO')";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, t.getCodigoTicket());
            ps.setInt(2, t.getIdUsuario());
            ps.setInt(3, t.getIdCategoria());
            ps.setString(4, t.getTitulo());
            ps.setString(5, t.getDescripcion());
            ps.setString(6, t.getPrioridad());

            ps.executeUpdate();
        }
    }

    public List<Ticket> listarTodos() throws Exception {

        List<Ticket> lista = new ArrayList<>();

        String sql
                = "SELECT t.*, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS usuario_reporta, "
                + "u.area AS area_usuario, "
                + "CONCAT(te.nombres, ' ', te.apellidos) AS tecnico_asignado, "
                + "c.nombre_categoria "
                + "FROM ticket t "
                + "INNER JOIN usuario u ON t.id_usuario = u.id_usuario "
                + "LEFT JOIN usuario te ON t.id_tecnico = te.id_usuario "
                + "INNER JOIN categoria c ON t.id_categoria = c.id_categoria "
                + "ORDER BY t.id_ticket ASC";
        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearTicket(rs));
            }
        }

        return lista;
    }

    public List<Ticket> listarPorUsuario(int idUsuario) throws Exception {

        List<Ticket> lista = new ArrayList<>();

        String sql
                = "SELECT t.*, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS usuario_reporta, "
                + "u.area AS area_usuario, "
                + "CONCAT(te.nombres, ' ', te.apellidos) AS tecnico_asignado, "
                + "c.nombre_categoria "
                + "FROM ticket t "
                + "INNER JOIN usuario u ON t.id_usuario = u.id_usuario "
                + "LEFT JOIN usuario te ON t.id_tecnico = te.id_usuario "
                + "INNER JOIN categoria c ON t.id_categoria = c.id_categoria "
                + "WHERE t.id_usuario = ? "
                + "ORDER BY t.id_ticket ASC";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearTicket(rs));
                }
            }
        }

        return lista;
    }

    public List<Ticket> listarPorTecnico(int idTecnico) throws Exception {

        List<Ticket> lista = new ArrayList<>();

        String sql
                = "SELECT t.*, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS usuario_reporta, "
                + "u.area AS area_usuario, "
                + "CONCAT(te.nombres, ' ', te.apellidos) AS tecnico_asignado, "
                + "c.nombre_categoria "
                + "FROM ticket t "
                + "INNER JOIN usuario u ON t.id_usuario = u.id_usuario "
                + "LEFT JOIN usuario te ON t.id_tecnico = te.id_usuario "
                + "INNER JOIN categoria c ON t.id_categoria = c.id_categoria "
                + "WHERE t.id_tecnico = ? "
                + "ORDER BY t.id_ticket ASC";
        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTecnico);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearTicket(rs));
                }
            }
        }

        return lista;
    }

    public Ticket obtener(int idTicket) throws Exception {

        Ticket ticket = null;

        String sql
                = "SELECT t.*, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS usuario_reporta, "
                + "u.area AS area_usuario, "
                + "CONCAT(te.nombres, ' ', te.apellidos) AS tecnico_asignado, "
                + "c.nombre_categoria "
                + "FROM ticket t "
                + "INNER JOIN usuario u ON t.id_usuario = u.id_usuario "
                + "LEFT JOIN usuario te ON t.id_tecnico = te.id_usuario "
                + "INNER JOIN categoria c ON t.id_categoria = c.id_categoria "
                + "WHERE t.id_ticket = ?";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ticket = mapearTicket(rs);
                }
            }
        }

        return ticket;
    }

    public void asignarTecnico(int idTicket, int idTecnico) throws Exception {

        String sql = "UPDATE ticket SET "
                + "id_tecnico = ?, "
                + "estado = 'ASIGNADO', "
                + "fecha_asignacion = NOW() "
                + "WHERE id_ticket = ? "
                + "AND estado IN ('ABIERTO','REABIERTO')";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTecnico);
            ps.setInt(2, idTicket);

            ps.executeUpdate();
        }
    }

    public void iniciarAtencion(int idTicket, int idTecnico) throws Exception {

        String sql = "UPDATE ticket SET "
                + "estado = 'EN_PROCESO', "
                + "fecha_inicio_atencion = NOW() "
                + "WHERE id_ticket = ? "
                + "AND id_tecnico = ? "
                + "AND estado = 'ASIGNADO'";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);
            ps.setInt(2, idTecnico);

            ps.executeUpdate();
        }
    }

    public void marcarResuelto(int idTicket, int idTecnico) throws Exception {

        String sql = "UPDATE ticket SET "
                + "estado = 'RESUELTO', "
                + "fecha_resolucion = NOW() "
                + "WHERE id_ticket = ? "
                + "AND id_tecnico = ? "
                + "AND estado = 'EN_PROCESO'";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);
            ps.setInt(2, idTecnico);

            ps.executeUpdate();
        }
    }

    public void cerrarTicket(int idTicket) throws Exception {

        String sql = "UPDATE ticket SET "
                + "estado = 'CERRADO', "
                + "fecha_cierre = NOW() "
                + "WHERE id_ticket = ? "
                + "AND estado = 'RESUELTO'";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);

            ps.executeUpdate();
        }
    }

    public void reabrirTicket(int idTicket) throws Exception {

        String sql = "UPDATE ticket SET "
                + "estado = 'REABIERTO', "
                + "fecha_cierre = NULL "
                + "WHERE id_ticket = ? "
                + "AND estado IN ('RESUELTO','CERRADO')";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);

            ps.executeUpdate();
        }
    }

    public Ticket obtenerPorCodigo(String codigoTicket) throws Exception {

        Ticket ticket = null;

        String sql
                = "SELECT t.*, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS usuario_reporta, "
                + "u.area AS area_usuario, "
                + "CONCAT(te.nombres, ' ', te.apellidos) AS tecnico_asignado, "
                + "c.nombre_categoria "
                + "FROM ticket t "
                + "INNER JOIN usuario u ON t.id_usuario = u.id_usuario "
                + "LEFT JOIN usuario te ON t.id_tecnico = te.id_usuario "
                + "INNER JOIN categoria c ON t.id_categoria = c.id_categoria "
                + "WHERE t.codigo_ticket = ?";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, codigoTicket);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ticket = mapearTicket(rs);
                }
            }
        }

        return ticket;
    }

    public String generarCodigoTicket() throws Exception {

        String codigo = "TK-0001";

        String sql = "SELECT MAX(id_ticket) AS ultimo FROM ticket";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int ultimo = rs.getInt("ultimo") + 1;
                codigo = String.format("TK-%04d", ultimo);
            }
        }

        return codigo;
    }

    private Ticket mapearTicket(ResultSet rs) throws Exception {

        Ticket t = new Ticket();

        t.setIdTicket(rs.getInt("id_ticket"));
        t.setCodigoTicket(rs.getString("codigo_ticket"));
        t.setIdUsuario(rs.getInt("id_usuario"));
        t.setIdTecnico(rs.getInt("id_tecnico"));
        t.setIdCategoria(rs.getInt("id_categoria"));

        t.setUsuarioReporta(rs.getString("usuario_reporta"));
        t.setAreaUsuario(rs.getString("area_usuario"));
        t.setTecnicoAsignado(rs.getString("tecnico_asignado"));
        t.setNombreCategoria(rs.getString("nombre_categoria"));

        t.setTitulo(rs.getString("titulo"));
        t.setDescripcion(rs.getString("descripcion"));
        t.setPrioridad(rs.getString("prioridad"));
        t.setEstado(rs.getString("estado"));

        t.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
        t.setFechaAsignacion(rs.getTimestamp("fecha_asignacion"));
        t.setFechaInicioAtencion(rs.getTimestamp("fecha_inicio_atencion"));
        t.setFechaResolucion(rs.getTimestamp("fecha_resolucion"));
        t.setFechaCierre(rs.getTimestamp("fecha_cierre"));

        return t;
    }
}
