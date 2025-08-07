<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, utils.*" %>
<%
	String approval = request.getParameter("approval");
	String membernumStr = request.getParameter("membernum");
	int membernum = Integer.parseInt(membernumStr);
	if(approval.equals("approve")){
		
		Connection conn = DBCPUtil.getConnection();
		PreparedStatement pstmt = null;
		String sql = "UPDATE users SET STATUS = 'APPROVED' WHERE member_num = ?";
		
		try{
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, membernum);
			int result = pstmt.executeUpdate();
			if(result == 1){
%>
			<script>
				alert('승인되었습니다.');
				history.back(); // 이전 페이지로 이동
			</script>
					
<%
				response.sendRedirect("admin-dashboard.jsp");
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBCPUtil.close(pstmt, conn);
		}
		
		
		
	}else{
		Connection conn = DBCPUtil.getConnection();
		PreparedStatement pstmt = null;
		String sql = "UPDATE users SET STATUS = 'REJECTED' WHERE member_num = ?";
		
		try{
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, membernum);
			int result = pstmt.executeUpdate();
			if(result == 1){
%>
			<script>
				alert('거절되었습니다	.');
				history.back(); // 이전 페이지로 이동
			</script>
					
<%
		
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBCPUtil.close(pstmt, conn);
		}
		
	
		
		
		
		
	}
%>