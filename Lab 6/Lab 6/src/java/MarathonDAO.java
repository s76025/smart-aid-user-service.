/**
 *
 * @author Acer
 */
package lab6.com;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class MarathonDAO {

    public boolean addMarathon(Marathon m) {

        boolean status = false;

        Connection conn = null;
        PreparedStatement ps = null;

        try {

            conn = Database.getConnection();

            String sql
                    = "INSERT INTO marathon VALUES(?,?,?,?)";

            ps = conn.prepareStatement(sql);

            ps.setString(1, m.getParticipantID());
            ps.setString(2, m.getParticipantName());
            ps.setString(3, m.getCategory());
            ps.setString(4, m.getContactNo());

            ps.executeUpdate();

            status = true;

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            try {

                if (ps != null) {
                    ps.close();
                }

                Database.closeConnection(conn);

            } catch (Exception e) {

                e.printStackTrace();
            }
        }

        return status;
    }
}

