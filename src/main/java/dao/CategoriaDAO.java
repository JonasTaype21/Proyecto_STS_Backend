package dao;

import bean.Categoria;
import config.ConexionMYSQL;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoriaDAO {

    public List<Categoria> listarActivas() throws Exception {

        List<Categoria> lista = new ArrayList<>();

        String sql = "SELECT * FROM categoria WHERE estado = 1 ORDER BY nombre_categoria ASC";

        try (Connection cn = ConexionMYSQL.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categoria c = new Categoria();

                c.setIdCategoria(rs.getInt("id_categoria"));
                c.setNombreCategoria(rs.getString("nombre_categoria"));
                c.setDescripcion(rs.getString("descripcion"));
                c.setEstado(rs.getInt("estado"));

                lista.add(c);
            }
        }

        return lista;
    }
}