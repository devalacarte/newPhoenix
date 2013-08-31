/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package server;

import data.PVEReport;
import server.MySQLDatabase_char;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author xavier
 */
public class PVEReportDAO {
    public static ArrayList<PVEReport> getReports() throws SQLException {
        ArrayList<PVEReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM pve_reports ORDER BY KillerAccount, KillerGuid, ItemEntry ASC";
        Connection con = MySQLDatabase_char.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet res = ps.executeQuery();

        while (res.next()) {
            PVEReport rep = new PVEReport(res.getString(1),res.getInt(2),res.getInt(3),res.getInt(4),res.getInt(5),res.getString(6),res.getInt(7),res.getInt(8),res.getInt(9),res.getInt(10));
            reports.add(rep);
        }
        con.close();
        return reports;
    }
    
    
    
    
    public static ArrayList<PVEReport> getReportsByKillerAccountId(int accountId) throws SQLException {
        ArrayList<PVEReport> reports = new ArrayList<>();
        String sql = "SELECT * FROM pve_reports WHERE KillerAccount=? ORDER BY KillerAccount, KillerGuid, ItemEntry ASC";
        Connection con = MySQLDatabase_char.getInstance().getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, Integer.toString(accountId));
        ResultSet res = ps.executeQuery();
        
        while (res.next()) {
            PVEReport rep = new PVEReport(res.getString(1),res.getInt(2),res.getInt(3),res.getInt(4),res.getInt(5),res.getString(6),res.getInt(7),res.getInt(8),res.getInt(9),res.getInt(10));
            reports.add(rep);
        }
        con.close();
        return reports;
    }
}
