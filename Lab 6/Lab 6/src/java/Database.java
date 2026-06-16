/**
 *
 * @author Acer
 */
package lab6.com;

import java.sql.Connection;
import java.sql.DriverManager;

public class Database {

    public static Connection getConnection() {

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/CSA3203",
                    "root",
                    "admin"
            );
        } catch (Exception e) {

            e.printStackTrace();
        }
        return conn;
    }
    public static void closeConnection(Connection conn) {
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
