//Demo MySQL
//Met Connectionpooling

package server;

import com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource;
import java.sql.*;

public class MySQLDatabase_char {
    private static MySQLDatabase_char instance=new MySQLDatabase_char();
    private MysqlConnectionPoolDataSource pool;
    private String sequenceTable;
    private boolean sequenceSupported;

    private MySQLDatabase_char() {
        pool = new MysqlConnectionPoolDataSource();
        
        //zelf aanvullen!        
        //maak connectie met de database
        
        pool.setDatabaseName("characters");
        pool.setServerName("hairy.dyndns.biz");
        pool.setUser("selectonly");
        pool.setPassword("1234");
        pool.setPort(3306);
        //sequenceTable="pkgenerator";
        sequenceSupported = false;
    }

    public static MySQLDatabase_char getInstance(){
        return instance;
    }

    //openen connectie
    public  Connection getConnection() throws SQLException{
        return pool.getConnection();
    }
    
    /**
     * Creëert een nieuw id voor een tabel en kolom, indien
     * een Sequence gebruikt wordt, wordt de tabel en kolom genegeerd.
     */
    public int createNewID(Connection conn, String tabel,String kolom){
        try{
            if ( sequenceSupported){
                String sql = "select nextval('"+sequenceTable+"')";
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(sql);
                if ( rs.next()){
                    return rs.getInt(1);
                }
                return -1;
            }else{
                if ( conn != null && !conn.isClosed()){
                    String sql = "select max("+kolom+") as maxid from "+tabel;
                    Statement st = conn.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    if ( rs.next() ){
                        int maxid = rs.getInt("maxid");
                        return maxid+1;
                    }
                    return -1;
                }
            }
        }catch(SQLException ex){
            ex.printStackTrace();
        }
        return -1;
    }

    /**
     * Deze methode kan gebruikt worden om te testen wat er precies in een
     * ResultSet te vinden is.
     * Let op : De ResultSet kan je daarna niet meer gebruiken!
     */
    public void printResultSet(ResultSet rs){
        try{
            ResultSetMetaData rsmd = rs.getMetaData();
            for (int i=1;i <= rsmd.getColumnCount();i++){
                System.out.print(rsmd.getColumnLabel(i));
                System.out.print(",");
            }
            System.out.println();
            while(rs.next()){
                for ( int i = 1 ; i <= rsmd.getColumnCount(); i++){
                    System.out.print(rs.getString(i));
                    System.out.print(",");
                }
                System.out.println();
            }
        }catch(Exception ex){
            ex.printStackTrace();
        }
    }

    public static void main(String[] args)throws Exception{
        System.out.println("Execute this main method to test the connection !");
        MySQLDatabase_char db = MySQLDatabase_char.getInstance();
        Connection c = db.getConnection();
        System.out.println("Connectie openen geslaagd");
        c.close();
        System.out.println("Connectie sluiten geslaagd");

    }
}