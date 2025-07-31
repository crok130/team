<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - Hotel Booking System</title>
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
            max-width: 600px;
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

        .btn {
            width: 100%;
            padding: 1rem;
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
        }

        .btn-primary:hover {
            background: #1e3f73;
        }

        .btn-verify {
            background: #28a745;
            color: white;
            width: 100%;
            height: 48px;
        }

        .btn-verify:hover {
            background: #218838;
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
            <h1><i class="fas fa-hotel"></i> Hotel Booking</h1>
            <p>새 계정을 만들어 특별한 여행을 시작하세요</p>
        </div>

        <div class="register-form">
            <form action="#" method="POST">
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

                <div class="form-group full-width">
                        <label for="email" class="required">이메일</label>
                        <div class="input-container">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" id="email" name="email" placeholder="이메일을 입력하세요" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="emailVerification" class="required">이메일 인증번호</label>
                            <div class="input-container">
                                <i class="fas fa-key input-icon"></i>
                                <input type="text" id="emailVerification" name="emailVerification" placeholder="인증번호를 입력하세요" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button type="button" class="btn btn-verify" onclick="verifyEmail()">
                                <i class="fas fa-check"></i> 인증 확인
                            </button>
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
                            <label for="userType" class="required">회원 유형</label>
                            <div class="input-container">
                                <i class="fas fa-user input-icon"></i>
                                <select id="userType" name="userType" required>
                                    <option value="USER" selected>일반 회원</option>
                                </select>
                            </div>
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
                                <span>(필수) 이용약관에 동의합니다</span>
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

                <button type="submit" class="btn btn-primary">회원가입</button>
            </form>

            <div class="login-link">
                이미 계정이 있으신가요? <a href="login.jsp">로그인</a>
            </div>


        </div>
    </div>

    <script>
        function verifyEmail() {
            const emailInput = document.getElementById('email');
            const verificationInput = document.getElementById('emailVerification');
            const verifyBtn = document.querySelector('.btn-verify');
            
            if (!emailInput.value) {
                alert('이메일을 먼저 입력해주세요.');
                emailInput.focus();
                return;
            }
            
            if (!verificationInput.value) {
                alert('인증번호를 입력해주세요.');
                verificationInput.focus();
                return;
            }
            
            // 임시 인증 로직 (실제로는 서버와 통신)
            verifyBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 확인 중...';
            verifyBtn.disabled = true;
            
            setTimeout(() => {
                // 임시로 "123456"을 올바른 인증번호로 설정
                if (verificationInput.value === '123456') {
                    verifyBtn.innerHTML = '<i class="fas fa-check"></i> 인증 완료';
                    verifyBtn.style.background = '#28a745';
                    verificationInput.style.borderColor = '#28a745';
                    verificationInput.disabled = true;
                    alert('이메일 인증이 완료되었습니다.');
                } else {
                    verifyBtn.innerHTML = '<i class="fas fa-times"></i> 인증 실패';
                    verifyBtn.style.background = '#dc3545';
                    verificationInput.style.borderColor = '#dc3545';
                    alert('인증번호가 올바르지 않습니다. 다시 확인해주세요.');
                    setTimeout(() => {
                        verifyBtn.innerHTML = '<i class="fas fa-check"></i> 인증 확인';
                        verifyBtn.style.background = '#28a745';
                        verifyBtn.disabled = false;
                    }, 2000);
                }
            }, 1500);
        }
        
        // 전체 동의 체크박스
        document.getElementById('agreeAll').addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('input[type="checkbox"]:not(#agreeAll)');
            checkboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });
    </script>
</body>
</html> 