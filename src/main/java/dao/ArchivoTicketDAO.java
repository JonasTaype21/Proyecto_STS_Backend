package dao;

import bean.ArchivoTicket;
import config.ConexionMYSQL;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ArchivoTicketDAO {

    public int registrar(
            ArchivoTicket archivo
    ) throws Exception {

        String sql =
                "INSERT INTO archivo_ticket ("
                + "id_ticket, "
                + "id_usuario, "
                + "nombre_archivo, "
                + "nombre_guardado, "
                + "tipo_archivo, "
                + "tamanio_bytes, "
                + "ruta_archivo"
                + ") VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (
                Connection cn = ConexionMYSQL.getConexion();
                PreparedStatement ps = cn.prepareStatement(
                        sql,
                        Statement.RETURN_GENERATED_KEYS
                )
        ) {

            ps.setInt(1, archivo.getIdTicket());
            ps.setInt(2, archivo.getIdUsuario());
            ps.setString(3, archivo.getNombreArchivo());
            ps.setString(4, archivo.getNombreGuardado());
            ps.setString(5, archivo.getTipoArchivo());
            ps.setLong(6, archivo.getTamanioBytes());
            ps.setString(7, archivo.getRutaArchivo());

            int filas = ps.executeUpdate();

            if (filas == 0) {
                throw new Exception(
                        "No se pudo registrar el archivo."
                );
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        throw new Exception(
                "El archivo se registró, pero no se obtuvo su ID."
        );
    }

    public List<ArchivoTicket> listarPorTicket(
            int idTicket
    ) throws Exception {

        List<ArchivoTicket> lista =
                new ArrayList<>();

        String sql =
                "SELECT "
                + "a.id_archivo, "
                + "a.id_ticket, "
                + "a.id_usuario, "
                + "a.nombre_archivo, "
                + "a.nombre_guardado, "
                + "a.tipo_archivo, "
                + "a.tamanio_bytes, "
                + "a.ruta_archivo, "
                + "a.fecha_subida, "
                + "CONCAT(u.nombres, ' ', u.apellidos) "
                + "AS nombre_usuario "
                + "FROM archivo_ticket a "
                + "INNER JOIN usuario u "
                + "ON a.id_usuario = u.id_usuario "
                + "WHERE a.id_ticket = ? "
                + "ORDER BY a.fecha_subida DESC, "
                + "a.id_archivo DESC";

        try (
                Connection cn = ConexionMYSQL.getConexion();
                PreparedStatement ps =
                        cn.prepareStatement(sql)
        ) {

            ps.setInt(1, idTicket);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    ArchivoTicket archivo =
                            new ArchivoTicket();

                    archivo.setIdArchivo(
                            rs.getInt("id_archivo")
                    );

                    archivo.setIdTicket(
                            rs.getInt("id_ticket")
                    );

                    archivo.setIdUsuario(
                            rs.getInt("id_usuario")
                    );

                    archivo.setNombreArchivo(
                            rs.getString("nombre_archivo")
                    );

                    archivo.setNombreGuardado(
                            rs.getString("nombre_guardado")
                    );

                    archivo.setTipoArchivo(
                            rs.getString("tipo_archivo")
                    );

                    archivo.setTamanioBytes(
                            rs.getLong("tamanio_bytes")
                    );

                    archivo.setRutaArchivo(
                            rs.getString("ruta_archivo")
                    );

                    archivo.setFechaSubida(
                            rs.getTimestamp("fecha_subida")
                    );

                    archivo.setNombreUsuario(
                            rs.getString("nombre_usuario")
                    );

                    lista.add(archivo);
                }
            }
        }

        return lista;
    }

    public ArchivoTicket buscarPorId(
            int idArchivo
    ) throws Exception {

        String sql =
                "SELECT "
                + "a.id_archivo, "
                + "a.id_ticket, "
                + "a.id_usuario, "
                + "a.nombre_archivo, "
                + "a.nombre_guardado, "
                + "a.tipo_archivo, "
                + "a.tamanio_bytes, "
                + "a.ruta_archivo, "
                + "a.fecha_subida, "
                + "CONCAT(u.nombres, ' ', u.apellidos) "
                + "AS nombre_usuario "
                + "FROM archivo_ticket a "
                + "INNER JOIN usuario u "
                + "ON a.id_usuario = u.id_usuario "
                + "WHERE a.id_archivo = ?";

        try (
                Connection cn = ConexionMYSQL.getConexion();
                PreparedStatement ps =
                        cn.prepareStatement(sql)
        ) {

            ps.setInt(1, idArchivo);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    ArchivoTicket archivo =
                            new ArchivoTicket();

                    archivo.setIdArchivo(
                            rs.getInt("id_archivo")
                    );

                    archivo.setIdTicket(
                            rs.getInt("id_ticket")
                    );

                    archivo.setIdUsuario(
                            rs.getInt("id_usuario")
                    );

                    archivo.setNombreArchivo(
                            rs.getString("nombre_archivo")
                    );

                    archivo.setNombreGuardado(
                            rs.getString("nombre_guardado")
                    );

                    archivo.setTipoArchivo(
                            rs.getString("tipo_archivo")
                    );

                    archivo.setTamanioBytes(
                            rs.getLong("tamanio_bytes")
                    );

                    archivo.setRutaArchivo(
                            rs.getString("ruta_archivo")
                    );

                    archivo.setFechaSubida(
                            rs.getTimestamp("fecha_subida")
                    );

                    archivo.setNombreUsuario(
                            rs.getString("nombre_usuario")
                    );

                    return archivo;
                }
            }
        }

        return null;
    }
}