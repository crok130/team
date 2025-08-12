<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 로그인 - Hotel Booking System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
            padding: 2rem;
        }

        .admin-login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            width: 100%;
            max-width: 450px;
            position: relative;
        }

        .admin-header {
            background: linear-gradient(135deg, #2c5aa0, #1e3f73);
            color: white;
            padding: 2rem;
            text-align: center;
            position: relative;
        }

        .admin-icon {
            width: 60px;
            height: 60px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.8rem;
        }

        .admin-header h1 {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
        }

        .admin-header p {
            opacity: 0.9;
            font-size: 0.95rem;
        }

        .login-form-section {
            padding: 2.5rem;
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

        .input-container {
            position: relative;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2c5aa0;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .form-options {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .remember-me input[type="checkbox"] {
            width: auto;
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
            padding: 1rem;
            background: #2c5aa0;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            margin-bottom: 1rem;
        }

        .btn:hover {
            background: #1e3f73;
        }

        .divider {
            text-align: center;
            margin: 1.5rem 0;
            position: relative;
            color: #999;
        }

        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #ddd;
        }

        .divider span {
            background: white;
            padding: 0 1rem;
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

        .back-to-main {
            position: absolute;
            top: 2rem;
            left: 2rem;
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s;
            backdrop-filter: blur(10px);
        }

        .back-to-main:hover {
            background: rgba(255,255,255,0.3);
            color: white;
        }

        /* Security Notice */
        .security-notice {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        .security-notice i {
            color: #856404;
            margin-right: 0.5rem;
        }

        .security-notice p {
            color: #856404;
            font-size: 0.9rem;
            margin: 0;
        }

        /* Message Styles */
        .message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message i {
            margin-right: 0.5rem;
        }

        @media (max-width: 768px) {
            .admin-login-container {
                margin: 0 1rem;
            }
            
            .login-form-section {
                padding: 2rem;
            }
        }
    </style>
</head>
<body>
    <a href="index.jsp" class="back-to-main">
        <i class="fas fa-arrow-left"></i> 메인으로 돌아가기
    </a>

    <div class="admin-login-container">
        <div class="admin-header">
            <div class="admin-icon">
                <i class="fas fa-user-shield"></i>
            </div>
            <h1>관리자 로그인</h1>
            <p>시스템 관리를 위한 로그인</p>
        </div>

        <div class="login-form-section">
            <% if(request.getAttribute("msg") != null) { %>
                <% 
                String msg = (String) request.getAttribute("msg");
                String messageClass = msg.contains("오류") || msg.contains("실패") || msg.contains("잘못") || 
                                   msg.contains("거절") || msg.contains("대기") ? "error" : "success";
                String iconClass = msg.contains("오류") || msg.contains("실패") || msg.contains("잘못") || 
                                 msg.contains("거절") || msg.contains("대기") ? "exclamation-triangle" : "check-circle";
                %>
                <div class="message <%= messageClass %>">
                    <i class="fas fa-<%= iconClass %>"></i>
                    <%= msg %>
                </div>
            <% } %>
            
            <div class="security-notice">
                <i class="fas fa-shield-alt"></i>
                <p>관리자 계정은 보안상 중요한 계정입니다. 안전한 장소에서 로그인해주세요.</p>
            </div>

            <form action="admin-login" method="POST">
                <div class="form-group">
                    <label for="username">아이디</label>
                    <div class="input-container">
                        <i class="fas fa-user input-icon"></i>
                        <input type="text" id="username" name="username" 
                               placeholder="아이디를 입력하세요" 
                               required 
                               value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">비밀번호</label>
                    <div class="input-container">
                        <i class="fas fa-lock input-icon"></i>
                        <input type="password" id="password" name="password" 
                               placeholder="비밀번호를 입력하세요" 
                               required>
                    </div>
                </div>

                <div class="form-options">
                    <a href="#" class="forgot-password">비밀번호 찾기</a>
                </div>

                <button type="submit" class="btn">
                    <i class="fas fa-sign-in-alt"></i> 관리자 로그인
                </button>
            </form>

            <div class="divider">
                <span>또는</span>
            </div>

            <div class="register-link">
                호텔 매니저 계정이 없으신가요? <a href="admin-register.jsp">관리자 회원가입</a>
            </div>

            <div class="register-link" style="margin-top: 1rem;">
                일반 사용자이신가요? <a href="login.jsp">일반 로그인</a>
            </div>
        </div>
    </div>
</body>
</html> 