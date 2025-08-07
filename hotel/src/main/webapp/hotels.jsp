<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

            <div class="hotels-grid">
                <!-- Hotel Card 1 -->
                <div class="hotel-card">
                    <div class="hotel-card-content">
                        <div class="hotel-image">
                            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80" alt="서울 그랜드 호텔">
                            <div class="image-gallery">
                                <i class="fas fa-images"></i> 12장
                            </div>
                        </div>
                        <div class="hotel-info">
                            <div class="hotel-header">
                                <div>
                                    <h3 class="hotel-name">서울 그랜드 호텔</h3>
                                    <div class="hotel-rating">
                                        <span class="rating-stars">★★★★★</span>
                                        <span class="rating-score">9.2</span>
                                    </div>
                                </div>
                            </div>
                            <div class="hotel-location">
                                <i class="fas fa-map-marker-alt"></i>
                                서울시 중구 명동길 123
                            </div>
                            <div class="hotel-amenities">
                                <span class="amenity-tag">무료 Wi-Fi</span>
                                <span class="amenity-tag">수영장</span>
                                <span class="amenity-tag">주차장</span>
                                <span class="amenity-tag">피트니스</span>
                            </div>
                            <p class="hotel-description">
                                서울 중심가에 위치한 럭셔리 호텔입니다. 명동 쇼핑가와 가까우며 훌륭한 시설과 서비스를 제공합니다.
                            </p>
                        </div>
                        <div class="hotel-pricing">
                            <div class="price-info">
                                <div class="price-per-night">1박 기준</div>
                                <div class="price-amount">
                                    120,000<span class="price-currency">원</span>
                                </div>
                            </div>
                            <a href="reservations.jsp?hotel=1" class="book-btn">예약하기</a>
                        </div>
                    </div>
                </div>

                <!-- Hotel Card 2 -->
                <div class="hotel-card">
                    <div class="hotel-card-content">
                        <div class="hotel-image">
                            <img src="https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80" alt="부산 오션뷰 호텔">
                            <div class="image-gallery">
                                <i class="fas fa-images"></i> 8장
                            </div>
                        </div>
                        <div class="hotel-info">
                            <div class="hotel-header">
                                <div>
                                    <h3 class="hotel-name">부산 오션뷰 호텔</h3>
                                    <div class="hotel-rating">
                                        <span class="rating-stars">★★★★☆</span>
                                        <span class="rating-score">8.7</span>
                                    </div>
                                </div>
                            </div>
                            <div class="hotel-location">
                                <i class="fas fa-map-marker-alt"></i>
                                부산시 해운대구 해운대로 456
                            </div>
                            <div class="hotel-amenities">
                                <span class="amenity-tag">오션뷰</span>
                                <span class="amenity-tag">레스토랑</span>
                                <span class="amenity-tag">스파</span>
                                <span class="amenity-tag">발레파킹</span>
                            </div>
                            <p class="hotel-description">
                                해운대 해변이 바로 앞에 있는 오션뷰 호텔입니다. 모든 객실에서 아름다운 바다 전망을 감상하실 수 있습니다.
                            </p>
                        </div>
                        <div class="hotel-pricing">
                            <div class="price-info">
                                <div class="price-per-night">1박 기준</div>
                                <div class="price-amount">
                                    95,000<span class="price-currency">원</span>
                                </div>
                            </div>
                            <a href="reservations.jsp?hotel=2" class="book-btn">예약하기</a>
                        </div>
                    </div>
                </div>

                <!-- Hotel Card 3 -->
                <div class="hotel-card">
                    <div class="hotel-card-content">
                        <div class="hotel-image">
                            <img src="https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80" alt="제주 리조트">
                            <div class="image-gallery">
                                <i class="fas fa-images"></i> 15장
                            </div>
                        </div>
                        <div class="hotel-info">
                            <div class="hotel-header">
                                <div>
                                    <h3 class="hotel-name">제주 힐링 리조트</h3>
                                    <div class="hotel-rating">
                                        <span class="rating-stars">★★★★★</span>
                                        <span class="rating-score">9.5</span>
                                    </div>
                                </div>
                            </div>
                            <div class="hotel-location">
                                <i class="fas fa-map-marker-alt"></i>
                                제주시 애월읍 해안로 789
                            </div>
                            <div class="hotel-amenities">
                                <span class="amenity-tag">수영장</span>
                                <span class="amenity-tag">골프장</span>
                                <span class="amenity-tag">키즈클럽</span>
                                <span class="amenity-tag">조식포함</span>
                            </div>
                            <p class="hotel-description">
                                제주의 아름다운 자연 속에서 힐링할 수 있는 프리미엄 리조트입니다. 가족 단위 여행객에게 최적화된 시설을 제공합니다.
                            </p>
                        </div>
                        <div class="hotel-pricing">
                            <div class="price-info">
                                <div class="price-per-night">1박 기준</div>
                                <div class="price-amount">
                                    180,000<span class="price-currency">원</span>
                                </div>
                            </div>
                            <a href="reservations.jsp?hotel=3" class="book-btn">예약하기</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <a href="#"><i class="fas fa-chevron-left"></i></a>
                <a href="#" class="active">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">4</a>
                <a href="#">5</a>
                <a href="#"><i class="fas fa-chevron-right"></i></a>
            </div>
        </main>
    </div>
</body>
</html> 