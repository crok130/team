<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.lang.foreign.AddressLayout"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.*, utils.*,vo.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	Connection conn = DBCPUtil.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	List<PostVO> list = new ArrayList<>();
	List<PostVO> facility = new ArrayList<>();
	
	// 요청 페이지
	String strPage = request.getParameter("page"); 
	int pageNum = 1;
	if(strPage != null){
		pageNum = Integer.parseInt(strPage);
	}
	
	Criteria cri = new Criteria(pageNum, 10); // 한번에 보여줄 게시물 수는 알아서 수정
	
	
	// 호텔 이름, 주소, 설명, 이미지
	try{
		String sql = "SELECT post_id,title,address,content,file_name,member_num FROM posts WHERE post_type = 'HOTEL' ";
		sql += " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,cri.getStartRow());
		pstmt.setInt(2,cri.getPerPageNum());
		
		rs = pstmt.executeQuery();
		while(rs.next()){
			PostVO vo = new PostVO();
			vo.setPostId(rs.getInt(1));
			vo.setTitle(rs.getString(2));
			vo.setAddress(rs.getString(3));
			vo.setContent(rs.getString(4));
			String fileStr = rs.getString(5);
			vo.setMemberNum(rs.getLong(6));
			if (fileStr != null && !fileStr.trim().equals("")) {
				vo.setFileName((fileStr.split(",")));		
			}			
			list.add(vo);
			if(vo.getAddress() == null){
				
			}
		}		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBCPUtil.close(pstmt, rs, conn);
	}
	
	// 호텔 시설
	try{
		conn = DBCPUtil.getConnection();
		String sql = "SELECT title,content,parent_id FROM posts WHERE post_type = 'FACILITY'";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			PostVO post = new PostVO();
			post.setTitle(rs.getString(1));
			post.setContent(rs.getString(2));
			post.setParentId(rs.getLong(3));
			facility.add(post);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBCPUtil.close(pstmt,rs,conn);
	}


	// 게시글 목록을 저장할 List
	


	// 페이지 블럭(이동할 페이지 번호) 정보 처리
	// 이동할 최대 페이지 번호를 계산하기 위한 전체 게시물 개수 검색
	
	conn = DBCPUtil.getConnection();
	Statement stmt = conn.createStatement();
	rs = stmt.executeQuery("SELECT count(*) FROM posts  WHERE post_type = 'HOTEL'");
	// 전체 게시물(행) 개수를 저장할 변수
	int totalCount = 0;
	
	if(rs.next()){
		totalCount = rs.getInt(1);
	}
	System.out.println("전체 게시물 개수 : " + totalCount);
	
	DBCPUtil.close(rs, stmt, conn);
	
	PageMaker pm = new PageMaker(cri, totalCount, 10);
	System.out.println(pm);
	
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>호텔 검색 - Hotel Booking System</title>
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

        /* Main Content */
        .main-content {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 2rem;
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        /* Search Section */
        .search-section {
            background: white;
            padding: 2rem 0;
            border-bottom: 1px solid #eee;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .search-form {
            display: flex;
            gap: 1rem;
            align-items: end;
            flex-wrap: wrap;
        }

        .form-group {
            flex: 1;
            min-width: 200px;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: #333;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2c5aa0;
        }

        .search-btn {
            padding: 0.75rem 2rem;
            background: #2c5aa0;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            white-space: nowrap;
        }

        .search-btn:hover {
            background: #1e3f73;
        }

        /* Filters Sidebar */
        .filters-sidebar {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            height: fit-content;
        }

        .filter-section {
            margin-bottom: 2rem;
        }

        .filter-section h3 {
            margin-bottom: 1rem;
            color: #333;
            font-size: 1.1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #eee;
        }

        .price-range {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .price-range input {
            flex: 1;
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .checkbox-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .checkbox-group label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            padding: 0.25rem 0;
        }

        .rating-filter {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .rating-option {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            padding: 0.25rem 0;
        }

        .stars {
            color: #ffc107;
        }

        /* Hotels Grid */
        .hotels-container {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
        }

        .results-info {
            color: #666;
        }

        .sort-options select {
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 6px;
            background: white;
        }

        .hotels-grid {
            display: grid;
            gap: 1.5rem;
        }

        .hotel-card {
            border: 1px solid #eee;
            border-radius: 12px;
            overflow: hidden;
            transition: all 0.3s;
            background: white;
        }

        .hotel-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .hotel-card-content {
            display: grid;
            grid-template-columns: 250px 1fr auto;
            gap: 1.5rem;
            padding: 1.5rem;
        }

        .hotel-image {
            position: relative;
            border-radius: 8px;
            overflow: hidden;
        }

        .hotel-image img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .image-gallery {
            position: absolute;
            bottom: 0.5rem;
            right: 0.5rem;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.8rem;
        }

        .hotel-info {
            flex: 1;
        }

        .hotel-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.5rem;
        }

        .hotel-name {
            font-size: 1.3rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 0.25rem;
        }

        .hotel-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .rating-stars {
            color: #ffc107;
        }

        .rating-score {
            background: #2c5aa0;
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-weight: bold;
            font-size: 0.9rem;
        }

        .hotel-location {
            color: #666;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .hotel-amenities {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .amenity-tag {
            background: #f0f8ff;
            color: #2c5aa0;
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.8rem;
        }

        .hotel-description {
            color: #666;
            line-height: 1.5;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .hotel-pricing {
            text-align: right;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: end;
        }

        .price-info {
            margin-bottom: 1rem;
        }

        .price-per-night {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 0.25rem;
        }

        .price-amount {
            font-size: 1.5rem;
            font-weight: bold;
            color: #2c5aa0;
        }

        .price-currency {
            font-size: 1rem;
            color: #666;
        }

        .book-btn {
            padding: 0.75rem 1.5rem;
            background: #2c5aa0;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .book-btn:hover {
            background: #1e3f73;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #eee;
        }

        .pagination a {
            padding: 0.5rem 1rem;
            border: 1px solid #ddd;
            background: white;
            color: #333;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s;
        }

        .pagination a:hover {
            background: #f8f9fa;
        }

        .pagination a.active {
            background: #2c5aa0;
            color: white;
            border-color: #2c5aa0;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .main-content {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .filters-sidebar {
                order: 2;
            }
            
            .hotels-container {
                order: 1;
            }
        }

        @media (max-width: 768px) {
            .hotel-card-content {
                grid-template-columns: 1fr;
                text-align: center;
            }
            
            .hotel-image {
                justify-self: center;
                width: 100%;
                max-width: 300px;
            }
            
            .hotel-pricing {
                text-align: center;
                align-items: center;
            }
            
            .search-form {
                flex-direction: column;
            }
            
            .form-group {
                min-width: 100%;
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
                <a href="hotels.jsp" class="active">호텔</a>
                <a href="reservations.jsp">예약</a>
                <a href="community.jsp">커뮤니티</a>
                <a href="login.jsp">로그인</a>
                <a href="logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> 로그아웃
                </a>
            </nav>
        </div>
    </header>

    <!-- Search Section -->
    <section class="search-section">
        <div class="container">
            <form class="search-form" action="#" method="GET">
                <div class="form-group">
                    <label for="destination">목적지</label>
                    <input type="text" id="destination" name="destination" placeholder="도시 또는 호텔명 입력">
                </div>
                <div class="form-group">
                    <label for="checkin">체크인</label>
                    <input type="date" id="checkin" name="checkin">
                </div>
                <div class="form-group">
                    <label for="checkout">체크아웃</label>
                    <input type="date" id="checkout" name="checkout">
                </div>
                <div class="form-group">
                    <label for="guests">인원</label>
                    <select id="guests" name="guests">
                        <option value="1">1명</option>
                        <option value="2" selected>2명</option>
                        <option value="3">3명</option>
                        <option value="4">4명</option>
                        <option value="5+">5명 이상</option>
                    </select>
                </div>
                <button type="submit" class="search-btn">
                    <i class="fas fa-search"></i> 검색
                </button>
            </form>
        </div>
    </section>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Filters Sidebar -->
        <aside class="filters-sidebar">
            <div class="filter-section">
                <h3>가격 범위</h3>
                <div class="price-range">
                    <input type="number" placeholder="최소" id="minPrice">
                    <span>~</span>
                    <input type="number" placeholder="최대" id="maxPrice">
                </div>
            </div>

            <div class="filter-section">
                <h3>별점</h3>
                <div class="rating-filter">
                    <label class="rating-option">
                        <input type="checkbox" name="rating" value="5">
                        <span class="stars">★★★★★</span>
                        <span>5성급</span>
                    </label>
                    <label class="rating-option">
                        <input type="checkbox" name="rating" value="4">
                        <span class="stars">★★★★☆</span>
                        <span>4성급</span>
                    </label>
                    <label class="rating-option">
                        <input type="checkbox" name="rating" value="3">
                        <span class="stars">★★★☆☆</span>
                        <span>3성급</span>
                    </label>
                </div>
            </div>

            <div class="filter-section">
                <h3>편의시설</h3>
                <div class="checkbox-group">
                    <label>
                        <input type="checkbox" name="amenities" value="wifi">
                        <i class="fas fa-wifi"></i> 무료 Wi-Fi
                    </label>
                    <label>
                        <input type="checkbox" name="amenities" value="pool">
                        <i class="fas fa-swimming-pool"></i> 수영장
                    </label>
                    <label>
                        <input type="checkbox" name="amenities" value="parking">
                        <i class="fas fa-parking"></i> 주차장
                    </label>
                    <label>
                        <input type="checkbox" name="amenities" value="gym">
                        <i class="fas fa-dumbbell"></i> 피트니스센터
                    </label>
                    <label>
                        <input type="checkbox" name="amenities" value="restaurant">
                        <i class="fas fa-utensils"></i> 레스토랑
                    </label>
                    <label>
                        <input type="checkbox" name="amenities" value="spa">
                        <i class="fas fa-spa"></i> 스파
                    </label>
                </div>
            </div>

            <div class="filter-section">
                <h3>호텔 타입</h3>
                <div class="checkbox-group">
                    <label>
                        <input type="checkbox" name="type" value="luxury">
                        럭셔리 호텔
                    </label>
                    <label>
                        <input type="checkbox" name="type" value="business">
                        비즈니스 호텔
                    </label>
                    <label>
                        <input type="checkbox" name="type" value="resort">
                        리조트
                    </label>
                    <label>
                        <input type="checkbox" name="type" value="boutique">
                        부티크 호텔
                    </label>
                </div>
            </div>
        </aside>

        <!-- Hotels List -->
        <main class="hotels-container">
            <div class="results-header">
                <div class="results-info">
                    <span>24</span>개의 호텔을 찾았습니다
                </div>
                <div class="sort-options">
                    <select id="sortBy">
                        <option value="recommended">추천순</option>
                        <option value="price-low">가격 낮은 순</option>
                        <option value="price-high">가격 높은 순</option>
                        <option value="rating">평점순</option>
                        <option value="distance">거리순</option>
                    </select>
                </div>
            </div>
		<%if(list != null){ %>
        	<%for(PostVO p : list){ %>
            <div class="hotels-grid">
                <!-- Hotel Card 1 -->
	   			<form action="reservations.jsp?postid=<%=p.getPostId() %>" method="get">
	                <div class="hotel-card">
	                    <div class="hotel-card-content">
	                        <div class="hotel-image">
	                        <%if(p.getFileName() != null){ %>
	                            <img src="img/<%=p.getFileName()[0] %>" alt="호텔이미지가 존재 하지않습니다">
	                            <input type="hidden" name="membernum" value="<%=p.getMemberNum()%>">
	                            <div class="image-gallery">
	                                <i class="fas fa-images"></i> <%=p.getFileName().length %>장
	                            </div>
	                         <%} %>
	                        </div>
	                        <div class="hotel-info">
	                            <div class="hotel-header">
	                                <div>
	                                	<input type="hidden" name="postid" value="<%=p.getPostId()%>">
	                                    <h3 class="hotel-name"><%=p.getTitle() %></h3>
	                                    <div class="hotel-rating">
	                                        <span class="rating-stars">★★★★★</span>
	                                        <span class="rating-score">9.2</span>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="hotel-location">
	                                <i class="fas fa-map-marker-alt"></i>
	                                <%=p.getAddress() %>
	                            </div>
	              		<%if(facility != null){ %>
	              			<%for(PostVO s : facility){ %>
	              				<%if(s.getParentId() == p.getPostId()){ %>
	                            <div class="hotel-amenities">
	                             	<span class="amenity-tag"><%=s.getTitle() %></span>						
	                            </div>
	                            <%} %>
	                         <%} %>
						<%} %>
	                            <p class="hotel-description">
	                                                        
	                                <%= p.getContent() %>
	                            </p>
	                        </div>
	                        <div class="hotel-pricing">
	                        	<input type="submit" class="book-btn" value="예약하기">
	                        </div>
	                      
	                    </div>
	                </div>
				</form>
			</div>
			<%} %>
		<%} %>
            <!-- Pagination -->
            <div class="pagination">
            	<!-- 시작페이지 1페이지 이동 -->
				<% if(pm.isFirst()) {%>
				<a href="?page=1">처음</i></a>
				<%} %>
			<!-- 이전 페이지 이동 -->
			<%if(pm.isPrev()){ %>
				<a href="?page=<%=pm.getStartPage() - 1%>"><i class="fas fa-chevron-left"></i></a>
			<%} %>
		
			<% for(int i = pm.getStartPage(); i <= pm.getEndPage(); i++){ %>
				<a href="?page=<%=i%>" <%= cri.getPage() == i ? "class='active'" : "" %> ><%=i%></a>
			<%} %>
			
			<!-- 다음 페이지  -->
			<% if(pm.isNext()){ %>
				<a href="?page=<%=pm.getEndPage() + 1%>"><i class="fas fa-chevron-right"></i></a>
			<% } %>
			<!-- 마지막 페이지 -->
			<% if(pm.isLast()){%>
			<%-- <a href="?page=<%=pm.getMaxPage()%>">[마지막]</a>	 --%>
			<a href="?page=<%=pm.getMaxPage()%>">[마지막]</a>
			<%} %>
            </div>
        </main>
    </div>
</body>
</html>
