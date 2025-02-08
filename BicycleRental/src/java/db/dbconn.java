package db; // package where the class is located

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author User
 */

import java.sql.Connection; // import connection class for database connectivity
import java.sql.DriverManager; // import DriveManager to manage databse connection
import java.sql.SQLException; // Import SQLEsception to handle SQL errors

public class dbconn {
 
    // databse connection details
    private static final String URL = "jdbc:mysql://localhost:3306/bicyclerental";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    
// method to ger a database connection
    public static Connection getConnection() { // Singleton element: global access point
        try {
        System.out.println("Loading MySQL Driver...");
        Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure driver is loaded
        System.out.println("Driver loaded successfully.");
        
        // establish connection to databse
        
        // Instance of Connection / centralised connection management:
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD); 
        System.out.println("Connection established.");
        return conn; // return the connection object
    } catch (ClassNotFoundException e) { // if JDBC driver is not found
        System.err.println("Driver not found: " + e.getMessage());
        e.printStackTrace();
        return null;
    } catch (SQLException e) { // if there's any error in SQL
        System.err.println("SQL Exception: " + e.getMessage());
        e.printStackTrace();
        return null;
    }
}
     
}
    

