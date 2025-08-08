<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="java.sql.*, utils.*, vo.*" %>

<%
	String fileName = null;
	Connection conn = DBCPUtil.getConnection();
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	List<PostVO> facility = new ArrayList<>(); // 편의 시설 목록
	List<PostVO> roomType = new ArrayList<>(); // 객실 목록
	
		// 등록한 호텔 게시물 수정
		String postId = request.getParameter("postId");
		int post_id = 0;
		if(postId != null){
			post_id = Integer.parseInt(postId);
		}
		
		PostVO hotelPost = null;
		try{
			String sql = "SELECT post_id, title, phone, content, address, city, country, file_name FROM posts WHERE post_id = ? AND post_type = ?";

			conn = DBCPUtil.getConnection();						
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			pstmt.setString(2, "HOTEL");
	        rs = pstmt.executeQuery();				        
			if(rs.next()){
				hotelPost = new PostVO();
				hotelPost.setPostId(rs.getInt(1));
				hotelPost.setTitle(rs.getString(2));
				hotelPost.setPhone(rs.getString(3));
				hotelPost.setContent(rs.getString(4));
				hotelPost.setAddress(rs.getString(5));
				hotelPost.setCity(rs.getString(6));
				hotelPost.setCountry(rs.getString(7));
				fileName = rs.getString(8);
				// filname.jpg,filname2.png
				if(fileName != null && !fileName.trim().equals("")){
					hotelPost.setFileName(fileName.split(","));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBCPUtil.close(rs, pstmt, conn);
		}
		
		// 등록한 객실 타입
		try{
			conn = DBCPUtil.getConnection();
			String sql = "SELECT title, price, content, room_count FROM posts WHERE  parent_id = ? AND post_type = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			pstmt.setString(1, "ROOM_TYPE");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				PostVO d = new PostVO();
				d.setTitle(rs.getString(1));
				d.setPrice(rs.getInt(2));
				d.setContent(rs.getString(3));
				d.setRoom_count(rs.getInt(4));
				roomType.add(d);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBCPUtil.close(pstmt,rs,conn);
		}
		
	// 등록한 호텔 시설
		try{
			conn = DBCPUtil.getConnection();
			String sql = "SELECT title,content FROM posts WHERE  WHERE  parent_id = ? AND post_type = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			pstmt.setString(2, "FACILITY");
			rs = pstmt.executeQuery();
			while(rs.next()){
				PostVO s = new PostVO();
				s.setTitle(rs.getString(1));
				s.setContent(rs.getString(2));
				facility.add(s);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBCPUtil.close(pstmt,rs,conn);
		}
				
%> 
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>호텔 수정 - Hotel Booking</title>
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

        .image-preview-container {
            margin-top: 1rem;
        }

        .image-preview {
            width: 200px;
            height: 150px;
            border: 2px dashed #ddd;
            border-radius: 8px;
            background: #f8f9fa;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            color: #666;
            font-size: 0.9rem;
        }

        .image-preview img {
            max-width: 100%;
            max-height: 100%;
            object-fit: cover;
            border-radius: 6px;
        }

        .image-preview.has-image {
            border: 2px solid #2c5aa0;
            background: white;
        }

        .image-preview-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .image-preview-placeholder {
            width: 150px;
            height: 120px;
            border: 2px dashed #ddd;
            border-radius: 8px;
            background: #f8f9fa;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            color: #666;
            font-size: 0.8rem;
            text-align: center;
        }

        .image-preview-item {
            position: relative;
            width: 150px;
            height: 120px;
            border: 2px solid #2c5aa0;
            border-radius: 8px;
            background: white;
            overflow: hidden;
        }

        .image-preview-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .image-preview-item .remove-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(220, 53, 69, 0.9);
            color: white;
            border: none;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
        }

        .image-preview-item .remove-btn:hover {
            background: rgba(220, 53, 69, 1);
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
            <h1><i class="fas fa-hotel"></i> 호텔 수정 페이지</h1>
            <p>호텔의 모든 정보를 입력하여 등록 신청을 해주세요</p>
        </div>

        <div class="form-container">
            <form action="upload" method="POST" enctype="multipart/form-data">                   
                
                <!-- 기본 정보 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-info-circle"></i> 호텔 수정
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="title">호텔명 *</label>
                            <input type="text" id="title" name="hotel_title" value="<%=hotelPost.getTitle() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="phone">전화번호 *</label>
                            <input type="tel" id="phone" name="hotel_phone" value="<%=hotelPost.getPhone() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row full">
                        <div class="form-group">
                            <label for="content">호텔 설명 *</label>
                            <textarea id="content" name="hotel_content" required><%=hotelPost.getContent() %></textarea>
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
                            <input type="text" id="address" name="hotel_address" value="<%=hotelPost.getAddress() %>" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="city">도시 *</label>
                            <input type="text" id="city" name="hotel_city" value="<%=hotelPost.getCity() %>" required>
                        </div>
                    
                        <div class="form-group">
                            <label for="country">국가 *</label>
                            <select id="country" name="hotel_country" required>
                                <option value="">국가 선택</option>
                 
                                <option <%=hotelPost.getCountry().equals("KR") ? "selected" : "" %> value="KR">대한민국</option>
                                <option <%=hotelPost.getCountry().equals("JP") ? "selected" : "" %>value="JP">일본</option>
                                <option <%=hotelPost.getCountry().equals("CH") ? "selected" : "" %>value="CN">중국</option>
                                <option <%=hotelPost.getCountry().equals("US") ? "selected" : "" %>value="US">미국</option>
                                <option <%=hotelPost.getCountry().equals("TH") ? "selected" : "" %>value="TH">태국</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- 객실 타입 및 가격 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-bed"></i> 객실 타입 및 가격
                    </div>
                    
                    <%if(roomType != null && !roomType.isEmpty()){%>
                        <%for(PostVO c : roomType){ %>
                    <div class="dynamic-section">
                        <div id="roomTypes">
                            <div class="dynamic-item">
                                <div class="form-group">
                                    <label>객실 타입명 *</label>
                                    <input type="text" name="room_titles" value="<%=c.getTitle() %>" required>
                                </div>
                                <div class="form-group">
                                    <label>1박 요금 (원) *</label>
                                    <input type="number" name="room_prices" placeholder="120000" min="0" required>
                                </div>
                                <div class="form-group">
                                    <label>객실 개수 *</label>
                                    <input type="number" name="room_counts" placeholder="15" min="1" required>
                                </div>
                                <div class="form-group">
                                    <label>객실 설명</label>
                                    <input type="text" name="room_contents" placeholder="객실에 대한 간단한 설명">
                                </div>
                            </div>
                        </div>
				      <%} %>
                   <%} %>

                    </div>
                </div>

                <!-- 시설 정보 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-swimming-pool"></i> 호텔 시설
                    </div>
                    
                    <div class="dynamic-section">
                        <div id="facilities">
                        <%if(facility != null){%>
                        	<%for(PostVO f : facility){ %>
                            <div class="dynamic-item">
                                <div class="form-group">
                                    <label>시설명 *</label>
                                    <input type="text" name="facility_titles" value="<%=f.getTitle() %>" required>
                                </div>
                                <div class="form-group">
                                    <label>시설 설명</label>
                                    <input type="text" name="facility_contents"value="<%=f.getContent() %>" required>
                                </div>
                            </div>
                            <%} %>
                     	<%} %>
                        </div>

                    </div>
                </div>

                <!-- 호텔 이미지 -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-images"></i> 호텔 이미지
                    </div>
                    
                    <div class="dynamic-section">
                        <div class="form-group">
                            <label>이미지 파일들 * (여러 개 선택 가능)</label>
                            <div class="file-input-wrapper">
                                <input type="file" name="image_files" class="file-input" accept="image/*" multiple required onchange="previewMultipleImages(this)">
                                <div class="file-input-display">
                                    <i class="fas fa-upload"></i>
                                    <span>이미지들 선택 (Ctrl+클릭으로 여러 개 선택)</span>
                                </div>
                            </div>
                        </div>
                        <div class="image-preview-container">
                            <div id="imagePreviewGrid" class="image-preview-grid">
                                <div class="image-preview-placeholder">
                                    <i class="fas fa-image"></i>
                                    <span>선택된 이미지들이 여기에 표시됩니다</span>
                                </div>
                            </div>
                        </div>
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
                    <input type="text" name="room_titles" placeholder="예: 디럭스룸" required>
                </div>
                <div class="form-group">
                    <label>1박 요금 (원) *</label>
                    <input type="number" name="room_prices" placeholder="180000" min="0" required>
                </div>
                <div class="form-group">
                    <label>객실 개수 *</label>
                    <input type="number" name="room_counts" placeholder="10" min="1" required>
                </div>
                <div class="form-group">
                    <label>객실 설명</label>
                    <input type="text" name="room_contents" placeholder="객실에 대한 간단한 설명">
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
                    <input type="text" name="facility_titles" placeholder="예: 수영장" required>
                </div>
                <div class="form-group">
                    <label>시설 설명</label>
                    <input type="text" name="facility_contents" placeholder="시설에 대한 상세 설명">
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

        // 여러 이미지 미리보기 함수
        function previewMultipleImages(input) {
            const files = input.files;
            const previewGrid = document.getElementById('imagePreviewGrid');
            
            // 기존 미리보기 초기화
            previewGrid.innerHTML = '';
            
            if (files.length > 0) {
                // 파일 입력 표시 업데이트
                const display = input.nextElementSibling;
                const span = display.querySelector('span');
                span.textContent = `${files.length}개의 이미지 선택됨`;
                
                // 각 파일에 대해 미리보기 생성
                for (let i = 0; i < files.length; i++) {
                    const file = files[i];
                    const reader = new FileReader(file);
                    
                    reader.onload = function(e) {
                    	let url = window.URL.createObjectURL(file);
                        const previewItem = document.createElement('div');
                        previewItem.className = 'image-preview-item';
                        previewItem.innerHTML = `
                            <img src="\${e.target.result}" alt="이미지 미리보기">
                            <button type="button" class="remove-btn" onclick="removeImageFromGrid(this, \${i})">
                                <i class="fas fa-times"></i>
                            </button>
                        `;
                        previewGrid.appendChild(previewItem);
                    };
                    
                    reader.readAsDataURL(file);
                }
            } else {
                // 파일이 없을 때 플레이스홀더 표시
                previewGrid.innerHTML = `
                    <div class="image-preview-placeholder">
                        <i class="fas fa-image"></i>
                        <span>선택된 이미지들이 여기에 표시됩니다</span>
                    </div>
                `;
                
                const display = input.nextElementSibling;
                const span = display.querySelector('span');
                span.textContent = '이미지들 선택 (Ctrl+클릭으로 여러 개 선택)';
            }
        }

        // 그리드에서 개별 이미지 제거
        function removeImageFromGrid(button, index) {
            const input = document.querySelector('input[name="image_files"]');
            const dt = new DataTransfer();
            const files = input.files;
            
            // 해당 인덱스를 제외한 파일들만 유지
            for (let i = 0; i < files.length; i++) {
                if (i !== index) {
                    dt.items.add(files[i]);
                }
            }
            
            input.files = dt.files;
            previewMultipleImages(input);
        }

        // 파일 입력 시 표시 업데이트 (이미지가 아닌 경우에만)
        document.addEventListener('change', function(e) {
            if (e.target.type === 'file' && !e.target.hasAttribute('multiple')) {
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