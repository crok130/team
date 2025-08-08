<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 포털 - Hotel Booking</title>
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
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .logo i {
            color: #dc3545;
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
            position: relative;
        }

        .nav-menu a:hover {
            color: #2c5aa0;
        }

        .nav-menu a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: #2c5aa0;
            transition: width 0.3s;
        }

        .nav-menu a:hover::after {
            width: 100%;
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
            font-weight: 600;
            padding: 0.6rem 1.2rem;
            border-radius: 6px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .logout-btn:hover {
            background: #c82333 !important;
            border-color: #c82333;
            color: white !important;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
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
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000"><polygon fill="%23ffffff" fill-opacity="0.1" points="0,1000 1000,0 1000,1000"/></svg>');
        }

        .hero-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            position: relative;
            z-index: 1;
        }

        .hero h1 {
            font-size: 4rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .hero h1 i {
            color: #ffd700;
            margin-right: 1rem;
        }

        .hero p {
            font-size: 1.3rem;
            margin-bottom: 2rem;
            opacity: 0.9;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .admin-features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 4rem;
        }

        .feature-card {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.3s;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            background: rgba(255,255,255,0.15);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #ffd700;
        }

        .feature-card h3 {
            font-size: 1.3rem;
            margin-bottom: 1rem;
        }

        .feature-card p {
            font-size: 0.95rem;
            opacity: 0.9;
        }

        /* Access Section */
        .access-section {
            background: white;
            padding: 5rem 0;
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
            max-width: 600px;
            margin: 0 auto;
        }

        .access-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .access-card {
            background: white;
            border-radius: 15px;
            padding: 2.5rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s;
            border: 2px solid transparent;
        }

        .access-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            border-color: #2c5aa0;
        }

        .access-card.admin {
            border-color: #dc3545;
        }

        .access-card.admin:hover {
            border-color: #dc3545;
        }

        .access-card.manager {
            border-color: #28a745;
        }

        .access-card.manager:hover {
            border-color: #28a745;
        }

        .access-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            color: white;
            font-size: 2rem;
        }

        .access-card.admin .access-icon {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
        }

        .access-card.manager .access-icon {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }

        .access-card h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: #333;
        }

        .access-card p {
            color: #666;
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .access-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .btn-admin {
            background: #dc3545;
            color: white;
        }

        .btn-admin:hover {
            background: #c82333;
        }

        .btn-manager {
            background: #28a745;
            color: white;
        }

        .btn-manager:hover {
            background: #20c997;
        }

        /* Footer */
        .footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 2rem 0;
        }

        .back-to-main {
            position: fixed;
            top: 2rem;
            left: 2rem;
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            backdrop-filter: blur(10px);
            transition: all 0.3s;
            z-index: 1001;
        }

        .back-to-main:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
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

            .admin-features {
                grid-template-columns: 1fr;
            }

            .access-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

    <!-- Header -->
    <header class="header">
        <div class="nav-container">
            <div class="logo">
                <i class="fas fa-shield-alt"></i> 관리자 포털
            </div>
            <nav class="nav-menu">
                <a href="admin-main.jsp">홈</a>
                <a href="#features">기능</a>
                <a href="#access">접근</a>
                <a href="#contact">지원</a>
            </nav>
            <div class="auth-buttons">
                <a href="admin-login.jsp" class="btn btn-outline">관리자 로그인</a>
                <a href="admin-register.jsp" class="btn btn-primary">매니저 가입</a>
                <a href="logout" class="btn btn-outline logout-btn">
                    <i class="fas fa-sign-out-alt"></i> 로그아웃
                </a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1><i class="fas fa-crown"></i>관리자 포털</h1>
            <p>호텔 예약 시스템의 관리와 운영을 위한 전용 포털입니다.<br>시스템 관리자와 호텔 매니저를 위한 통합 관리 환경을 제공합니다.</p>
            
            <div class="admin-features">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                    <h3>실시간 모니터링</h3>
                    <p>예약 현황, 매출 분석, 회원 통계를 실시간으로 확인</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-users-cog"></i>
                    </div>
                    <h3>회원 관리</h3>
                    <p>호텔 매니저 승인, 회원 정보 관리, 권한 설정</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-hotel"></i>
                    </div>
                    <h3>호텔 관리</h3>
                    <p>호텔 등록, 정보 수정, 이미지 관리, 편의시설 설정</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <h3>예약 시스템</h3>
                    <p>예약 현황 조회, 상태 관리, 고객 서비스</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Access Section -->
    <section class="access-section" id="access">
        <div class="container">
            <div class="section-title">
                <h2>시스템 접근</h2>
                <p>귀하의 역할에 맞는 관리 시스템에 접근하세요</p>
            </div>

            <div class="access-cards">
                <!-- 시스템 관리자 -->
                <div class="access-card admin">
                    <div class="access-icon">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <h3>시스템 관리자</h3>
                    <p>전체 시스템 관리, 회원 승인/거부, 통계 분석, 시스템 설정 등 모든 관리 기능에 접근할 수 있습니다.</p>
                    <div class="access-buttons">
                        <a href="admin-login.jsp" class="btn btn-admin">관리자 로그인</a>
                    </div>
                </div>

                <!-- 호텔 매니저 -->
                <div class="access-card manager">
                    <div class="access-icon">
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <h3>호텔 매니저</h3>
                    <p>호텔 등록 및 관리, 예약 현황 확인, 매출 분석 등 호텔 운영에 필요한 기능을 이용할 수 있습니다.</p>
                    <div class="access-buttons">
                        <a href="admin-login.jsp" class="btn btn-manager">매니저 로그인</a>
                        <a href="admin-register.jsp" class="btn btn-outline">매니저 가입</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2024 Hotel Booking Management Portal. All rights reserved.</p>
            <p>관리자 전용 포털 | 기술 지원: admin@hotelbooking.com</p>
        </div>
    </footer>
</body>
</html> 