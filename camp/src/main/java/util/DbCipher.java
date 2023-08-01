package util;

import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DbCipher {
	public static void main(String[] args) throws Exception {
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mariadb://14.36.141.71:20000/gdudb44", "gdu44", "5555");
		PreparedStatement pstmt = conn.prepareStatement("select id, pass from user");
		System.out.println(pstmt);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			String id = rs.getString("id");
			String pass = rs.getString("pass");
			if(pass == null) {
				pstmt.setString(1, null);
			} else {
				MessageDigest md = MessageDigest.getInstance("SHA-512");
				String hashpass = "";
				byte[] plain = pass.getBytes();
				byte[] hash = md.digest(plain);
				for(byte b : hash) hashpass += String.format("%02X", b);
				pstmt.close();
				pstmt = conn.prepareStatement("update user set pass=? where id=?");
				pstmt.setString(1, hashpass);
				pstmt.setString(2, id);
				pstmt.executeUpdate();
			}
		
		}
	}
}
