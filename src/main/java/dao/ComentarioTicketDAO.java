package dao;

import bean.ComentarioTicket;
import config.ConexionMYSQL;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ComentarioTicketDAO {

    public int registrar(ComentarioTicket comentario) throws Exception {

        String sql =
                "INSERT INTO comentario_ticket "
                + "(id_ticket, id_usuario, comentario) "
                + "VALUES (?, ?, ?)";

        try (
                Connection cn = ConexionMYSQL.getConexion();
                PreparedStatement ps = cn.prepareStatement(
                        sql,
                        Statement.RETURN_GENERATED_KEYS
                )
        ) {

            ps.setInt(1, comentario.getIdTicket());
            ps.setInt(2, comentario.getIdUsuario());
            ps.setString(3, comentario.getComentario());

            int filasAfectadas = ps.executeUpdate();

            if (filasAfectadas == 0) {
                throw new Exception(
                        "No se pudo registrar el comentario."
                );
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        throw new Exception(
                "El comentario se registró, pero no se obtuvo su ID."
        );
    }

    public List<ComentarioTicket> listarPorTicket(
            int idTicket
    ) throws Exception {

        List<ComentarioTicket> lista = new ArrayList<>();

        String sql
                = "SELECT "
                + "c.id_comentario, "
                + "c.id_ticket, "
                + "c.id_usuario, "
                + "c.comentario, "
                + "c.fecha_comentario, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS nombre_usuario, "
                + "r.nombre_rol AS rol "
                + "FROM comentario_ticket c "
                + "INNER JOIN usuario u "
                + "ON c.id_usuario = u.id_usuario "
                + "INNER JOIN rol r "
                + "ON u.id_rol = r.id_rol "
                + "WHERE c.id_ticket = ? "
                + "ORDER BY c.fecha_comentario ASC, "
                + "c.id_comentario ASC";

        try (
                Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    ComentarioTicket comentario
                            = new ComentarioTicket();

                    comentario.setIdComentario(
                            rs.getInt("id_comentario")
                    );

                    comentario.setIdTicket(
                            rs.getInt("id_ticket")
                    );

                    comentario.setIdUsuario(
                            rs.getInt("id_usuario")
                    );

                    comentario.setNombreUsuario(
                            rs.getString("nombre_usuario")
                    );
                    comentario.setRol(
                            rs.getString("rol")
                    );

                    comentario.setComentario(
                            rs.getString("comentario")
                    );

                    comentario.setFechaComentario(
                            rs.getTimestamp("fecha_comentario")
                    );

                    lista.add(comentario);
                }
            }
        }

        return lista;
    }

    public ComentarioTicket buscarPorId(
            int idComentario
    ) throws Exception {

        String sql
                = "SELECT "
                + "c.id_comentario, "
                + "c.id_ticket, "
                + "c.id_usuario, "
                + "c.comentario, "
                + "c.fecha_comentario, "
                + "CONCAT(u.nombres, ' ', u.apellidos) AS nombre_usuario, "
                + "r.nombre_rol AS rol "
                + "FROM comentario_ticket c "
                + "INNER JOIN usuario u "
                + "ON c.id_usuario = u.id_usuario "
                + "INNER JOIN rol r "
                + "ON u.id_rol = r.id_rol "
                + "WHERE c.id_comentario = ?";

        try (
                Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idComentario);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    ComentarioTicket comentario
                            = new ComentarioTicket();

                    comentario.setIdComentario(
                            rs.getInt("id_comentario")
                    );

                    comentario.setIdTicket(
                            rs.getInt("id_ticket")
                    );

                    comentario.setIdUsuario(
                            rs.getInt("id_usuario")
                    );

                    comentario.setNombreUsuario(
                            rs.getString("nombre_usuario")
                    );
                    comentario.setRol(
                            rs.getString("rol")
                    );

                    comentario.setComentario(
                            rs.getString("comentario")
                    );

                    comentario.setFechaComentario(
                            rs.getTimestamp("fecha_comentario")
                    );

                    return comentario;
                }
            }
        }

        return null;
    }

    public int contarComentariosPorTicket(int idTicket) {

        int cantidad = 0;

        String sql
                = "SELECT COUNT(*) FROM comentario_ticket WHERE id_ticket = ?";

        try (
                Connection cn = ConexionMYSQL.getConexion(); PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                cantidad = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return cantidad;
    }
}
