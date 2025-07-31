<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>호텔 등록 - Hotel Booking</title>
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
            padding: 2rem 0;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .header {
            text-align: center;
            margin-bottom: 2rem;
            color: white;
        }

        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }

        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .form-container {
            background: white;
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .form-section {
            margin-bottom: 2.5rem;
        }

        .form-section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #eee;
        }

        .section-title i {
            color: #2c5aa0;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .form-row.full {
            grid-template-columns: 1fr;
        }

        .form-row.three {
            grid-template-columns: 1fr 1fr 1fr;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #333;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #ddd;
            border-radius: 8px;
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
            height: 120px;
            resize: vertical;
        }

        /* 동적 추가/제거 섹션 스타일 */
        .dynamic-section {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            background: #f8f9fa;
        }

        .dynamic-item {
            display: flex;
            align-items: end;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .dynamic-item:last-child {
            margin-bottom: 0;
        }

        .dynamic-item .form-group {
            flex: 1;
            margin-bottom: 0;
        }

        .btn-remove {
            background: #dc3545;
            color: white;
            border: none;
            padding: 0.75rem;
            border-radius: 8px;
            cursor: pointer;
            height: 48px;
            width: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-remove:hover {
            background: #c82333;
        }

        .btn-add {
            background: #28a745;
            color: white;
            border: none;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .btn-add:hover {
            background: #218838;
        }

        .file-input-wrapper {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-input {
            position: absolute;
            opacity: 0;
            width: 100%;
            height: 100%;
            cursor: pointer;
        }

        .file-input-display {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.75rem;
            border: 2px dashed #ddd;
            border-radius: 8px;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s;
        }

        .file-input-display:hover {
            border-color: #2c5aa0;
            background: #e8f2ff;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #2c5aa0;
            color: white;
        }

        .btn-primary:hover {
            background: #1e3d6f;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #545b62;
            transform: translateY(-2px);
        }

        .back-to-dashboard {
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

        .back-to-dashboard:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .form-row,
            .form-row.three {
                grid-template-columns: 1fr;
            }
            
            .form-container {
                padding: 2rem 1.5rem;
            }
            
            .button-group {
                flex-direction: column;
            }

            .dynamic-item {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-remove {
                width: 100%;
                height: auto;
            }
        }
    </style>
</head>
<body>
    <a href="admin-dashboard.jsp" class="back-to-dashboard">
        <i class="fas fa-arrow-left"></i> 대시보드로 돌아가기
    </a>

    <div class="container">
        <div class="header">
            <h1><i class="fas fa-hotel"></i> 새 호텔 등록</h1>
            <p>호텔의 모든 정보를 입력하여 등록 신청을 해주세요</p>
        </div>

        <div class="form-container">
            <form action="HotelRegisterServlet" method="POST" enctype="multipart/form-data">
                
                <!-- 기본 정보 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-info-circle"></i> 호텔 기본 정보
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="title">호텔명 *</label>
                            <input type="text" id="title" name="hotel_title" placeholder="호텔명을 입력하세요" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">전화번호 *</label>
                            <input type="tel" id="phone" name="hotel_phone" placeholder="02-1234-5678" required>
                        </div>
                    </div>
                    
                    <div class="form-row full">
                        <div class="form-group">
                            <label for="content">호텔 설명 *</label>
                            <textarea id="content" name="hotel_content" placeholder="호텔에 대한 상세 설명을 입력하세요" required></textarea>
                        </div>
                    </div>
                </div>

                <!-- 위치 정보 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-map-marker-alt"></i> 위치 정보
                    </div>
                    
                    <div class="form-row full">
                        <div class="form-group">
                            <label for="address">주소 *</label>
                            <input type="text" id="address" name="hotel_address" placeholder="상세 주소를 입력하세요" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="city">도시 *</label>
                            <input type="text" id="city" name="hotel_city" placeholder="도시명" required>
                        </div>
                        <div class="form-group">
                            <label for="country">국가 *</label>
                            <select id="country" name="hotel_country" required>
                                <option value="">국가 선택</option>
                                <option value="KR" selected>대한민국</option>
                                <option value="JP">일본</option>
                                <option value="CN">중국</option>
                                <option value="US">미국</option>
                                <option value="TH">태국</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 객실 타입 및 가격 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-bed"></i> 객실 타입 및 가격
                    </div>
                    
                    <div class="dynamic-section">
                        <div id="roomTypes">
                            <div class="dynamic-item">
                                <div class="form-group">
                                    <label>객실 타입명 *</label>
                                    <input type="text" name="room_titles[]" placeholder="예: 스탠다드룸" required>
                                </div>
                                <div class="form-group">
                                    <label>1박 요금 (원) *</label>
                                    <input type="number" name="room_prices[]" placeholder="120000" min="0" required>
                                </div>
                                <div class="form-group">
                                    <label>객실 개수 *</label>
                                    <input type="number" name="room_counts[]" placeholder="15" min="1" required>
                                </div>
                                <div class="form-group">
                                    <label>객실 설명</label>
                                    <input type="text" name="room_contents[]" placeholder="객실에 대한 간단한 설명">
                                </div>
                                <button type="button" class="btn-remove" onclick="removeRoomType(this)">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                        <button type="button" class="btn-add" onclick="addRoomType()">
                            <i class="fas fa-plus"></i> 객실 타입 추가
                        </button>
                    </div>
                </div>

                <!-- 시설 정보 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-swimming-pool"></i> 호텔 시설
                    </div>
                    
                    <div class="dynamic-section">
                        <div id="facilities">
                            <div class="dynamic-item">
                                <div class="form-group">
                                    <label>시설명 *</label>
                                    <input type="text" name="facility_titles[]" placeholder="예: 무료 Wi-Fi" required>
                                </div>
                                <div class="form-group">
                                    <label>시설 설명</label>
                                    <input type="text" name="facility_contents[]" placeholder="시설에 대한 상세 설명">
                                </div>
                                <button type="button" class="btn-remove" onclick="removeFacility(this)">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                        <button type="button" class="btn-add" onclick="addFacility()">
                            <i class="fas fa-plus"></i> 시설 추가
                        </button>
                    </div>
                </div>

                <!-- 호텔 이미지 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-images"></i> 호텔 이미지
                    </div>
                    
                    <div class="dynamic-section">
                        <div id="hotelImages">
                            <div class="dynamic-item">
                                <div class="form-group">
                                    <label>이미지 제목 *</label>
                                    <input type="text" name="image_titles[]" placeholder="예: 호텔 외관" required>
                                </div>
                                <div class="form-group">
                                    <label>이미지 파일 *</label>
                                    <div class="file-input-wrapper">
                                        <input type="file" name="image_files[]" class="file-input" accept="image/*" required>
                                        <div class="file-input-display">
                                            <i class="fas fa-upload"></i>
                                            <span>이미지 선택</span>
                                        </div>
                                    </div>
                                </div>
                                <button type="button" class="btn-remove" onclick="removeImage(this)">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                        <button type="button" class="btn-add" onclick="addImage()">
                            <i class="fas fa-plus"></i> 이미지 추가
                        </button>
                    </div>
                </div>

                <div class="button-group">
                    <a href="admin-dashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-times"></i> 취소
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> 호텔 등록
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // 객실 타입 추가/제거
        function addRoomType() {
            const container = document.getElementById('roomTypes');
            const newItem = document.createElement('div');
            newItem.className = 'dynamic-item';
            newItem.innerHTML = `
                <div class="form-group">
                    <label>객실 타입명 *</label>
                    <input type="text" name="room_titles[]" placeholder="예: 디럭스룸" required>
                </div>
                <div class="form-group">
                    <label>1박 요금 (원) *</label>
                    <input type="number" name="room_prices[]" placeholder="180000" min="0" required>
                </div>
                <div class="form-group">
                    <label>객실 개수 *</label>
                    <input type="number" name="room_counts[]" placeholder="10" min="1" required>
                </div>
                <div class="form-group">
                    <label>객실 설명</label>
                    <input type="text" name="room_contents[]" placeholder="객실에 대한 간단한 설명">
                </div>
                <button type="button" class="btn-remove" onclick="removeRoomType(this)">
                    <i class="fas fa-trash"></i>
                </button>
            `;
            container.appendChild(newItem);
        }

        function removeRoomType(button) {
            const container = document.getElementById('roomTypes');
            if (container.children.length > 1) {
                button.parentElement.remove();
            } else {
                alert('최소 하나의 객실 타입은 필요합니다.');
            }
        }

        // 시설 추가/제거
        function addFacility() {
            const container = document.getElementById('facilities');
            const newItem = document.createElement('div');
            newItem.className = 'dynamic-item';
            newItem.innerHTML = `
                <div class="form-group">
                    <label>시설명 *</label>
                    <input type="text" name="facility_titles[]" placeholder="예: 수영장" required>
                </div>
                <div class="form-group">
                    <label>시설 설명</label>
                    <input type="text" name="facility_contents[]" placeholder="시설에 대한 상세 설명">
                </div>
                <button type="button" class="btn-remove" onclick="removeFacility(this)">
                    <i class="fas fa-trash"></i>
                </button>
            `;
            container.appendChild(newItem);
        }

        function removeFacility(button) {
            const container = document.getElementById('facilities');
            if (container.children.length > 1) {
                button.parentElement.remove();
            } else {
                alert('최소 하나의 시설은 필요합니다.');
            }
        }

        // 이미지 추가/제거
        function addImage() {
            const container = document.getElementById('hotelImages');
            const newItem = document.createElement('div');
            newItem.className = 'dynamic-item';
            newItem.innerHTML = `
                <div class="form-group">
                    <label>이미지 제목 *</label>
                    <input type="text" name="image_titles[]" placeholder="예: 로비" required>
                </div>
                <div class="form-group">
                    <label>이미지 파일 *</label>
                    <div class="file-input-wrapper">
                        <input type="file" name="image_files[]" class="file-input" accept="image/*" required>
                        <div class="file-input-display">
                            <i class="fas fa-upload"></i>
                            <span>이미지 선택</span>
                        </div>
                    </div>
                </div>
                <button type="button" class="btn-remove" onclick="removeImage(this)">
                    <i class="fas fa-trash"></i>
                </button>
            `;
            container.appendChild(newItem);
        }

        function removeImage(button) {
            const container = document.getElementById('hotelImages');
            if (container.children.length > 1) {
                button.parentElement.remove();
            } else {
                alert('최소 하나의 이미지는 필요합니다.');
            }
        }

        // 파일 입력 시 표시 업데이트
        document.addEventListener('change', function(e) {
            if (e.target.type === 'file') {
                const display = e.target.nextElementSibling;
                const span = display.querySelector('span');
                if (e.target.files.length > 0) {
                    span.textContent = e.target.files[0].name;
                } else {
                    span.textContent = '이미지 선택';
                }
            }
        });
    </script>
</body>
</html> 