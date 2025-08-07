<!-- 
	호텔 목록 페이지 
	시글 목록 페이지(작성된 게시글의 번호, 제목, 작성자, 작성일 등의 정보를 이용하여 등록된 게시글 목록을 확인 할 수 있는 기능) -   게시글 데이터
-->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, utils.*, java.util.*, vo.*" %>
<%
	/* 호텔 목록을 저장할 list */
	List<PostVO> list = new ArrayList<>();
	
	Connection conn = DBCPUtil.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT post_id, title, address, content, file_name, member_num, created_at FROM posts WHERE post_type = 'HOTEL' ORDER BY post_id DESC";
	
	try{
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		while(rs.next()){
			PostVO board = new PostVO();
			board.setPostId(rs.getInt(1));
			board.setTitle(rs.getString(2));
			board.setAddress(rs.getString(3));
			board.setContent(rs.getString(4));
			String fileStr = rs.getString(5);
			board.setMemberNum(rs.getLong(6));
			board.setCreatedAt(rs.getTimestamp(7));
			if (fileStr != null && !fileStr.trim().equals("")) {
				board.setFileName((fileStr.split(",")));		
			}			
			list.add(board);
			if(board.getAddress() == null){
				DBCPUtil.close(rs, pstmt, conn);
			}
			
			
		}
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>