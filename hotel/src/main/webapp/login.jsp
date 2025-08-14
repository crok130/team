<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - Hotel Booking</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        /* Header Styles */
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
            align-items: center;
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

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #2c5aa0;
            font-weight: 600;
        }

        .user-info i {
            font-size: 1.2rem;
        }

        .user-dropdown {
            position: relative;
            display: inline-block;
        }

        .user-dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 6px;
            margin-top: 0.5rem;
        }

        .user-dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            transition: background-color 0.3s;
        }

        .user-dropdown-content a:hover {
            background-color: #f1f1f1;
            color: #2c5aa0;
        }

        .user-dropdown:hover .user-dropdown-content {
            display: block;
        }

        /* 로그아웃 버튼이 더 오래 보이도록 수정 */
        .user-dropdown-content:hover {
            display: block !important;
            opacity: 1;
            visibility: visible;
        }

        /* Main Content Styles */
        .main-content {
            padding-top: 70px; /* Header height */
            min-height: calc(100vh - 70px);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
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
            z-index: 999;
        }

        .back-to-main:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            width: 100%;
            max-width: 900px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 500px;
        }

        .login-form-section {
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-image-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            padding: 3rem;
        }

        .welcome-content h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .welcome-content p {
            font-size: 1.1rem;
            opacity: 0.9;
            line-height: 1.6;
        }

        .form-title {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-title h1 {
            font-size: 2rem;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .form-title p {
            color: #666;
            font-size: 0.95rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .input-container {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            color: #666;
            font-size: 1rem;
        }

        .form-group input {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
            background: #f8f9fa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            font-size: 0.9rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #666;
            cursor: pointer;
        }

        .remember-me input[type="checkbox"] {
            width: auto;
            margin: 0;
        }

        .forgot-password {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        .btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 1rem;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        .register-link {
            text-align: center;
            margin-top: 1.5rem;
            color: #666;
            font-size: 0.9rem;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            border-left: 4px solid #c62828;
        }

        .error-message i {
            margin-right: 0.5rem;
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
            
            .login-container {
                grid-template-columns: 1fr;
            }
            
            .login-image-section {
                display: none;
            }
            
            .login-form-section {
                padding: 2rem;
            }
            
            .back-to-main {
                top: 1rem;
                left: 1rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="common/header.jsp" />

    <a href="index.jsp" class="back-to-main">
        <i class="fas fa-arrow-left"></i> 메인으로 돌아가기
    </a>

    <div class="main-content">
        <div class="login-container">
            <div class="login-form-section">
                <div class="form-title">
                    <h1>로그인</h1>
                    <p>호텔 예약 서비스에 오신 것을 환영합니다</p>
                </div>

                <!-- 에러 메시지 표시 -->
                <% 
                String msg = (String) request.getAttribute("msg");
                if (msg == null) {
                    String msgParam = request.getParameter("msg");
                    if ("rejected".equals(msgParam)) {
                        msg = "승인 거절되었습니다. 관리자에게 문의하세요.";
                    } else if ("pending".equals(msgParam)) {
                        msg = "계정이 승인 대기 중입니다. 관리자 승인 후 로그인 가능합니다.";
                    }
                }
                %>
                <% if (msg != null) { %>
                    <div class="error-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <%= msg %>
                    </div>
                <% } %>

                <form action="user-login" method="POST">
                    <div class="form-group">
                        <label for="username">아이디</label>
                        <div class="input-container">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" 
                                   value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">비밀번호</label>
                        <div class="input-container">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
                        </div>
                    </div>

                    <div class="form-options">
                        <label class="remember-me">
                            <input type="checkbox" name="remember" id="remember" 
                                   <%= "checked".equals(request.getAttribute("remember")) ? "checked" : "" %>>
                            로그인 상태 유지
                        </label>
                        <a href="find-password" class="forgot-password">비밀번호 찾기</a>
                    </div>

                    <button type="submit" class="btn">로그인</button>
                </form>

                <!-- 소셜 로그인 구분선 -->
                <div style="text-align: center; margin: 1.5rem 0;">
                    <div style="display: flex; align-items: center; justify-content: center; gap: 1rem;">
                        <div style="flex: 1; height: 1px; background-color: #ddd;"></div>
                        <span style="color: #666; font-size: 0.9rem;">또는</span>
                        <div style="flex: 1; height: 1px; background-color: #ddd;"></div>
                    </div>
                </div>

                <!-- 카카오 로그인 버튼 -->
                <button type="button" id="kakaoLoginBtn" class="btn" style="background-color: #FEE500; color: #000000; border: 2px solid #FEE500;" onclick="KakaoLogin.login()">
                    <i class="fas fa-comment" style="margin-right: 8px;"></i>
                    카카오로 로그인
                </button>

                <div class="register-link">
                    아직 계정이 없으신가요? <a href="register.jsp">회원가입</a>
                </div>
            </div>

            <div class="login-image-section">
                <div class="welcome-content">
                    <h2>환영합니다!</h2>
                    <p>세계 최고의 호텔 예약 서비스와 함께<br>특별한 여행을 시작하세요</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 페이지 로드 시 자동 로그인 시도
        window.onload = function() {
            const cookies = document.cookie.split(';');
            let hasAutoLoginCookies = false;
            
            for (let cookie of cookies) {
                const [name, value] = cookie.trim().split('=');
                if (name === 'autoLogin_username' || name === 'autoLogin_userType' || name === 'autoLogin_memberNum') {
                    hasAutoLoginCookies = true;
                    break;
                }
            }
            
            if (hasAutoLoginCookies) {
                // 자동 로그인 시도
                fetch('user-login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'autoLogin=true'
                })
                .then(response => {
                    if (response.redirected) {
                        window.location.href = response.url;
                    } else {
                        // 자동 로그인 실패 시 쿠키 삭제
                        deleteAutoLoginCookies();
                    }
                })
                .catch(error => {
                    console.error('Auto login error:', error);
                    // 에러 시 쿠키 삭제
                    deleteAutoLoginCookies();
                });
            }
        };
        
        // 자동 로그인 쿠키 삭제 함수
        function deleteAutoLoginCookies() {
            const cookieNames = ['autoLogin_username', 'autoLogin_userType', 'autoLogin_memberNum'];
            cookieNames.forEach(name => {
                document.cookie = name + '=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
            });
        }
    </script>

    <jsp:include page="common/footer.jsp" />
</body>
</html> 