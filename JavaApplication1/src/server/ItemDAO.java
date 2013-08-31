/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package server;
import data.Item;
import server.MySQLDatabase_char;
import java.sql.*;
import java.util.ArrayList;

/**
 *
 * @author xavier
 */


public class ItemDAO {
     /*public static ArrayList<Item> getDonorItemById(int entry) throws SQLException {
        ArrayList<Item> donors = new ArrayList<>();
        String sql = "SELECT * FROM item_template where entry=?";
        Connection con = MySQLDatabase_char.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, Integer.toString(entry));
        ResultSet res = ps.executeQuery();

        while (res.next()) {
            String datum = res.getString(1);
            
            Trekking tr = new Trekking(datum, nummers, bNr);
            trekkingen.add(tr);
        }
        con.close();
        return trekkingen;
    }*/
}
