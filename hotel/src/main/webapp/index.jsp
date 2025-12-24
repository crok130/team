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

        /* Header Styles */
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

        /* Footer Styles */
        .footer {
            background: #2c3e50;
            color: white;
            padding: 3rem 0 1rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-section h3 {
            margin-bottom: 1rem;
            color: #ecf0f1;
        }

        .footer-section a {
            display: block;
            color: #bdc3c7;
            text-decoration: none;
            margin-bottom: 0.5rem;
            transition: color 0.3s;
        }

        .footer-section a:hover {
            color: #ecf0f1;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            border-top: 1px solid #34495e;
            color: #bdc3c7;
        }

        /* 반응형 디자인 */
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
    <jsp:include page="common/header.jsp" />

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

    <jsp:include page="common/footer.jsp" />
    
    <script>
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