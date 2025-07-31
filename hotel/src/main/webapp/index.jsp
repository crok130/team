<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Booking - 최고의 호텔 예약 서비스</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
        }

        .header {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
        }

        .logo {
            font-size: 1.8rem;
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

        .nav-menu a:hover {
            color: #2c5aa0;
        }

        .auth-buttons {
            display: flex;
            gap: 1rem;
        }

        .btn {
            padding: 0.6rem 1.5rem;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            cursor: pointer;
        }

        .btn-outline {
            background: transparent;
            color: #2c5aa0;
            border: 2px solid #2c5aa0;
        }

        .btn-outline:hover {
            background: #2c5aa0;
            color: white;
        }

        .btn-primary {
            background: #2c5aa0;
            color: white;
        }

        .btn-primary:hover {
            background: #1e3d6f;
            transform: translateY(-2px);
        }

        .logout-btn {
            background: #dc3545;
            color: white !important;
            border-color: #dc3545;
        }

        .logout-btn:hover {
            background: #c82333 !important;
            border-color: #c82333;
            color: white !important;
        }
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            text-align: center;
            color: white;
            position: relative;
        }

        .hero-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .hero h1 {
            font-size: 4rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .hero p {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .search-form {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto 3rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 2fr 2fr 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #333;
        }

        .form-group input,
        .form-group select {
            padding: 0.75rem;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2c5aa0;
        }

        .search-btn {
            background: #2c5aa0;
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            width: 100%;
        }

        .search-btn:hover {
            background: #1e3d6f;
            transform: translateY(-2px);
        }

        /* Features Section */
        .features {
            padding: 5rem 0;
            background: #f8f9fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .section-title {
            text-align: center;
            margin-bottom: 3rem;
        }

        .section-title h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: #333;
        }

        .section-title p {
            font-size: 1.1rem;
            color: #666;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-10px);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 2rem;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: #333;
        }

        .feature-card p {
            color: #666;
            line-height: 1.6;
        }

        /* Popular Hotels */
        .popular-hotels {
            padding: 5rem 0;
            background: white;
        }

        .hotels-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .hotel-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .hotel-card:hover {
            transform: translateY(-5px);
        }

        .hotel-image {
            height: 200px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }

        .hotel-info {
            padding: 1.5rem;
        }

        .hotel-name {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #333;
        }

        .hotel-location {
            color: #666;
            margin-bottom: 1rem;
        }

        .hotel-rating {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }

        .stars {
            color: #ffd700;
        }

        .rating-score {
            font-weight: 600;
            color: #333;
        }

        .hotel-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c5aa0;
        }

        /* Footer */
        .footer {
            background: #333;
            color: white;
            padding: 3rem 0;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .footer-section h3 {
            margin-bottom: 1rem;
            color: #2c5aa0;
        }

        .footer-section p,
        .footer-section a {
            color: #ccc;
            text-decoration: none;
            margin-bottom: 0.5rem;
            display: block;
        }

        .footer-section a:hover {
            color: white;
        }

        .footer-bottom {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #555;
            color: #999;
        }

        @media (max-width: 768px) {
            .nav-container {
                padding: 0 1rem;
            }
            
            .nav-menu {
                display: none;
            }
            
            .hero h1 {
                font-size: 2.5rem;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .features-grid,
            .hotels-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <div class="logo">
                <i class="fas fa-hotel"></i> Hotel Booking
            </div>
            <nav class="nav-menu">
                <a href="index.jsp">홈</a>
                <a href="hotels.jsp">호텔</a>
                <a href="reservations.jsp">예약</a>
                <a href="#contact">문의</a>
            </nav>
            <div class="auth-buttons">
                <a href="login.jsp" class="btn btn-outline">로그인</a>
                <a href="register.jsp" class="btn btn-primary">회원가입</a>
                <a href="logout.jsp" class="btn btn-outline logout-btn">
                    <i class="fas fa-sign-out-alt"></i> 로그아웃
                </a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1><i class="fas fa-hotel"></i> 완벽한 호텔을 찾아보세요</h1>
            <p>전 세계 최고의 호텔에서 특별한 경험을 시작하세요</p>
            
            <div class="search-form">
                <form action="hotels.jsp" method="GET">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="destination">목적지</label>
                            <input type="text" id="destination" name="destination" placeholder="도시, 호텔명 입력">
                        </div>
                        <div class="form-group">
                            <label for="checkIn">체크인</label>
                            <input type="date" id="checkIn" name="checkIn">
                        </div>
                        <div class="form-group">
                            <label for="checkOut">체크아웃</label>
                            <input type="date" id="checkOut" name="checkOut">
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
                    </div>
                    <button type="submit" class="search-btn">
                        <i class="fas fa-search"></i> 호텔 검색
                    </button>
                </form>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="container">
            <div class="section-title">
                <h2>왜 저희를 선택해야 할까요?</h2>
                <p>최고의 서비스와 편의를 제공합니다</p>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3>쉬운 검색</h3>
                    <p>직관적인 검색 시스템으로 원하는 호텔을 빠르게 찾을 수 있습니다.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <h3>안전한 결제</h3>
                    <p>SSL 보안 인증서로 안전하고 신뢰할 수 있는 결제 시스템을 제공합니다.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3>24시간 고객지원</h3>
                    <p>언제든지 도움이 필요하시면 24시간 고객지원팀이 도와드립니다.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>베스트 프라이스</h3>
                    <p>최저가 보장으로 가장 합리적인 가격에 호텔을 예약하세요.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Popular Hotels -->
    <section class="popular-hotels">
        <div class="container">
            <div class="section-title">
                <h2>인기 호텔</h2>
                <p>많은 분들이 선택한 인기 호텔들을 만나보세요</p>
            </div>
            <div class="hotels-grid">
                <div class="hotel-card">
                    <div class="hotel-image">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="hotel-info">
                        <div class="hotel-name">서울 그랜드 호텔</div>
                        <div class="hotel-location">서울특별시 중구</div>
                        <div class="hotel-rating">
                            <div class="stars">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                            <span class="rating-score">4.8</span>
                        </div>
                        <div class="hotel-price">₩120,000 / 박</div>
                    </div>
                </div>
                <div class="hotel-card">
                    <div class="hotel-image">
                        <i class="fas fa-umbrella-beach"></i>
                    </div>
                    <div class="hotel-info">
                        <div class="hotel-name">부산 오션뷰 리조트</div>
                        <div class="hotel-location">부산광역시 해운대구</div>
                        <div class="hotel-rating">
                            <div class="stars">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                            </div>
                            <span class="rating-score">4.6</span>
                        </div>
                        <div class="hotel-price">₩95,000 / 박</div>
                    </div>
                </div>
                <div class="hotel-card">
                    <div class="hotel-image">
                        <i class="fas fa-mountain"></i>
                    </div>
                    <div class="hotel-info">
                        <div class="hotel-name">제주 자연 펜션</div>
                        <div class="hotel-location">제주특별자치도 서귀포시</div>
                        <div class="hotel-rating">
                            <div class="stars">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                            <span class="rating-score">4.9</span>
                        </div>
                        <div class="hotel-price">₩80,000 / 박</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>고객 서비스</h3>
                    <a href="#">도움말 센터</a>
                    <a href="#">예약 취소</a>
                    <a href="#">연락처</a>
                    <a href="#">FAQ</a>
                </div>
                <div class="footer-section">
                    <h3>회사 정보</h3>
                    <a href="#">회사 소개</a>
                    <a href="#">채용 정보</a>
                    <a href="#">이용약관</a>
                    <a href="#">개인정보처리방침</a>
                </div>
                <div class="footer-section">
                    <h3>파트너</h3>
                    <a href="#">호텔 등록</a>
                    <a href="#">파트너 센터</a>
                    <a href="#">제휴 문의</a>
                </div>
                <div class="footer-section">
                    <h3>소셜 미디어</h3>
                    <a href="#">페이스북</a>
                    <a href="#">인스타그램</a>
                    <a href="#">트위터</a>
                    <a href="#">유튜브</a>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 Hotel Booking. All rights reserved.</p>
            </div>
        </div>
    </footer>
</body>
</html> 