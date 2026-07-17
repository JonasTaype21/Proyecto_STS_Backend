package config;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConexionMYSQL {

    public static Connection getConexion() {

        try {

            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String db = System.getenv("MYSQLDATABASE");
            String user = System.getenv("MYSQLUSER");
            String pass = System.getenv("MYSQLPASSWORD");

            String url = "jdbc:mysql://" + host + ":" + port + "/" + db
                    + "?useUnicode=true"
                    + "&characterEncoding=UTF-8"
                    + "&serverTimezone=UTC"
                    + "&useSSL=false";

            Class.forName("com.mysql.cj.jdbc.Driver");

            return DriverManager.getConnection(url, user, pass);

        } catch (Exception e) {
            throw new RuntimeException("Error conectando a MySQL", e);
        }

    }

}