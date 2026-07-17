package dao;

import bean.SolucionTicket;
import config.ConexionMYSQL;
import java.sql.*;

public class SolucionTicketDAO {

    public void registrar(SolucionTicket s) throws Exception {

        String sql = "INSERT INTO solucion_ticket "
                + "(id_ticket, id_tecnico, diagnostico, solucion_aplicada, observaciones) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, s.getIdTicket());
            ps.setInt(2, s.getIdTecnico());
            ps.setString(3, s.getDiagnostico());
            ps.setString(4, s.getSolucionAplicada());
            ps.setString(5, s.getObservaciones());

            ps.executeUpdate();
        }
    }

    public SolucionTicket obtenerPorTicket(int idTicket) throws Exception {

        SolucionTicket s = null;

        String sql = "SELECT s.*, CONCAT(u.nombres, ' ', u.apellidos) AS nombre_tecnico "
                + "FROM solucion_ticket s "
                + "INNER JOIN usuario u ON s.id_tecnico = u.id_usuario "
                + "WHERE s.id_ticket = ?";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, idTicket);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    s = new SolucionTicket();

                    s.setIdSolucion(rs.getInt("id_solucion"));
                    s.setIdTicket(rs.getInt("id_ticket"));
                    s.setIdTecnico(rs.getInt("id_tecnico"));
                    s.setNombreTecnico(rs.getString("nombre_tecnico"));
                    s.setDiagnostico(rs.getString("diagnostico"));
                    s.setSolucionAplicada(rs.getString("solucion_aplicada"));
                    s.setObservaciones(rs.getString("observaciones"));
                    s.setFechaSolucion(rs.getTimestamp("fecha_solucion"));
                }
            }
        }

        return s;
    }
}