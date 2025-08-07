<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
        
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            padding: 40px;
            width: 100%;
            max-width: 500px;
            margin: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #666;
            font-size: 16px;
        }
        
        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }
        
        .step {
            display: flex;
            align-items: center;
            margin: 0 10px;
        }
        
        .step-number {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e0e0e0;
            color: #666;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 8px;
        }
        
        .step.active .step-number {
            background: #667eea;
            color: white;
        }
        
        .step.completed .step-number {
            background: #4CAF50;
            color: white;
        }
        
        .step-text {
            font-size: 14px;
            color: #666;
        }
        
        .step.active .step-text {
            color: #667eea;
            font-weight: bold;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .form-group input.error {
            border-color: #ff4757;
        }
        
        .email-verification {
            display: flex;
            gap: 10px;
            align-items: end;
        }
        
        .email-verification .form-group {
            flex: 1;
            margin-bottom: 0;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .message {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
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
        
        .message.info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .step-content {
            display: none;
        }
        
        .step-content.active {
            display: block;
        }
        
        .password-requirements {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .password-requirements h4 {
            margin-bottom: 10px;
            color: #333;
        }
        
        .requirement {
            display: flex;
            align-items: center;
            margin-bottom: 5px;
            font-size: 14px;
        }
        
        .requirement i {
            margin-right: 8px;
            width: 16px;
        }
        
        .requirement.valid {
            color: #28a745;
        }
        
        .requirement.invalid {
            color: #dc3545;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
        
        .loading {
            display: none;
            text-align: center;
            margin: 20px 0;
        }
        
        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto 10px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-key"></i> 비밀번호 찾기</h1>
            <p>아이디를 입력하고 이메일 인증을 통해 비밀번호를 재설정하세요</p>
        </div>
        
        <!-- 단계 표시 -->
        <div class="step-indicator">
            <div class="step active" id="step1">
                <div class="step-number">1</div>
                <div class="step-text">아이디 입력</div>
            </div>
            <div class="step" id="step2">
                <div class="step-number">2</div>
                <div class="step-text">이메일 인증</div>
            </div>
            <div class="step" id="step3">
                <div class="step-number">3</div>
                <div class="step-text">비밀번호 변경</div>
            </div>
        </div>
        
        <!-- 메시지 표시 영역 -->
        <div id="messageArea"></div>
        
        <!-- 로딩 표시 -->
        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p>처리 중입니다...</p>
        </div>
        
        <!-- 1단계: 아이디 입력 -->
        <div class="step-content active" id="step1Content">
            <form id="usernameForm">
                <div class="form-group">
                    <label for="username">아이디</label>
                    <input type="text" id="username" name="username" required 
                           placeholder="가입한 아이디를 입력하세요">
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%;">
                    다음 단계로
                </button>
            </form>
        </div>
        
        <!-- 2단계: 이메일 인증 -->
        <div class="step-content" id="step2Content">
            <div class="form-group">
                <label>이메일</label>
                <input type="email" id="email" readonly>
            </div>
            <div class="email-verification">
                <div class="form-group">
                    <label for="verificationCode">인증번호</label>
                    <input type="text" id="verificationCode" name="verificationCode" 
                           placeholder="인증번호 6자리를 입력하세요" maxlength="6">
                </div>
                <button type="button" class="btn btn-success" id="verifyCodeBtn">
                    확인
                </button>
            </div>
            <button type="button" class="btn btn-primary" id="resendCodeBtn" style="width: 100%; margin-top: 10px;">
                인증번호 재발송
            </button>
        </div>
        
        <!-- 3단계: 비밀번호 변경 -->
        <div class="step-content" id="step3Content">
            <div class="password-requirements">
                <h4>비밀번호 요구사항</h4>
                <div class="requirement" id="reqLength">
                    <i class="fas fa-circle"></i>
                    <span>8자 이상</span>
                </div>
                <div class="requirement" id="reqUppercase">
                    <i class="fas fa-circle"></i>
                    <span>대문자 1개 이상</span>
                </div>
                <div class="requirement" id="reqLowercase">
                    <i class="fas fa-circle"></i>
                    <span>소문자 1개 이상</span>
                </div>
                <div class="requirement" id="reqNumber">
                    <i class="fas fa-circle"></i>
                    <span>숫자 1개 이상</span>
                </div>
                <div class="requirement" id="reqSpecial">
                    <i class="fas fa-circle"></i>
                    <span>특수문자 1개 이상</span>
                </div>
            </div>
            
            <form id="passwordForm">
                <div class="form-group">
                    <label for="newPassword">새 비밀번호</label>
                    <input type="password" id="newPassword" name="newPassword" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">새 비밀번호 확인</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%;">
                    비밀번호 변경
                </button>
            </form>
        </div>
        
        <div class="back-link">
            <a href="login.jsp"><i class="fas fa-arrow-left"></i> 로그인 페이지로 돌아가기</a>
        </div>
    </div>
    
    <script>
        let currentStep = 1;
        let userEmail = '';
        let isEmailVerified = false;
        
        // 메시지 표시 함수
        function showMessage(message, type = 'info') {
            const messageArea = document.getElementById('messageArea');
            messageArea.innerHTML = `<div class="message ${type}">${message}</div>`;
        }
        
        // 로딩 표시/숨김
        function showLoading(show) {
            document.getElementById('loading').style.display = show ? 'block' : 'none';
        }
        
        // 단계 변경 함수
        function goToStep(step) {
            // 모든 단계 비활성화
            document.querySelectorAll('.step-content').forEach(content => {
                content.classList.remove('active');
            });
            document.querySelectorAll('.step').forEach(stepEl => {
                stepEl.classList.remove('active', 'completed');
            });
            
            // 현재 단계 활성화
            document.getElementById(`step${step}Content`).classList.add('active');
            document.getElementById(`step${step}`).classList.add('active');
            
            // 이전 단계들 완료 표시
            for (let i = 1; i < step; i++) {
                document.getElementById(`step${i}`).classList.add('completed');
            }
            
            currentStep = step;
        }
        
        // 1단계: 아이디 입력 폼 제출
        document.getElementById('usernameForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value.trim();
            if (!username) {
                showMessage('아이디를 입력해주세요.', 'error');
                return;
            }
            
            showLoading(true);
            
            // 아이디로 이메일 조회
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=checkUsername&username=${encodeURIComponent(username)}`
            })
            .then(response => response.json())
            .then(data => {
                showLoading(false);
                
                if (data.success) {
                    userEmail = data.email;
                    document.getElementById('email').value = userEmail;
                    goToStep(2);
                    showMessage('이메일로 인증번호를 발송했습니다. 이메일을 확인해주세요.', 'success');
                } else {
                    showMessage(data.message || '존재하지 않는 아이디입니다.', 'error');
                }
            })
            .catch(error => {
                showLoading(false);
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.', 'error');
            });
        });
        
        // 2단계: 인증번호 확인
        document.getElementById('verifyCodeBtn').addEventListener('click', function() {
            const code = document.getElementById('verificationCode').value.trim();
            if (!code) {
                showMessage('인증번호를 입력해주세요.', 'error');
                return;
            }
            
            showLoading(true);
            
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=verifyCode&code=${encodeURIComponent(code)}`
            })
            .then(response => response.json())
            .then(data => {
                showLoading(false);
                
                if (data.success) {
                    isEmailVerified = true;
                    goToStep(3);
                    showMessage('이메일 인증이 완료되었습니다. 새 비밀번호를 입력해주세요.', 'success');
                } else {
                    showMessage(data.message || '인증번호가 올바르지 않습니다.', 'error');
                }
            })
            .catch(error => {
                showLoading(false);
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.', 'error');
            });
        });
        
        // 2단계: 인증번호 재발송
        document.getElementById('resendCodeBtn').addEventListener('click', function() {
            showLoading(true);
            
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=resendCode`
            })
            .then(response => response.json())
            .then(data => {
                showLoading(false);
                
                if (data.success) {
                    showMessage('인증번호를 재발송했습니다. 이메일을 확인해주세요.', 'success');
                } else {
                    showMessage(data.message || '인증번호 발송에 실패했습니다.', 'error');
                }
            })
            .catch(error => {
                showLoading(false);
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.', 'error');
            });
        });
        
        // 3단계: 비밀번호 유효성 검사
        function validatePassword(password) {
            const requirements = {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /\d/.test(password),
                special: /[!@#$%^&*(),.?":{}|<>]/.test(password)
            };
            
            // 요구사항 표시 업데이트
            document.getElementById('reqLength').className = `requirement ${requirements.length ? 'valid' : 'invalid'}`;
            document.getElementById('reqUppercase').className = `requirement ${requirements.uppercase ? 'valid' : 'invalid'}`;
            document.getElementById('reqLowercase').className = `requirement ${requirements.lowercase ? 'valid' : 'invalid'}`;
            document.getElementById('reqNumber').className = `requirement ${requirements.number ? 'valid' : 'invalid'}`;
            document.getElementById('reqSpecial').className = `requirement ${requirements.special ? 'valid' : 'invalid'}`;
            
            // 아이콘 업데이트
            document.querySelectorAll('.requirement.valid i').forEach(icon => {
                icon.className = 'fas fa-check';
            });
            document.querySelectorAll('.requirement.invalid i').forEach(icon => {
                icon.className = 'fas fa-times';
            });
            
            return Object.values(requirements).every(req => req);
        }
        
        // 비밀번호 입력 시 실시간 검사
        document.getElementById('newPassword').addEventListener('input', function() {
            validatePassword(this.value);
        });
        
        // 3단계: 비밀번호 변경 폼 제출
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!validatePassword(newPassword)) {
                showMessage('비밀번호 요구사항을 모두 만족해야 합니다.', 'error');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showMessage('비밀번호가 일치하지 않습니다.', 'error');
                return;
            }
            
            if (!isEmailVerified) {
                showMessage('이메일 인증이 필요합니다.', 'error');
                return;
            }
            
            showLoading(true);
            
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=changePassword&newPassword=${encodeURIComponent(newPassword)}`
            })
            .then(response => response.json())
            .then(data => {
                showLoading(false);
                
                if (data.success) {
                    showMessage('비밀번호가 성공적으로 변경되었습니다. 로그인 페이지로 이동합니다.', 'success');
                    setTimeout(() => {
                        window.location.href = 'login.jsp';
                    }, 2000);
                } else {
                    showMessage(data.message || '비밀번호 변경에 실패했습니다.', 'error');
                }
            })
            .catch(error => {
                showLoading(false);
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.', 'error');
            });
        });
    </script>
</body>
</html>
