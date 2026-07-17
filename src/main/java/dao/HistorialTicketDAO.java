package dao;

import bean.HistorialTicket;
import config.ConexionMYSQL;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistorialTicketDAO {

    public void registrar(HistorialTicket h) throws Exception {

        String sql = "INSERT INTO historial_ticket "
                + "(id_ticket, id_usuario, estado_anterior, estado_nuevo, accion, comentario) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, h.getIdTicket());
            ps.setInt(2, h.getIdUsuario());
            ps.setString(3, h.getEstadoAnterior());
            ps.setString(4, h.getEstadoNuevo());
            ps.setString(5, h.getAccion());
            ps.setString(6, h.getComentario());

            ps.executeUpdate();
        }
    }

    public List<HistorialTicket> listarPorTicket(int idTicket) throws Exception {

        List<HistorialTicket> lista = new ArrayList<>();

        String sql = "SELECT h.*, CONCAT(u.nombres, ' ', u.apellidos) AS nombre_usuario "
                + "FROM historial_ticket h "
                + "INNER JOIN usuario u ON h.id_usuario = u.id_usuario "
                + "WHERE h.id_ticket = ? "
                + "ORDER BY h.fecha_accion ASC";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistorialTicket h = new HistorialTicket();

                    h.setIdHistorial(rs.getInt("id_historial"));
                    h.setIdTicket(rs.getInt("id_ticket"));
                    h.setIdUsuario(rs.getInt("id_usuario"));
                    h.setNombreUsuario(rs.getString("nombre_usuario"));
                    h.setEstadoAnterior(rs.getString("estado_anterior"));
                    h.setEstadoNuevo(rs.getString("estado_nuevo"));
                    h.setAccion(rs.getString("accion"));
                    h.setComentario(rs.getString("comentario"));
                    h.setFechaAccion(rs.getTimestamp("fecha_accion"));

                    lista.add(h);
                }
            }
        }

        return lista;
    }

    public List<HistorialTicket> listarResumenPorTicket() throws Exception {

        List<HistorialTicket> lista = new ArrayList<>();

        String sql = "SELECT "
                + "t.id_ticket, "
                + "t.codigo_ticket, "
                + "t.prioridad, "
                + "c.nombre_categoria, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS nombre_usuario, "
                + "CONCAT(te.nombres, ' ', te.apellidos) AS tecnico_asignado, "
                + "t.estado AS estado_nuevo, "
                + "MAX(CASE WHEN h.accion = 'Ticket registrado' THEN h.fecha_accion END) AS fecha_creacion, "
                + "MAX(CASE WHEN h.accion = 'Técnico asignado' THEN h.fecha_accion END) AS fecha_asignacion, "
                + "MAX(CASE WHEN h.accion = 'Atención iniciada' THEN h.fecha_accion END) AS fecha_inicio, "
                + "MAX(CASE WHEN h.accion = 'Solución registrada' THEN h.fecha_accion END) AS fecha_solucion, "
                + "MAX(CASE WHEN h.accion = 'Ticket cerrado' THEN h.fecha_accion END) AS fecha_cierre "
                + "FROM ticket t "
                + "INNER JOIN usuario u ON t.id_usuario = u.id_usuario "
                + "INNER JOIN categoria c ON t.id_categoria = c.id_categoria "
                + "LEFT JOIN usuario te ON t.id_tecnico = te.id_usuario "
                + "LEFT JOIN historial_ticket h ON t.id_ticket = h.id_ticket "
                + "GROUP BY t.id_ticket, t.codigo_ticket, t.prioridad, c.nombre_categoria, "
                + "u.nombres, u.apellidos, te.nombres, te.apellidos, t.estado "
                + "ORDER BY t.id_ticket DESC";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                HistorialTicket h = new HistorialTicket();

                h.setIdTicket(rs.getInt("id_ticket"));
                h.setCodigoTicket(rs.getString("codigo_ticket"));
                h.setPrioridad(rs.getString("prioridad"));
                h.setCategoria(rs.getString("nombre_categoria"));
                h.setNombreUsuario(rs.getString("nombre_usuario"));
                h.setTecnicoAsignado(rs.getString("tecnico_asignado"));
                h.setEstadoNuevo(rs.getString("estado_nuevo"));

                h.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                h.setFechaAsignacion(rs.getTimestamp("fecha_asignacion"));
                h.setFechaInicio(rs.getTimestamp("fecha_inicio"));
                h.setFechaSolucion(rs.getTimestamp("fecha_solucion"));
                h.setFechaCierre(rs.getTimestamp("fecha_cierre"));

                lista.add(h);
            }
        }

        return lista;
    }

    

    public List<HistorialTicket> listarResumenPorUsuario(int idUsuario) throws Exception {

        List<HistorialTicket> lista = new ArrayList<>();

        String sql = "SELECT "
                + "t.id_ticket, "
                + "t.codigo_ticket, "
                + "c.nombre_categoria, "
                + "t.prioridad, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS nombre_usuario, "
                + "CONCAT(te.nombres, ' ', te.apellidos) AS tecnico_asignado, "
                + "t.estado AS estado_actual, "
                + "MAX(CASE WHEN h.accion = 'Ticket registrado' THEN h.fecha_accion END) AS fecha_creacion, "
                + "MAX(CASE WHEN h.accion = 'Técnico asignado' THEN h.fecha_accion END) AS fecha_asignacion, "
                + "MAX(CASE WHEN h.accion = 'Atención iniciada' THEN h.fecha_accion END) AS fecha_inicio, "
                + "MAX(CASE WHEN h.accion = 'Solución registrada' THEN h.fecha_accion END) AS fecha_solucion, "
                + "MAX(CASE WHEN h.accion = 'Ticket cerrado' THEN h.fecha_accion END) AS fecha_cierre "
                + "FROM ticket t "
                + "INNER JOIN usuario u ON t.id_usuario = u.id_usuario "
                + "INNER JOIN categoria c ON t.id_categoria = c.id_categoria "
                + "LEFT JOIN usuario te ON t.id_tecnico = te.id_usuario "
                + "LEFT JOIN historial_ticket h ON t.id_ticket = h.id_ticket "
                + "WHERE t.id_usuario = ? "
                + "GROUP BY t.id_ticket, t.codigo_ticket, c.nombre_categoria, t.prioridad, "
                + "u.nombres, u.apellidos, te.nombres, te.apellidos, t.estado "
                + "ORDER BY t.id_ticket DESC";

        try (Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    HistorialTicket h = new HistorialTicket();

                    h.setIdTicket(rs.getInt("id_ticket"));
                    h.setCodigoTicket(rs.getString("codigo_ticket"));
                    h.setCategoria(rs.getString("nombre_categoria"));
                    h.setPrioridad(rs.getString("prioridad"));
                    h.setNombreUsuario(rs.getString("nombre_usuario"));
                    h.setTecnicoAsignado(rs.getString("tecnico_asignado"));
                    h.setEstadoActual(rs.getString("estado_actual"));

                    h.setFechaCreacion(rs.getTimestamp("fecha_creacion"));
                    h.setFechaAsignacion(rs.getTimestamp("fecha_asignacion"));
                    h.setFechaInicio(rs.getTimestamp("fecha_inicio"));
                    h.setFechaSolucion(rs.getTimestamp("fecha_solucion"));
                    h.setFechaCierre(rs.getTimestamp("fecha_cierre"));

                    lista.add(h);
                }
            }
        }

        return lista;
    }
}
