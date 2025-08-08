<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="common/header.jsp">
    <jsp:param name="title" value="비밀번호 찾기" />
</jsp:include>
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
            background: #ddd;
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
            background: #28a745;
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
        
        .btn {
            width: 100%;
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            background: #667eea;
            color: white;
        }
        
        .btn:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }
        
        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .btn-secondary {
            background: #6c757d;
        }
        
        .btn-secondary:hover {
            background: #545b62;
        }
        
        .message {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
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
        
        .step-content {
            display: none;
        }
        
        .step-content.active {
            display: block;
        }
        
        .verification-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .verification-info .email {
            font-weight: bold;
            color: #667eea;
        }
        
        .resend-link {
            text-align: center;
            margin-top: 15px;
        }
        
        .resend-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }
        
        .resend-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-key"></i> 비밀번호 찾기</h1>
            <p>단계별로 진행하여 비밀번호를 재설정하세요</p>
        </div>
        
        <!-- 단계 표시 -->
        <div class="step-indicator">
            <div class="step active" id="step1">
                <div class="step-number">1</div>
                <div class="step-text">아이디 입력</div>
            </div>
            <div class="step" id="step2">
                <div class="step-number">2</div>
                <div class="step-text">인증번호 발송</div>
            </div>
            <div class="step" id="step3">
                <div class="step-number">3</div>
                <div class="step-text">인증번호 확인</div>
            </div>
            <div class="step" id="step4">
                <div class="step-number">4</div>
                <div class="step-text">새 비밀번호</div>
            </div>
        </div>
        
        <!-- 메시지 표시 영역 -->
        <div id="messageArea"></div>
        
        <!-- 1단계: 아이디 입력 -->
        <div class="step-content active" id="step1Content">
            <form id="usernameForm">
                <div class="form-group">
                    <label for="username">아이디</label>
                    <input type="text" id="username" name="username" required 
                           placeholder="가입한 아이디를 입력하세요">
                </div>
                <button type="submit" class="btn">
                    <i class="fas fa-search"></i> 아이디 확인
                </button>
            </form>
        </div>
        
        <!-- 2단계: 인증번호 발송 -->
        <div class="step-content" id="step2Content">
            <div class="verification-info">
                <p>인증번호를 다음 이메일로 발송합니다:</p>
                <p class="email" id="userEmail"></p>
            </div>
            <button type="button" class="btn" id="sendCodeBtn">
                <i class="fas fa-paper-plane"></i> 인증번호 발송
            </button>
        </div>
        
        <!-- 3단계: 인증번호 확인 -->
        <div class="step-content" id="step3Content">
            <div class="verification-info">
                <p>이메일로 발송된 6자리 인증번호를 입력하세요</p>
                <p class="email" id="userEmail2"></p>
            </div>
            <form id="verificationForm">
                <div class="form-group">
                    <label for="verificationCode">인증번호</label>
                    <input type="text" id="verificationCode" name="verificationCode" 
                           maxlength="6" placeholder="000000" required>
                </div>
                <button type="submit" class="btn">
                    <i class="fas fa-check"></i> 인증번호 확인
                </button>
            </form>
            <div class="resend-link">
                <a href="#" id="resendCode">인증번호 재발송</a>
            </div>
        </div>
        
        <!-- 4단계: 새 비밀번호 설정 -->
        <div class="step-content" id="step4Content">
            <form id="passwordForm">
                <div class="form-group">
                    <label for="newPassword">새 비밀번호</label>
                    <input type="password" id="newPassword" name="newPassword" 
                           placeholder="6자리 이상 입력" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">새 비밀번호 확인</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" 
                           placeholder="비밀번호 재입력" required>
                </div>
                <button type="submit" class="btn">
                    <i class="fas fa-save"></i> 비밀번호 변경
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
        
        // 메시지 표시 함수
        function showMessage(message, type = 'error') {
            const messageArea = document.getElementById('messageArea');
            messageArea.innerHTML = `<div class="message ${type}">${message}</div>`;
        }
        
        // 단계 변경 함수
        function goToStep(step) {
            // 모든 단계 비활성화
            document.querySelectorAll('.step-content').forEach(content => {
                content.classList.remove('active');
            });
            document.querySelectorAll('.step').forEach(stepEl => {
                stepEl.classList.remove('active');
            });
            
            // 이전 단계들 완료 표시
            for (let i = 1; i < step; i++) {
                document.getElementById(`step${i}`).classList.add('completed');
            }
            
            // 현재 단계 활성화
            document.getElementById(`step${step}`).classList.add('active');
            document.getElementById(`step${step}Content`).classList.add('active');
            
            currentStep = step;
        }
        
        // 1단계: 아이디 확인
        document.getElementById('usernameForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value.trim();
            console.log('아이디 확인 요청:', username);
            
            if (!username) {
                showMessage('아이디를 입력해주세요.');
                return;
            }
            
            const formData = `action=checkUsername&username=${encodeURIComponent(username)}`;
            console.log('전송할 데이터:', formData);
            
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
            .then(response => {
                console.log('서버 응답 상태:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('서버 응답 데이터:', data);
                if (data.success) {
                    userEmail = data.data;
                    document.getElementById('userEmail').textContent = userEmail;
                    document.getElementById('userEmail2').textContent = userEmail;
                    showMessage(data.message, 'success');
                    setTimeout(() => goToStep(2), 1000);
                } else {
                    showMessage(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.');
            });
        });
        
        // 2단계: 인증번호 발송
        document.getElementById('sendCodeBtn').addEventListener('click', function() {
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=sendVerificationCode'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage(data.message, 'success');
                    setTimeout(() => goToStep(3), 1000);
                } else {
                    showMessage(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.');
            });
        });
        
        // 3단계: 인증번호 확인
        document.getElementById('verificationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const verificationCode = document.getElementById('verificationCode').value.trim();
            if (!verificationCode) {
                showMessage('인증번호를 입력해주세요.');
                return;
            }
            
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=verifyCode&verificationCode=${encodeURIComponent(verificationCode)}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage(data.message, 'success');
                    setTimeout(() => goToStep(4), 1000);
                } else {
                    showMessage(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.');
            });
        });
        
        // 인증번호 재발송
        document.getElementById('resendCode').addEventListener('click', function(e) {
            e.preventDefault();
            
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=sendVerificationCode'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('인증번호가 재발송되었습니다.', 'success');
                } else {
                    showMessage(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.');
            });
        });
        
        // 4단계: 비밀번호 변경
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!newPassword || !confirmPassword) {
                showMessage('비밀번호를 입력해주세요.');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showMessage('비밀번호가 일치하지 않습니다.');
                return;
            }
            
            if (newPassword.length < 6) {
                showMessage('비밀번호는 6자리 이상이어야 합니다.');
                return;
            }
            
            fetch('find-password', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=changePassword&newPassword=${encodeURIComponent(newPassword)}&confirmPassword=${encodeURIComponent(confirmPassword)}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage(data.message, 'success');
                    setTimeout(() => {
                        window.location.href = 'login.jsp';
                    }, 2000);
                } else {
                    showMessage(data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('오류가 발생했습니다. 다시 시도해주세요.');
            });
        });
    </script>
<jsp:include page="common/footer.jsp" />
