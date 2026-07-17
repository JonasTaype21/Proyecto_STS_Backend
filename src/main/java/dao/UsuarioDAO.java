package dao;

import bean.Usuario;
import config.ConexionMYSQL;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public Usuario validarLogin(String correo, String clave) throws Exception {

        Usuario usuario = null;

        String sql = "SELECT u.*, r.nombre_rol "
                + "FROM usuario u "
                + "INNER JOIN rol r ON u.id_rol = r.id_rol "
                + "WHERE u.correo = ? AND u.clave = ? AND u.estado = 1";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, correo);
            ps.setString(2, clave);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                usuario = mapearUsuario(rs);
            }
        }

        return usuario;
    }

    public List<Usuario> listar() throws Exception {

        List<Usuario> lista = new ArrayList<>();

        String sql = "SELECT u.*, r.nombre_rol "
                + "FROM usuario u "
                + "INNER JOIN rol r ON u.id_rol = r.id_rol "
                + "ORDER BY u.id_usuario DESC";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
        }

        return lista;
    }

    public List<Usuario> listarTecnicos() throws Exception {

        List<Usuario> lista = new ArrayList<>();

        String sql = "SELECT u.*, r.nombre_rol "
                + "FROM usuario u "
                + "INNER JOIN rol r ON u.id_rol = r.id_rol "
                + "WHERE r.nombre_rol = 'TECNICO' AND u.estado = 1 "
                + "ORDER BY u.nombres ASC";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapearUsuario(rs));
            }
        }

        return lista;
    }

    public void agregar(Usuario u) throws Exception {

        String sql = "INSERT INTO usuario "
                + "(id_rol, nombres, apellidos, correo, clave, telefono, area, especialidad, estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, u.getIdRol());
            ps.setString(2, u.getNombres());
            ps.setString(3, u.getApellidos());
            ps.setString(4, u.getCorreo());
            ps.setString(5, u.getClave());
            ps.setString(6, u.getTelefono());
            ps.setString(7, u.getArea());
            ps.setString(8, u.getEspecialidad());

            ps.executeUpdate();
        }
    }

    public Usuario obtener(int id) throws Exception {

        Usuario usuario = null;

        String sql = "SELECT u.*, r.nombre_rol "
                + "FROM usuario u "
                + "INNER JOIN rol r ON u.id_rol = r.id_rol "
                + "WHERE u.id_usuario = ?";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                usuario = mapearUsuario(rs);
            }
        }

        return usuario;
    }

    public void actualizar(Usuario u) throws Exception {

        String sql = "UPDATE usuario SET "
                + "id_rol = ?, nombres = ?, apellidos = ?, correo = ?, "
                + "telefono = ?, area = ?, especialidad = ?, estado = ? "
                + "WHERE id_usuario = ?";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, u.getIdRol());
            ps.setString(2, u.getNombres());
            ps.setString(3, u.getApellidos());
            ps.setString(4, u.getCorreo());
            ps.setString(5, u.getTelefono());
            ps.setString(6, u.getArea());
            ps.setString(7, u.getEspecialidad());
            ps.setInt(8, u.getEstado());
            ps.setInt(9, u.getIdUsuario());

            ps.executeUpdate();
        }
    }

    public void eliminarLogico(int id) throws Exception {

        String sql = "UPDATE usuario SET estado = 0 WHERE id_usuario = ?";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Usuario mapearUsuario(ResultSet rs) throws Exception {

        Usuario u = new Usuario();

        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setIdRol(rs.getInt("id_rol"));
        u.setNombreRol(rs.getString("nombre_rol"));
        u.setNombres(rs.getString("nombres"));
        u.setApellidos(rs.getString("apellidos"));
        u.setCorreo(rs.getString("correo"));
        u.setClave(rs.getString("clave"));
        u.setTelefono(rs.getString("telefono"));
        u.setArea(rs.getString("area"));
        u.setEspecialidad(rs.getString("especialidad"));
        u.setEstado(rs.getInt("estado"));

        return u;
    }
}