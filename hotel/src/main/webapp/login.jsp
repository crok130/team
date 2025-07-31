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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
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
            margin: 2rem;
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
            font-size: 1rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #333;
        }

        .input-container {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 3rem;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #2c5aa0;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #666;
            cursor: pointer;
        }

        .forgot-password {
            color: #2c5aa0;
            text-decoration: none;
            font-size: 0.9rem;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        .btn {
            width: 100%;
            padding: 0.75rem;
            background: #2c5aa0;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 1.5rem;
        }

        .btn:hover {
            background: #1e3d6f;
            transform: translateY(-2px);
        }

        .register-link {
            text-align: center;
            color: #666;
        }

        .register-link a {
            color: #2c5aa0;
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .login-container {
                grid-template-columns: 1fr;
                margin: 1rem;
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
    <a href="index.jsp" class="back-to-main">
        <i class="fas fa-arrow-left"></i> 메인으로 돌아가기
    </a>

    <div class="login-container">
        <div class="login-form-section">
            <div class="form-title">
                <h1>로그인</h1>
                <p>호텔 예약 서비스에 오신 것을 환영합니다</p>
            </div>

            <form action="#" method="POST">
                <div class="form-group">
                    <label for="email">이메일</label>
                    <div class="input-container">
                        <i class="fas fa-envelope input-icon"></i>
                        <input type="email" id="email" name="email" placeholder="이메일을 입력하세요" required>
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
                        <input type="checkbox" name="remember" id="remember">
                        로그인 상태 유지
                    </label>
                    <a href="#" class="forgot-password">비밀번호 찾기</a>
                </div>

                <button type="submit" class="btn">로그인</button>
            </form>

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
</body>
</html> 