<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, utils.*" %>
<%
	String strPostId = request.getParameter("postId");
	int postId = 0;
	
	if(strPostId != null){
		postId = Integer.parseInt(strPostId);
	}

	Connection conn = null;
	PreparedStatement pstmt = null;
	String msg = null;

	try {
		conn = DBCPUtil.getConnection();
		String sql = "DELETE FROM posts WHERE post_type = 'HOTEL' AND post_id = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, postId);
		
		int result = pstmt.executeUpdate();

		msg = (result == 1) ? "호텔 삭제 완료" : "삭제된 내용이 없습니다.";
	} catch(Exception e) {
		e.printStackTrace();
		msg = "삭제시 문제가 발생했습니다. : " + e.getMessage();
	} finally {
		DBCPUtil.close(pstmt, conn); // 자원 반납 및 해제
	}

	String path = request.getContextPath();
%>
<html>
<head><title>호텔 삭제 결과</title></head>
<body>
	<p><%= msg %></p>
	<a href="<%= path %>/admin-dashboard.jsp">Admin Dashboard로 돌아가기</a>
</body>
</html>