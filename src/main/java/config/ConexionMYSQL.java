package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionMYSQL {

    private static final String URL = "jdbc:mysql://localhost:3306/TicketsSoporte"
        + "?useUnicode=true"
        + "&characterEncoding=UTF-8"
        + "&connectionCollation=utf8mb4_unicode_ci"
        + "&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    public static Connection getConexion() {
        Connection cn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            cn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            System.out.println("Error de conexión: " + e.getMessage());
        }

        return cn;
    }
}