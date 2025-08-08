<!-- 게시판 상세보기  -->
<%@page import="java.util.Collection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.sql.*, utils.DBCPUtil, vo.PostVO" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약하기 - Hotel Booking System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>

<!-- 
	예약 요약에 있는 
	호텔이름(title), 호텔주소(address), 호텔이미지(file_name)	
-->
<%
	String postidstr = request.getParameter("postid");
	int postid = Integer.parseInt(postidstr);
	Connection conn = DBCPUtil.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	PostVO vo = new PostVO();
	
	
	try{
		String sql = "SELECT title, address, file_name FROM posts WHERE post_type = 'HOTEL' AND post_id = ? ";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, postid);
		rs = pstmt.executeQuery();
		if(rs.next()){

			vo.setTitle(rs.getString(1));
			vo.setAddress(rs.getString(2));
		    String fileNamesString = rs.getString(3); // 예시: "a.jpg,b.jpg,c.jpg"
		    
		    if(fileNamesString != null && !fileNamesString.trim().equals("")){
		    	vo.setFileName((fileNamesString.split(",")));	
			}		   
		}		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBCPUtil.close(rs, pstmt, conn);
	} 
	
	// 객실 타입 정보를 저장할 리스트 생성
	ArrayList<PostVO> roomTypes = new ArrayList<PostVO>();
	// 편의시설 정보를 저장할 리스트 생성
	ArrayList<PostVO> facility = new ArrayList<PostVO>();

	// 객실 타입 정보 가져오기
	try {
	    conn = DBCPUtil.getConnection();
	    String sql = "SELECT post_id, title, content, price FROM posts WHERE post_type = 'ROOM_TYPE' AND parent_id = ?";
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setInt(1, postid);
	    rs = pstmt.executeQuery();
	    while(rs.next()){
	        PostVO post = new PostVO();
	        post.setPostId(rs.getInt(1));    // 객실 타입 ID
	        post.setTitle(rs.getString(2));   // 객실 제목
	        post.setContent(rs.getString(3)); // 객실 설명
	        post.setPrices(rs.getInt(4));
	        roomTypes.add(post);
	    }

	} catch(Exception e) {
		e.printStackTrace();
	}finally { DBCPUtil.close(pstmt, rs, conn); }

	// 편의시설 정보 가져오기
	try {
	    conn = DBCPUtil.getConnection();
	    String sql = "SELECT title FROM posts WHERE post_type = 'FACILITY' AND parent_id = ?";
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setInt(1, postid);
	    rs = pstmt.executeQuery();
	    while(rs.next()){
	        PostVO post = new PostVO();
	        post.setTitle(rs.getString(1));   // 편의시설 이름
	        facility.add(post);
	    }
	} catch(Exception e) {
		e.printStackTrace();
	}finally{ 
		DBCPUtil.close(pstmt, rs, conn); 
	}
%>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f8f9fa;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            position: sticky;
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(10px);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.2rem 2rem;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2.5rem;
            margin: 0;
            padding: 0;
            margin-left: auto;
            margin-right: 2rem;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: transform 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.05);
        }

        .logo i {
            font-size: 2rem;
            color: #ffd700;
        }



        .nav-menu a {
            text-decoration: none;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
            font-size: 1rem;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            position: relative;
        }

        .nav-menu a:hover {
            color: white;
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        .nav-menu a.active {
            color: white;
            background: rgba(255, 255, 255, 0.2);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .nav-menu a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 2px;
            background: #ffd700;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-menu a:hover::after,
        .nav-menu a.active::after {
            width: 80%;
        }

        .logout-btn {
            background: #dc3545;
            color: white !important;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.3s;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .logout-btn:hover {
            background: #c82333;
            color: white !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
        }

        /* Auth Buttons */
        .auth-buttons {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            margin-left: auto;
        }

        .btn {
            padding: 0.7rem 1.5rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-outline {
            border: 2px solid rgba(255, 255, 255, 0.8);
            color: white;
            background: transparent;
            backdrop-filter: blur(10px);
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .btn-primary {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            border: 2px solid transparent;
            box-shadow: 0 4px 15px rgba(238, 90, 36, 0.3);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #ee5a24, #ff6b6b);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(238, 90, 36, 0.4);
        }

        /* User Dropdown */
        .user-dropdown {
            position: relative;
            display: inline-block;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            padding: 0.8rem 1.2rem;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }

        .user-info:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
        }

        .user-info i {
            font-size: 1.2rem;
            color: #ffd700;
        }

        .user-info span {
            font-weight: 600;
            font-size: 0.95rem;
        }

        .user-dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background: rgba(255, 255, 255, 0.95);
            min-width: 180px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border-radius: 15px;
            z-index: 1001;
            margin-top: 0.8rem;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            overflow: hidden;
        }

        .user-dropdown-content a {
            color: #333;
            padding: 1rem 1.5rem;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.8rem;
            transition: all 0.3s ease;
            font-weight: 500;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .user-dropdown-content a:last-child {
            border-bottom: none;
        }

        .user-dropdown-content a:hover {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            transform: translateX(5px);
        }

        .user-dropdown-content.show {
            display: block;
            animation: fadeInDown 0.3s ease;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }

        /* Booking Form */
        .booking-form {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .form-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #eee;
        }

        .form-header h2 {
            color: #333;
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: #666;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 500;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2c5aa0;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        /* Room Selection */
        .room-options {
            display: grid;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .room-card {
            border: 2px solid #ddd;
            border-radius: 12px;
            padding: 1.5rem;
            cursor: pointer;
            transition: all 0.3s;
            position: relative;
        }

        .room-card:hover {
            border-color: #2c5aa0;
        }

        .room-card input[type="radio"] {
            position: absolute;
            top: 1rem;
            right: 1rem;
        }

        .room-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .room-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
        }

        .room-price {
            font-size: 1.1rem;
            font-weight: bold;
            color: #2c5aa0;
        }

        .room-description {
            color: #666;
            margin-bottom: 1rem;
        }

        .room-amenities {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
        }

        .amenity-tag {
            background: #f0f8ff;
            color: #2c5aa0;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.8rem;
        }

        /* Payment Methods */
        .payment-methods {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .payment-method {
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .payment-method:hover {
            border-color: #2c5aa0;
        }

        .payment-method input[type="radio"] {
            display: none;
        }

        .payment-method i {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            color: #666;
        }

        .card-info {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        /* Action Buttons */
        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: #2c5aa0;
            color: white;
        }

        .btn-primary:hover {
            background: #1e3f73;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #545b62;
        }

        /* Booking Summary */
        .booking-summary {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            height: fit-content;
        }

        .summary-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #eee;
        }

        .summary-header h3 {
            color: #333;
            margin-bottom: 0.5rem;
        }

        .hotel-info {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .hotel-image {
            width: 80px;
            height: 60px;
            border-radius: 8px;
            overflow: hidden;
        }

        .hotel-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .hotel-details h4 {
            color: #333;
            margin-bottom: 0.25rem;
        }

        .hotel-details .rating {
            color: #ffc107;
            font-size: 0.9rem;
        }

        .booking-details {
            margin-bottom: 2rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            padding: 0.5rem 0;
        }

        .detail-row.highlight {
            border-top: 1px solid #eee;
            border-bottom: 1px solid #eee;
            font-weight: bold;
            color: #2c5aa0;
        }

        .price-breakdown {
            margin-bottom: 2rem;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            padding: 0.25rem 0;
        }

        .price-row.total {
            border-top: 2px solid #eee;
            padding-top: 1rem;
            margin-top: 1rem;
            font-size: 1.2rem;
            font-weight: bold;
            color: #2c5aa0;
        }

        .terms-agreement {
            margin-bottom: 2rem;
        }

        .checkbox-group {
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
            margin: 0.5rem 0;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin-top: 0.25rem;
        }

        .checkbox-group label {
            cursor: pointer;
            font-size: 0.9rem;
            line-height: 1.4;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .container {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .booking-summary {
                order: -1;
            }
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .card-info {
                grid-template-columns: 1fr;
            }
            
            .payment-methods {
                grid-template-columns: 1fr 1fr;
            }
        }
    </style>
</head>
<body>
<%
// 세션 체크 - 로그인하지 않은 사용자는 로그인 페이지로 리다이렉트
Integer memberNum = (Integer)session.getAttribute("memberNum");
if(memberNum == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <a href="index.jsp" class="logo">
                <i class="fas fa-hotel"></i> Hotel Booking
            </a>
            <nav class="nav-menu">
                <a href="index.jsp">홈</a>
                <a href="hotels.jsp">호텔</a>
                <a href="reservations.jsp" class="active">예약</a>
                <a href="community.jsp">커뮤니티</a>
            </nav>
            <div class="auth-buttons">
                <%
                    boolean isAutoLogin = false;
                    String autoLoginUserId = null;
                    Cookie[] cookies = request.getCookies();
                    if (cookies != null) {
                        for (Cookie cookie : cookies) {
                            if ("autoLogin".equals(cookie.getName())) {
                                isAutoLogin = true;
                                autoLoginUserId = cookie.getValue();
                                break;
                            }
                        }
                    }
                    // 세션에서 사용자 정보 확인
                    String username = (String)session.getAttribute("username");
                    String name = (String)session.getAttribute("name");
                    Integer memberNum = (Integer)session.getAttribute("memberNum");
                    boolean isLoggedIn = (username != null) || isAutoLogin;
                    
                    // 자동로그인 쿠키가 있지만 세션이 없는 경우 세션에 사용자 정보 설정
                    if (isAutoLogin && username == null && autoLoginUserId != null) {
                        session.setAttribute("username", autoLoginUserId);
                        isLoggedIn = true;
                    }
                %>
                <% if (isLoggedIn) { %>
                    <div class="user-dropdown">
                        <div class="user-info">
                            <i class="fas fa-user-circle"></i>
                            <span><%= name != null ? name : (username != null ? username : autoLoginUserId) %></span>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="user-dropdown-content">
                            <a href="#">예약 내역</a>
                            <a href="logout.jsp">로그아웃</a>
                        </div>
                    </div>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-outline">로그인</a>
                    <a href="register.jsp" class="btn btn-primary">회원가입</a>
                <% } %>
            </div>
        </div>
    </header>

    <!-- Main Container -->
    <div class="container">
        <!-- Booking Form -->
        <div class="booking-form">
            <div class="form-header">
                <h2>호텔 예약</h2>
                <p>아래 정보를 입력하여 예약을 완료해주세요</p>
            </div>

            <form action="#" method="POST">
                <!-- Date & Guests -->
                <h3>체크인/체크아웃 날짜 및 인원</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="checkinDate">체크인</label>
                        <input type="date" id="checkinDate" name="checkinDate" required>
                    </div>
                    <div class="form-group">
                        <label for="checkoutDate">체크아웃</label>
                        <input type="date" id="checkoutDate" name="checkoutDate" required>
                    </div>
                    <div class="form-group">
                        <label for="nights">숙박일수</label>
                        <input type="number" id="nights" name="nights" readonly value="1">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="adults">성인</label>
                        <select id="adults" name="adults" required>
                            <option value="1">1명</option>
                            <option value="2" selected>2명</option>
                            <option value="3">3명</option>
                            <option value="4">4명</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="children">아동</label>
                        <select id="children" name="children">
                            <option value="0" selected>0명</option>
                            <option value="1">1명</option>
                            <option value="2">2명</option>
                            <option value="3">3명</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="rooms">객실 수</label>
                        <select id="rooms" name="rooms">
                            <option value="1" selected>1개</option>
                            <option value="2">2개</option>
                            <option value="3">3개</option>
                        </select>
                    </div>
                </div>

                <!-- Room Selection -->
                <h3>객실 타입 선택</h3>
     	<%if(roomTypes != null){ %>
       		<%for(PostVO r : roomTypes){ %>
                <div class="room-options">
                    <label class="room-card">
                        <input type="radio" name="roomType" value="<%=r.getPostId()%>" required>
                        <div class="room-header">
                            <div class="room-name"><%=r.getTitle() %></div>
                            <div class="room-price"><%=r.getPrices() %>/박</div>
                        </div>
                        <div class="room-description">
                            <%=r.getContent() %>
                        </div>
              
                        <div class="room-amenities">
                     <%if(facility != null){ %>
                		<%for(PostVO f : facility){ %>
                            <span class="amenity-tag"><%=f.getTitle() %></span>
						<%} %>
                     <%} %>
                        </div>
                    </label>
                </div>
       		<%} %>
		<%} %>
                <div class="form-group">
                    <label for="specialRequests">특별 요청사항 (선택)</label>
                    <textarea id="specialRequests" name="specialRequests" placeholder="객실 위치, 어메니티 요청, 기타 요청사항을 입력해주세요"></textarea>
                </div>

                <!-- Payment -->
                <h3>결제 정보</h3>
                
                <div class="payment-methods">
                    <label class="payment-method">
                        <input type="radio" name="paymentMethod" value="card" required>
                        <i class="fas fa-credit-card"></i>
                        <div>신용카드</div>
                    </label>
                    <label class="payment-method">
                        <input type="radio" name="paymentMethod" value="kakao">
                        <i class="fas fa-comment"></i>
                        <div>카카오페이</div>
                    </label>
                </div>



                <div class="terms-agreement">
                    <div class="checkbox-group">
                        <input type="checkbox" id="agreeTerms" name="agreeTerms" required>
                        <label for="agreeTerms">예약 약관 및 취소 정책에 동의합니다</label>
                    </div>
                    <div class="checkbox-group">
                        <input type="checkbox" id="agreePrivacy" name="agreePrivacy" required>
                        <label for="agreePrivacy">개인정보 수집 및 이용에 동의합니다</label>
                    </div>
                    <div class="checkbox-group">
                        <input type="checkbox" id="agreeMarketing" name="agreeMarketing">
                        <label for="agreeMarketing">마케팅 정보 수신에 동의합니다 (선택)</label>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <a href="hotels.jsp" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> 호텔 목록으로
                    </a>
                    <button type="button" class="btn btn-primary" style="flex: 1;" onclick="requestPayment()">
                        <i class="fas fa-credit-card"></i> 결제하기
                    </button>
                </div>
            </form>
        </div>

        <!-- Booking Summary -->
        <div class="booking-summary">
            <div class="summary-header">
                <h3>예약 요약</h3>
            </div>

            <div class="hotel-info">
                <div class="hotel-image">
                    <img src="img/<%=vo.getFileName()[0] %>" alt="서울 그랜드 호텔">
                </div>
                <div class="hotel-details">
                    <h4><%=vo.getTitle() %></h4>
                    <div class="rating">★★★★★ 9.2</div>
                    <small><%=vo.getAddress() %></small>
                </div>
            </div>

            <div class="booking-details">
                <div class="detail-row">
                    <span>체크인</span>
                    <span id="summaryCheckin">-</span>
                </div>
                <div class="detail-row">
                    <span>체크아웃</span>
                    <span id="summaryCheckout">-</span>
                </div>
                <div class="detail-row highlight">
                    <span>숙박일수</span>
                    <span id="summaryNights">-</span>
                </div>
                <div class="detail-row">
                    <span>투숙객</span>
                    <span id="summaryGuests">-</span>
                </div>
                <div class="detail-row">
                    <span>객실</span>
                    <span id="summaryRoom">-</span>
                </div>
            </div>

            <div class="price-breakdown">
                <div class="price-row">
                    <span>객실 요금</span>
                    <span id="summaryPrice">-</span>
                </div>
                <div class="price-row total">
                    <span>총 결제금액</span>
                    <span id="summaryTotal">-</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 날짜 계산 함수
        function calculateNights(checkin, checkout) {
            if (!checkin || !checkout) return 0;
            const start = new Date(checkin);
            const end = new Date(checkout);
            const diffTime = Math.abs(end - start);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            return diffDays;
        }

        // 날짜 포맷팅 함수
        function formatDate(dateString) {
            if (!dateString) return '-';
            const date = new Date(dateString);
            return date.toISOString().split('T')[0];
        }

        // 가격 포맷팅 함수
        function formatPrice(price) {
            if (!price) return '-';
            return price.toLocaleString() + '원';
        }

        // 투숙객 정보 업데이트
        function updateGuestInfo() {
            const adultsSelect = document.getElementById('adults');
            const childrenSelect = document.getElementById('children');
            const summaryElement = document.getElementById('summaryGuests');
            
            console.log('updateGuestInfo 함수 호출됨');
            console.log('adultsSelect:', adultsSelect);
            console.log('childrenSelect:', childrenSelect);
            console.log('summaryElement:', summaryElement);
            
            if (!adultsSelect || !childrenSelect || !summaryElement) {
                console.log('필요한 DOM 요소를 찾을 수 없습니다.');
                return;
            }
            
            const adults = parseInt(adultsSelect.value) || 0;
            const children = parseInt(childrenSelect.value) || 0;
            
            console.log('투숙객 정보 업데이트:', adults, children);
            
            let guestText = '';
            if (adults > 0) {
                guestText += `성인 ${adults}명`;
            }
            if (children > 0) {
                if (guestText) guestText += ', ';
                guestText += `아동 ${children}명`;
            }
            
            summaryElement.textContent = guestText || '-';
            console.log('업데이트된 투숙객 텍스트:', summaryElement.textContent);
        }

        // 객실 정보 업데이트
        function updateRoomInfo() {
            const selectedRoom = document.querySelector('input[name="roomType"]:checked');
            const summaryRoom = document.getElementById('summaryRoom');
            const summaryPrice = document.getElementById('summaryPrice');
            const summaryTotal = document.getElementById('summaryTotal');
            
            console.log('객실 정보 업데이트 - 선택된 객실:', selectedRoom);
            
            if (selectedRoom) {
                const roomCard = selectedRoom.closest('.room-card');
                const roomName = roomCard.querySelector('.room-name').textContent;
                const roomPrice = roomCard.querySelector('.room-price').textContent;
                
                console.log('객실명:', roomName, '가격:', roomPrice);
                
                if (summaryRoom) summaryRoom.textContent = roomName;
                if (summaryPrice) summaryPrice.textContent = roomPrice;
                
                // 총 결제금액 계산
                const nights = parseInt(document.getElementById('nights').value) || 1;
                const priceText = roomPrice.replace(/[^\d]/g, '');
                const price = parseInt(priceText) || 0;
                const total = price * nights;
                
                console.log('숙박일수:', nights, '객실가격:', price, '총액:', total);
                
                if (summaryTotal) summaryTotal.textContent = formatPrice(total);
            } else {
                if (summaryRoom) summaryRoom.textContent = '-';
                if (summaryPrice) summaryPrice.textContent = '-';
                if (summaryTotal) summaryTotal.textContent = '-';
            }
        }

        // 날짜 정보 업데이트
        function updateDateInfo() {
            const checkin = document.getElementById('checkinDate').value;
            const checkout = document.getElementById('checkoutDate').value;
            
            const summaryCheckin = document.getElementById('summaryCheckin');
            const summaryCheckout = document.getElementById('summaryCheckout');
            const summaryNights = document.getElementById('summaryNights');
            const nightsInput = document.getElementById('nights');
            
            if (summaryCheckin) summaryCheckin.textContent = formatDate(checkin);
            if (summaryCheckout) summaryCheckout.textContent = formatDate(checkout);
            
            const nights = calculateNights(checkin, checkout);
            if (nightsInput) nightsInput.value = nights;
            if (summaryNights) summaryNights.textContent = nights > 0 ? `${nights}박` : '-';
            
            // 객실 정보도 다시 업데이트 (가격 재계산)
            updateRoomInfo();
        }

        // 이벤트 리스너 등록
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM 로드 완료 - reservations.jsp');
            
            // 날짜 변경 이벤트
            document.getElementById('checkinDate').addEventListener('change', updateDateInfo);
            document.getElementById('checkoutDate').addEventListener('change', updateDateInfo);
            
            // 투숙객 변경 이벤트
            document.getElementById('adults').addEventListener('change', updateGuestInfo);
            document.getElementById('children').addEventListener('change', updateGuestInfo);
            
            // 객실 선택 변경 이벤트
            document.querySelectorAll('input[name="roomType"]').forEach(radio => {
                radio.addEventListener('change', updateRoomInfo);
            });
            
            // 초기값 설정
            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            
            document.getElementById('checkinDate').value = today.toISOString().split('T')[0];
            document.getElementById('checkoutDate').value = tomorrow.toISOString().split('T')[0];
            
            // 약간의 지연 후 초기 업데이트 실행 (DOM이 완전히 로드되도록)
            setTimeout(function() {
                console.log('초기 업데이트 시작');
                updateDateInfo();
                updateGuestInfo();
                updateRoomInfo();
                
                // 디버깅을 위한 로그
                console.log('페이지 로드 완료 - 초기값 설정됨');
                console.log('성인 수:', document.getElementById('adults').value);
                console.log('아동 수:', document.getElementById('children').value);
                console.log('숙박일수:', document.getElementById('nights').value);
            }, 100);
        });

    // 포트원 결제 요청 함수
    function requestPayment() {
        // 필수 필드 검증
        const checkinDate = document.getElementById('checkinDate').value;
        const checkoutDate = document.getElementById('checkoutDate').value;
        const selectedRoom = document.querySelector('input[name="roomType"]:checked');
        const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
        const agreeTerms = document.getElementById('agreeTerms').checked;
        const agreePrivacy = document.getElementById('agreePrivacy').checked;

        if (!checkinDate || !checkoutDate) {
            alert('체크인/체크아웃 날짜를 선택해주세요.');
            return;
        }

        if (!selectedRoom) {
            alert('객실 타입을 선택해주세요.');
            return;
        }

        if (!paymentMethod) {
            alert('결제 방법을 선택해주세요.');
            return;
        }

        if (!agreeTerms || !agreePrivacy) {
            alert('필수 약관에 동의해주세요.');
            return;
        }

        // 선택된 객실 정보 가져오기
        const roomCard = selectedRoom.closest('.room-card');
        const roomName = roomCard.querySelector('.room-name').textContent;
        const roomPrice = roomCard.querySelector('.room-price').textContent;
        const priceText = roomPrice.replace(/[^\d]/g, '');
        const price = parseInt(priceText) || 0;
        const nights = parseInt(document.getElementById('nights').value) || 1;
        const totalAmount = price * nights;

        // 포트원 초기화
        var IMP = window.IMP;
        IMP.init('imp20622085'); // 실제 가맹점 식별코드로 변경 필요

        // 결제 요청 데이터
        const paymentData = {
            pg: getPaymentPG(paymentMethod.value),
            pay_method: 'card',
            merchant_uid: 'hotel_' + new Date().getTime(),
            name: '<%=vo.getTitle()%> - ' + roomName,
            amount: totalAmount,
            custom_data: {
                checkin_date: checkinDate,
                checkout_date: checkoutDate,
                nights: nights,
                adults: document.getElementById('adults').value,
                children: document.getElementById('children').value,
                room_type: roomName,
                hotel_name: '<%=vo.getTitle()%>',
                special_requests: document.getElementById('specialRequests').value
            }
        };

        // 결제 요청
        IMP.request_pay(paymentData, function(rsp) {
            if (rsp.success) {
                console.log("결제 성공:", rsp);
                
                // 결제 성공 시 예약 정보를 서버로 전송 (데이터베이스 구조에 맞춤)
                const reservationData = {
                    member_num: '<%=memberNum%>', // 세션에서 가져온 회원번호
                    hotel_post_id: '<%=postidstr%>', // 호텔 게시글 ID
                    room_post_id: selectedRoom.value, // 선택된 객실 타입 ID
                    check_in_date: checkinDate,
                    check_out_date: checkoutDate,
                    adults: parseInt(document.getElementById('adults').value) || 1,
                    children: parseInt(document.getElementById('children').value) || 0,
                    total_amount: totalAmount,
                    special_requests: document.getElementById('specialRequests').value,
                    // 결제 정보 (서블릿에서 처리)
                    imp_uid: rsp.imp_uid,
                    merchant_uid: rsp.merchant_uid,
                    paid_amount: rsp.paid_amount,
                    apply_num: rsp.apply_num
                };

                // 예약 정보를 서버로 전송
                $.post('reservation-complete', reservationData, function(response) {
                    if (response.success) {
                        alert('예약이 성공적으로 완료되었습니다!');
                        window.location.href = 'reservation-success.jsp?merchant_uid=' + rsp.merchant_uid;
                    } else {
                        alert('예약 처리 중 오류가 발생했습니다: ' + response.message);
                    }
                }).fail(function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                });

            } else {
                console.log("결제 실패:", rsp);
                alert('결제에 실패하였습니다. 에러 내용: ' + rsp.error_msg);
            }
        });
    }

    // 결제 방법에 따른 PG 설정
    function getPaymentPG(paymentMethod) {
        switch(paymentMethod) {
            case 'kakao':
                return 'kakaopay';
            case 'card':
                return 'html5_inicis';
            case 'transfer':
                return 'html5_inicis';
            case 'naver':
                return 'naverpay';
            default:
                return 'html5_inicis';
        }
    }
    
    // 드롭다운 클릭 이벤트 처리
    document.addEventListener('DOMContentLoaded', function() {
        const userDropdown = document.querySelector('.user-dropdown');
        const dropdownContent = document.querySelector('.user-dropdown-content');
        
        if (userDropdown && dropdownContent) {
            // 사용자 정보 클릭 시 드롭다운 토글
            const userInfo = userDropdown.querySelector('.user-info');
            userInfo.addEventListener('click', function(e) {
                e.stopPropagation();
                dropdownContent.classList.toggle('show');
            });
            
            // 드롭다운 외부 클릭 시 닫기
            document.addEventListener('click', function(e) {
                if (!userDropdown.contains(e.target)) {
                    dropdownContent.classList.remove('show');
                }
            });
            
            // ESC 키로 드롭다운 닫기
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    dropdownContent.classList.remove('show');
                }
            });
        }
    });
    </script>
</body>
</html>  