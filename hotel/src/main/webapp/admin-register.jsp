<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>호텔 매니저 회원가입 - Hotel Booking System</title>
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
            padding: 2rem 0;
        }

        .register-container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .register-header {
            background: linear-gradient(135deg, #2c5aa0, #1e3f73);
            color: white;
            padding: 2rem;
            text-align: center;
        }

        .register-icon {
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

        .register-header h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }

        .register-header p {
            opacity: 0.9;
        }

        .register-form {
            padding: 2rem;
        }

        .user-type-selector {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1rem;
            margin-bottom: 2rem;
        }



        .user-type-option input[type="radio"]:checked ~ label {
            border-color: #2c5aa0;
            background: #f0f8ff;
            color: #2c5aa0;
        }

        .user-type-option input[type="radio"]:checked ~ label .type-icon {
            background: #2c5aa0;
            color: white;
        }

        .user-type-option input[type="radio"]:checked ~ label .type-content p {
            color: #2c5aa0;
        }

        .user-type-option input[type="radio"] {
            display: none;
        }

        .user-type-option label {
            padding: 1.5rem;
            border: 2px solid #ddd;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
            display: flex;
            align-items: center;
            gap: 1rem;
            width: 100%;
        }

        .user-type-option label:hover {
            border-color: #2c5aa0;
            background: #f0f8ff;
        }

        .type-icon {
            width: 50px;
            height: 50px;
            background: #f8f9fa;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: #666;
        }

        .type-content h3 {
            margin-bottom: 0.5rem;
            font-size: 1.2rem;
        }

        .type-content p {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.4;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 500;
        }

        .required::after {
            content: ' *';
            color: #e74c3c;
        }

        .input-container {
            position: relative;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 1rem 1rem 1rem 3rem;
            border: 2px solid #ddd;
            border-radius: 10px;
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

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .hotel-info-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }

        .section-title {
            color: #2c5aa0;
            margin-bottom: 1rem;
            font-size: 1.1rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin: 0.5rem 0;
        }

        .btn-primary {
            background: #2c5aa0;
            color: white;
            width: 100%;
        }

        .btn-primary:hover {
            background: #1e3f73;
        }

        .terms-agreement {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .checkbox-group {
            margin: 1rem 0;
        }

        .checkbox-group label {
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
            font-weight: normal;
            cursor: pointer;
        }

        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin-top: 0.25rem;
        }

        .login-link {
            text-align: center;
            margin-top: 1rem;
            color: #666;
        }

        .login-link a {
            color: #2c5aa0;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
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

        .approval-notice {
            background: #e3f2fd;
            border: 1px solid #bbdefb;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            color: #1976d2;
        }

        .approval-notice i {
            margin-right: 0.5rem;
        }

        @media (max-width: 768px) {
            .register-container {
                margin: 0 1rem;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-group.full-width {
                grid-column: span 1;
            }
            
            .register-form {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <a href="index.jsp" class="back-to-main">
        <i class="fas fa-arrow-left"></i> 메인으로 돌아가기
    </a>

    <div class="register-container">
        <div class="register-header">
            <div class="register-icon">
                <i class="fas fa-hotel"></i>
            </div>
            <h1>호텔 매니저 회원가입</h1>
            <p>호텔 매니저 계정을 신청하세요</p>
        </div>

        <div class="register-form">
            <div class="approval-notice">
                <i class="fas fa-info-circle"></i>
                <strong>승인 안내:</strong> 호텔 매니저 계정은 시스템 관리자 승인 후 사용 가능합니다. 신청 후 1-2일 내에 승인 결과를 알려드립니다.
            </div>

            <form action="#" method="POST">
                <!-- Hidden User Type (Hotel Manager Only) -->
                <input type="hidden" name="userType" value="HOTEL_MANAGER">

                <!-- Basic Information -->
                <div class="section-title">
                    <i class="fas fa-user"></i> 기본 정보
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="username" class="required">사용자명</label>
                        <div class="input-container">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" id="username" name="username" placeholder="사용자명을 입력하세요" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="name" class="required">실명</label>
                        <div class="input-container">
                            <i class="fas fa-id-card input-icon"></i>
                            <input type="text" id="name" name="name" placeholder="실명을 입력하세요" required>
                        </div>
                    </div>
                </div>



                <div class="form-row">
                    <div class="form-group">
                        <label for="password" class="required">비밀번호</label>
                        <div class="input-container">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="password" name="password" placeholder="8자 이상, 영문+숫자+특수문자" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword" class="required">비밀번호 확인</label>
                        <div class="input-container">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호를 다시 입력하세요" required>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">전화번호</label>
                        <div class="input-container">
                            <i class="fas fa-phone input-icon"></i>
                            <input type="tel" id="phone" name="phone" placeholder="010-1234-5678">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="birthDate">생년월일</label>
                        <div class="input-container">
                            <i class="fas fa-calendar input-icon"></i>
                            <input type="date" id="birthDate" name="birthDate">
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="gender">성별</label>
                        <div class="input-container">
                            <i class="fas fa-venus-mars input-icon"></i>
                            <select id="gender" name="gender">
                                <option value="">선택하세요</option>
                                <option value="M">남성</option>
                                <option value="F">여성</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <!-- 빈 공간 -->
                    </div>
                </div>



                <div class="terms-agreement">
                    <h4>이용약관 및 개인정보처리방침</h4>
                    <div class="checkbox-group">
                        <label>
                            <input type="checkbox" id="agreeAll">
                            <span>모두 동의합니다</span>
                        </label>
                    </div>
                    <div class="checkbox-group">
                        <label>
                            <input type="checkbox" id="agreeTerms" name="agreeTerms" required>
                            <span>(필수) 서비스 이용약관에 동의합니다</span>
                        </label>
                    </div>
                    <div class="checkbox-group">
                        <label>
                            <input type="checkbox" id="agreePrivacy" name="agreePrivacy" required>
                            <span>(필수) 개인정보처리방침에 동의합니다</span>
                        </label>
                    </div>

                    <div class="checkbox-group">
                        <label>
                            <input type="checkbox" id="agreeMarketing" name="agreeMarketing">
                            <span>(선택) 마케팅 정보 수신에 동의합니다</span>
                        </label>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-user-plus"></i> 호텔 매니저 계정 신청
                </button>
            </form>

            <div class="login-link">
                이미 계정이 있으신가요? <a href="admin-login.jsp">호텔 매니저 로그인</a>
            </div>

            <div class="login-link" style="margin-top: 1rem;">
                일반 회원으로 가입하시려면? <a href="register.jsp">일반 회원가입</a>
            </div>
        </div>
    </div>
</body>
</html> 