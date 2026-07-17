package dao;

import config.ConexionMYSQL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReporteDAO {

    public List<Map<String, Object>> reporteTiempos() throws Exception {

        List<Map<String, Object>> lista = new ArrayList<>();

        String sql = "SELECT * FROM vista_reporte_tickets ORDER BY id_ticket DESC";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> fila = new HashMap<>();

                fila.put("codigo_ticket", rs.getString("codigo_ticket"));
                fila.put("titulo", rs.getString("titulo"));
                fila.put("prioridad", rs.getString("prioridad"));
                fila.put("estado", rs.getString("estado"));
                fila.put("nombre_categoria", rs.getString("nombre_categoria"));
                fila.put("usuario_reporta", rs.getString("usuario_reporta"));
                fila.put("tecnico_asignado", rs.getString("tecnico_asignado"));
                fila.put("fecha_creacion", rs.getTimestamp("fecha_creacion"));
                fila.put("fecha_inicio_atencion", rs.getTimestamp("fecha_inicio_atencion"));
                fila.put("fecha_resolucion", rs.getTimestamp("fecha_resolucion"));
                fila.put("fecha_cierre", rs.getTimestamp("fecha_cierre"));
                fila.put("minutos_respuesta", rs.getObject("minutos_respuesta"));
                fila.put("minutos_resolucion", rs.getObject("minutos_resolucion"));
                fila.put("minutos_total", rs.getObject("minutos_total"));

                lista.add(fila);
            }
        }

        return lista;
    }
}