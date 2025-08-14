<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 - Hotel Booking System</title>
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
            display: block;
        }

        /* Register Page Styles */
        body {
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

        .btn-send {
            background: #007bff;
            color: white;
            width: 100%;
            height: 48px;
        }

        .btn-send:hover {
            background: #0056b3;
        }

        .btn-send:disabled {
            background: #6c757d;
            cursor: not-allowed;
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

        .message {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }

        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .message i {
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
    <jsp:include page="common/header.jsp" />

    <a href="index.jsp" class="back-to-main">
        <i class="fas fa-arrow-left"></i> 메인으로 돌아가기
    </a>

    <div class="register-container">
        <div class="register-header">
            <h1><i class="fas fa-hotel"></i> Hotel Booking</h1>
            <p>새 계정을 만들어 특별한 여행을 시작하세요</p>
        </div>

        <div class="register-form">
            <% if(request.getAttribute("msg") != null) { %>
                <div class="message <%= request.getAttribute("msg").toString().contains("완료") ? "success" : "error" %>">
                    <i class="fas fa-<%= request.getAttribute("msg").toString().contains("완료") ? "check-circle" : "exclamation-triangle" %>"></i>
                    <%= request.getAttribute("msg") %>
                </div>
            <% } %>

            <form action="user-register" method="POST" onsubmit="return validateForm()">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="username" class="required">사용자명</label>
                            <div class="input-container">
                                <i class="fas fa-user input-icon"></i>
                                <input type="text" id="username" name="username" 
                                       placeholder="사용자명을 입력하세요" 
                                       required 
                                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="name" class="required">실명</label>
                            <div class="input-container">
                                <i class="fas fa-id-card input-icon"></i>
                                <input type="text" id="name" name="name" 
                                       placeholder="실명을 입력하세요" 
                                       required 
                                       value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>">
                            </div>
                        </div>
                    </div>

                <div class="form-group full-width">
                        <label for="email" class="required">이메일</label>
                        <div class="input-container">
                            <i class="fas fa-envelope input-icon"></i>
                            <input type="email" id="email" name="email" 
                                   placeholder="이메일을 입력하세요" 
                                   required 
                                   value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="emailVerification" class="required">이메일 인증번호</label>
                            <div class="input-container">
                                <i class="fas fa-key input-icon"></i>
                                <input type="text" id="emailVerification" name="emailVerification" 
                                       placeholder="인증번호를 입력하세요" 
                                       required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button type="button" class="btn btn-send" onclick="sendVerificationCode()" id="sendBtn">
                                <i class="fas fa-paper-plane"></i> 인증번호 발송
                            </button>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <button type="button" class="btn btn-verify" onclick="verifyEmail()" id="verifyBtn">
                                <i class="fas fa-check"></i> 인증번호 확인
                            </button>
                        </div>
                        <div class="form-group">
                            <label>&nbsp;</label>
                            <div id="verificationStatus" style="display: none; padding: 0.5rem; border-radius: 5px; font-size: 0.9rem;"></div>
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
                                <input type="tel" id="phone" name="phone" 
                                       placeholder="010-1234-5678"
                                       value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="birthDate">생년월일</label>
                            <div class="input-container">
                                <i class="fas fa-calendar input-icon"></i>
                                <input type="date" id="birthDate" name="birthDate"
                                       value="<%= request.getAttribute("birthDate") != null ? request.getAttribute("birthDate") : "" %>">
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
                                    <option value="M" <%= "M".equals(request.getAttribute("gender")) ? "selected" : "" %>>남성</option>
                                    <option value="F" <%= "F".equals(request.getAttribute("gender")) ? "selected" : "" %>>여성</option>
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
                                <input type="checkbox" id="agreeMarketing" name="agreeMarketing"
                                       <%= "checked".equals(request.getAttribute("agreeMarketing")) ? "checked" : "" %>>
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
        // 인증번호 발송
        function sendVerificationCode() {
            const emailInput = document.getElementById('email');
            const sendBtn = document.getElementById('sendBtn');
            
            if (!emailInput.value) {
                alert('이메일을 먼저 입력해주세요.');
                emailInput.focus();
                return;
            }
            
            // 이메일 형식 검증
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailInput.value)) {
                alert('올바른 이메일 형식을 입력해주세요.');
                emailInput.focus();
                return;
            }
            
            // 버튼 비활성화
            sendBtn.disabled = true;
            sendBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> 발송 중...';
            
            // AJAX 요청
            fetch('email-verification', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=send&email=' + encodeURIComponent(emailInput.value)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    sendBtn.innerHTML = '<i class="fas fa-check"></i> 발송 완료';
                    sendBtn.style.background = '#28a745';
                    alert(data.message);
                } else {
                    sendBtn.innerHTML = '<i class="fas fa-times"></i> 발송 실패';
                    sendBtn.style.background = '#dc3545';
                    alert(data.message);
                    setTimeout(() => {
                        sendBtn.innerHTML = '<i class="fas fa-paper-plane"></i> 인증번호 발송';
                        sendBtn.style.background = '#007bff';
                        sendBtn.disabled = false;
                    }, 2000);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                sendBtn.innerHTML = '<i class="fas fa-times"></i> 발송 실패';
                sendBtn.style.background = '#dc3545';
                alert('인증번호 발송에 실패했습니다.');
                setTimeout(() => {
                    sendBtn.innerHTML = '<i class="fas fa-paper-plane"></i> 인증번호 발송';
                    sendBtn.style.background = '#007bff';
                    sendBtn.disabled = false;
                }, 2000);
            });
        }
        
        // 인증번호 확인
        function verifyEmail() {
            const emailInput = document.getElementById('email');
            const verificationInput = document.getElementById('emailVerification');
            const verifyBtn = document.getElementById('verifyBtn');
            
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
            
            // AJAX 요청
            fetch('email-verification', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=verify&code=' + encodeURIComponent(verificationInput.value)
            })
            .then(response => response.json())
            .then(data => {
                const statusDiv = document.getElementById('verificationStatus');
                if (data.success) {
                    verifyBtn.innerHTML = '<i class="fas fa-check"></i> 인증 완료';
                    verifyBtn.style.background = '#28a745';
                    verifyBtn.disabled = true;
                    verificationInput.style.borderColor = '#28a745';
                    verificationInput.disabled = true;
                    
                    // 상태 메시지 표시
                    statusDiv.innerHTML = '<i class="fas fa-check-circle"></i> ' + data.message;
                    statusDiv.style.display = 'block';
                    statusDiv.style.background = '#d4edda';
                    statusDiv.style.color = '#155724';
                    statusDiv.style.border = '1px solid #c3e6cb';
                } else {
                    verifyBtn.innerHTML = '<i class="fas fa-times"></i> 인증 실패';
                    verifyBtn.style.background = '#dc3545';
                    verificationInput.style.borderColor = '#dc3545';
                    
                    // 상태 메시지 표시
                    statusDiv.innerHTML = '<i class="fas fa-exclamation-triangle"></i> ' + data.message;
                    statusDiv.style.display = 'block';
                    statusDiv.style.background = '#f8d7da';
                    statusDiv.style.color = '#721c24';
                    statusDiv.style.border = '1px solid #f5c6cb';
                    
                    setTimeout(() => {
                        verifyBtn.innerHTML = '<i class="fas fa-check"></i> 인증 확인';
                        verifyBtn.style.background = '#28a745';
                        verifyBtn.disabled = false;
                        statusDiv.style.display = 'none';
                    }, 3000);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                verifyBtn.innerHTML = '<i class="fas fa-times"></i> 인증 실패';
                verifyBtn.style.background = '#dc3545';
                
                const statusDiv = document.getElementById('verificationStatus');
                statusDiv.innerHTML = '<i class="fas fa-exclamation-triangle"></i> 인증번호 확인에 실패했습니다.';
                statusDiv.style.display = 'block';
                statusDiv.style.background = '#f8d7da';
                statusDiv.style.color = '#721c24';
                statusDiv.style.border = '1px solid #f5c6cb';
                
                setTimeout(() => {
                    verifyBtn.innerHTML = '<i class="fas fa-check"></i> 인증 확인';
                    verifyBtn.style.background = '#28a745';
                    verifyBtn.disabled = false;
                    statusDiv.style.display = 'none';
                }, 3000);
            });
        }
        
        // 폼 검증
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
            
            // 비밀번호 복잡도 검증
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
            if (!passwordRegex.test(password)) {
                alert('비밀번호는 8자 이상이며, 영문, 숫자, 특수문자를 포함해야 합니다.');
                return false;
            }
            
            return true;
        }
        
        // 전체 동의 체크박스
        document.getElementById('agreeAll').addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('input[type="checkbox"]:not(#agreeAll)');
            checkboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });
    </script>

    <jsp:include page="common/footer.jsp" />
</body>
</html> 