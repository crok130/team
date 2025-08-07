<!-- 게시판 상세보기  -->
<%@page import="java.util.Collection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<%@ page import="java.util.ArrayList, java.sql.*, utils.DBCPUtil, vo.PostVO" %>

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
	    String sql = "SELECT title, content,price FROM posts WHERE post_type = 'ROOM_TYPE' AND parent_id = ?";
	    pstmt = conn.prepareStatement(sql);
	    pstmt.setInt(1, postid);
	    rs = pstmt.executeQuery();
	    while(rs.next()){
	        PostVO post = new PostVO();
	        post.setTitle(rs.getString(1));   // 객실 제목
	        post.setContent(rs.getString(2)); // 객실 설명
	        post.setPrices(rs.getInt(3));
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
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약하기 - Hotel Booking System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: #2c5aa0;
            text-decoration: none;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 2rem;
        }

        .nav-menu a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: color 0.3s;
        }

        .nav-menu a:hover, .nav-menu a.active {
            color: #2c5aa0;
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
                 <a href="login.jsp">로그인</a>
                 <a href="logout" class="logout-btn">
                     <i class="fas fa-sign-out-alt"></i> 로그아웃
                 </a>
             </nav>
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
                        <input type="radio" name="roomType" value="standard" required>
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
                <!-- Guest Information -->
                <h3>투숙객 정보</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="guestName">성명 (대표 투숙객)</label>
                        <input type="text" id="guestName" name="guestName" placeholder="홍길동" required>
                    </div>
                    <div class="form-group">
                        <label for="guestPhone">연락처</label>
                        <input type="tel" id="guestPhone" name="guestPhone" placeholder="010-1234-5678" required>
                    </div>
                    <div class="form-group">
                        <label for="guestEmail">이메일</label>
                        <input type="email" id="guestEmail" name="guestEmail" placeholder="hong@email.com" required>
                    </div>
                </div>

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
                        <input type="radio" name="paymentMethod" value="transfer">
                        <i class="fas fa-university"></i>
                        <div>계좌이체</div>
                    </label>
                    <label class="payment-method">
                        <input type="radio" name="paymentMethod" value="kakao">
                        <i class="fas fa-comment"></i>
                        <div>카카오페이</div>
                    </label>
                    <label class="payment-method">
                        <input type="radio" name="paymentMethod" value="naver">
                        <i class="fas fa-mobile-alt"></i>
                        <div>네이버페이</div>
                    </label>
                </div>

                <div class="card-info">
                    <div class="form-group">
                        <label for="cardNumber">카드번호</label>
                        <input type="text" id="cardNumber" name="cardNumber" placeholder="1234-5678-9012-3456" maxlength="19">
                    </div>
                    <div class="form-group">
                        <label for="expiry">유효기간</label>
                        <input type="text" id="expiry" name="expiry" placeholder="MM/YY" maxlength="5">
                    </div>
                    <div class="form-group">
                        <label for="cvv">CVV</label>
                        <input type="text" id="cvv" name="cvv" placeholder="123" maxlength="3">
                    </div>
                </div>

                <div class="form-group">
                    <label for="cardHolder">카드 소유자명</label>
                    <input type="text" id="cardHolder" name="cardHolder" placeholder="홍길동">
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
                    <button type="submit" class="btn btn-primary" style="flex: 1;">
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
                    <span>2024-02-15</span>
                </div>
                <div class="detail-row">
                    <span>체크아웃</span>
                    <span>2024-02-17</span>
                </div>
                <div class="detail-row highlight">
                    <span>숙박일수</span>
                    <span>2박</span>
                </div>
                <div class="detail-row">
                    <span>투숙객</span>
                    <span>성인 2명</span>
                </div>
                <div class="detail-row">
                    <span>객실</span>
                    <span>스탠다드 룸</span>
                </div>
            </div>

            <div class="price-breakdown">
                <div class="price-row">
                    <span>객실 요금</span>
                    <span>240,000원</span>
                </div>
                <div class="price-row">
                    <span>세금 및 수수료</span>
                    <span>24,000원</span>
                </div>
                <div class="price-row total">
                    <span>총 결제금액</span>
                    <span>264,000원</span>
                </div>
            </div>
        </div>
    </div>
</body>

</html>  