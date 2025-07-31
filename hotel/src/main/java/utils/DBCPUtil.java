package utils;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Connection Pool 에 등록된
 * Connection 제공 및 자원해제 담당 class
 */
public class DBCPUtil {
	
	/**
	 * Connection 객체 반환
	 */
	public static Connection getConnection() {
		Connection conn = null;
		
		try {
			DataSource ds = 
					(DataSource)new InitialContext().lookup("java:comp/env/jdbc/OracleDBCP");
			conn = ds.getConnection();
		} catch (NamingException e) {
			System.out.println("지정한 이름의 Resource 를 찾을 수 없습니다.");
			e.printStackTrace(); // 오류 출력
		} catch (SQLException e) {
			System.out.println("Connection 연결 정보 오류");
			e.printStackTrace();
		}
		
		return conn;
	} // end getConnection();
	
	/**
	 * 매개변수로 전달받은 모든 연결 객체 자원 해제
	 */
	public static void close(AutoCloseable... closes) {
		for(AutoCloseable c : closes) {
			if(c != null) {
				try {
					c.close();
				} catch (Exception e) {
					
				}
			}// check nullable
		} // end for
	} // end close()

}






