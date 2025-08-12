<!-- 
	호텔 목록 페이지 
	시글 목록 페이지(작성된 게시글의 번호, 제목, 작성자, 작성일 등의 정보를 이용하여 등록된 게시글 목록을 확인 할 수 있는 기능) -   게시글 데이터
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, utils.*, java.util.*, vo.*" %>

<%
// 세션 체크 - 로그인하지 않은 사용자나 일반 사용자는 히스토리백과 알림창 표시
Integer memberNum = (Integer)session.getAttribute("memberNum");
String userType = (String)session.getAttribute("userType");
if(memberNum == null || (!"ADMIN".equals(userType) && !"HOTEL_MANAGER".equals(userType))) {
%>
    <script>
        alert("로그인 후 사용해 주세요.");
        history.back();
    </script>
<%
    return;
}

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
	DBCPUtil.close(rs, pstmt, conn);
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>호텔 목록 관리 - Hotel Booking System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            line-height: 1.6;
        }

        .header {
            background: #2c5aa0;
            color: white;
            padding: 1rem 0;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 1.8rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #28a745;
            color: white;
        }

        .btn-primary:hover {
            background: #218838;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #545b62;
        }

        .main-content {
            padding: 2rem 0;
        }

        .hotel-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .hotel-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.3s;
        }

        .hotel-card:hover {
            transform: translateY(-5px);
        }

        .hotel-image {
            height: 200px;
            overflow: hidden;
        }

        .hotel-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .hotel-info {
            padding: 1.5rem;
        }

        .hotel-title {
            font-size: 1.3rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .hotel-address {
            color: #666;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }

        .hotel-content {
            color: #555;
            margin-bottom: 1rem;
            line-height: 1.5;
        }

        .hotel-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 0.85rem;
            color: #888;
        }

        .hotel-actions {
            display: flex;
            gap: 0.5rem;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #ddd;
        }

        @media (max-width: 768px) {
            .hotel-grid {
                grid-template-columns: 1fr;
            }
            
            .header-content {
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <h1><i class="fas fa-hotel"></i> 호텔 목록 관리</h1>
                <div>
                    <a href="admin-dashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> 대시보드로
                    </a>
                    <a href="hotel-register.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> 새 호텔 등록
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <% if(list.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-hotel"></i>
                    <h2>등록된 호텔이 없습니다</h2>
                    <p>새로운 호텔을 등록해보세요!</p>
                    <a href="hotel-register.jsp" class="btn btn-primary">
                        <i class="fas fa-plus"></i> 호텔 등록하기
                    </a>
                </div>
            <% } else { %>
                <div class="hotel-grid">
                    <% for(PostVO hotel : list) { %>
                        <div class="hotel-card">
                            <div class="hotel-image">
                                <% if(hotel.getFileName() != null && hotel.getFileName().length > 0) { %>
                                    <img src="img/<%= hotel.getFileName()[0] %>" alt="<%= hotel.getTitle() %>">
                                <% } else { %>
                                    <div style="background: #f0f0f0; height: 100%; display: flex; align-items: center; justify-content: center; color: #999;">
                                        <i class="fas fa-image" style="font-size: 3rem;"></i>
                                    </div>
                                <% } %>
                            </div>
                            <div class="hotel-info">
                                <div class="hotel-title"><%= hotel.getTitle() %></div>
                                <div class="hotel-address">
                                    <i class="fas fa-map-marker-alt"></i> 
                                    <%= hotel.getAddress() != null ? hotel.getAddress() : "주소 정보 없음" %>
                                </div>
                                <div class="hotel-content">
                                    <%= hotel.getContent() != null ? hotel.getContent().length() > 100 ? 
                                        hotel.getContent().substring(0, 100) + "..." : hotel.getContent() : "설명 없음" %>
                                </div>
                                <div class="hotel-meta">
                                    <span>
                                        <i class="fas fa-calendar"></i> 
                                        <%= hotel.getCreatedAt() != null ? hotel.getCreatedAt().toString().substring(0, 10) : "날짜 없음" %>
                                    </span>
                                    <span>ID: <%= hotel.getPostId() %></span>
                                </div>
                                <div class="hotel-actions">
                                    <a href="hotel-detail.jsp?id=<%= hotel.getPostId() %>" class="btn btn-primary">
                                        <i class="fas fa-eye"></i> 상세보기
                                    </a>
                                    <a href="hotel-edit.jsp?id=<%= hotel.getPostId() %>" class="btn btn-secondary">
                                        <i class="fas fa-edit"></i> 수정
                                    </a>
                                    <a href="hotel-delete?id=<%= hotel.getPostId() %>" class="btn btn-danger" 
                                       onclick="return confirm('정말 삭제하시겠습니까?')">
                                        <i class="fas fa-trash"></i> 삭제
                                    </a>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>