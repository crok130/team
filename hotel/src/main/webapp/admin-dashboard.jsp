<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*, utils.* , java.sql.*"%>
<%
	
	String prid = request.getParameter("prid");
	if(prid == null){
		prid = "MONTHLY";
	}
	DecimalFormat df = new DecimalFormat("#,###");
	
	int result = 0;
	
	int weeklyCount = 0;
	int weeklySum = 0;
	int weeklyMoney = 0;
	
	int monthlyCount = 0;
	int monthlySum = 0;
	int monthMoney = 0;
	int totalMonthlyCount = 0;
	
	int dailyCount = 0;
	int dailySum = 0;
	int dailyMoney = 0;
	
	List<Integer> numbers = new ArrayList<>();
	
	int lastMonthCount = 0;
	int lastMonthSum = 0;
	int lastMonthMoney = 0;
	int lastMonthCounts = 0;
	
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String hotelName = "";
	
    String name = null;
    String Date = null;
    
%>
<!DOCTYPE html><html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드 - Hotel Booking System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
            background: #f4f6f9;
        }

        /* Header */
        .admin-header {
            background: linear-gradient(135deg, #2c5aa0, #1e3f73);
            color: white;
            padding: 1rem 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-logo {
            display: flex;
            align-items: center;
            gap: 1rem;
            font-size: 1.5rem;
            font-weight: bold;
            text-decoration: none;
            color: white;
        }

        .admin-logo i {
            background: rgba(255,255,255,0.2);
            padding: 0.5rem;
            border-radius: 8px;
        }

        .admin-nav {
            display: flex;
            gap: 2rem;
        }

        .admin-nav a {
            color: white;
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: background 0.3s;
        }

        .admin-nav a:hover {
            background: rgba(255,255,255,0.1);
        }

        .admin-user {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logout-btn {
            background: rgba(255,255,255,0.1);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s;
        }

        .logout-btn:hover {
            background: rgba(255,255,255,0.2);
        }

        /* Main Layout */
        .dashboard-container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 2rem;
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 2rem;
        }

        /* Sidebar */
        .admin-sidebar {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            height: fit-content;
        }

        .sidebar-menu {
            list-style: none;
        }

        .menu-item {
            margin-bottom: 0.5rem;
        }

        .menu-item a {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem 1rem;
            color: #666;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .menu-item a:hover,
        .menu-item a.active {
            background: #f0f8ff;
            color: #2c5aa0;
        }

        .menu-item i {
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border-left: 4px solid #2c5aa0;
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-title {
            color: #666;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            background: #f0f8ff;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #2c5aa0;
            font-size: 1.5rem;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .stat-change {
            font-size: 0.8rem;
            color: #28a745;
        }

        .stat-change.negative {
            color: #dc3545;
        }

        /* Content Sections */
        .content-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #eee;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #333;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            font-weight: 500;
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
            background: #1e3f73;
        }

        .btn-outline {
            background: transparent;
            color: #2c5aa0;
            border: 1px solid #2c5aa0;
        }

        .btn-outline:hover {
            background: #2c5aa0;
            color: white;
        }

        /* Tables */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .data-table th,
        .data-table td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .data-table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        .data-table tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .action-btn {
            padding: 0.25rem 0.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
            text-decoration: none;
        }

        .action-btn.approve {
            background: #28a745;
            color: white;
        }

        .action-btn.reject {
            background: #dc3545;
            color: white;
        }

        .action-btn.view {
            background: #007bff;
            color: white;
        }

        /* Chart Container */
        .chart-container {
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f9fa;
            border-radius: 8px;
            color: #666;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .dashboard-container {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            
            .admin-sidebar {
                order: 2;
            }
            
            .main-content {
                order: 1;
            }
        }

        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
            
            .admin-nav {
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .data-table {
                font-size: 0.8rem;
            }
            
            .data-table th,
            .data-table td {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Admin Header -->
    <header class="admin-header">
        <div class="header-container">
            <a href="admin-dashboard.jsp" class="admin-logo">
                <i class="fas fa-shield-alt"></i>
                <span>Admin Dashboard</span>
            </a>
            
            <nav class="admin-nav">
                                  <a href="admin-dashboard.jsp">대시보드</a>
                  <a href="hotel-register.jsp">호텔 등록</a>
                  <a href="index.jsp">사이트 보기</a>
            </nav>
            
            <div class="admin-user">
                <div class="user-avatar">
                    <i class="fas fa-user"></i>
        </div>
                <span>관리자</span>
                <a href="logout.jsp" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> 로그아웃
                </a>
            </div>
        </div>
    </header>

    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="admin-sidebar">
            <ul class="sidebar-menu">
                <li class="menu-item">
                    <a href="#overview" class="active">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>개요</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#user-management">
                        <i class="fas fa-users"></i>
                        <span>회원 관리 (users)</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#hotel-management">
                        <i class="fas fa-hotel"></i>
                        <span>호텔 관리 (posts)</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#reservation-management">
                        <i class="fas fa-calendar-check"></i>
                        <span>예약 관리 (reservations)</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#comment-management">
                        <i class="fas fa-comments"></i>
                        <span>리뷰 관리 (comments)</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#approval-management">
                        <i class="fas fa-check-circle"></i>
                        <span>승인 관리</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#statistics">
                        <i class="fas fa-chart-bar"></i>
                        <span>통계 (sales_statistics)</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="#settings">
                        <i class="fas fa-cog"></i>
                        <span>시스템 설정</span>
                    </a>
                </li>
            </ul>
        </aside>

    <!-- Main Content -->
    <main class="main-content">
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">총 회원 수 (users)</div>
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                    <div class="stat-value">2,847</div>
                    <div class="stat-change">
                        <i class="fas fa-arrow-up"></i> +12.5% (USER: 2,654 | HOTEL_MANAGER: 156 | ADMIN: 37)
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">등록된 호텔 (posts HOTEL)</div>
                        <div class="stat-icon">
                            <i class="fas fa-hotel"></i>
                        </div>
                    </div>
                    <div class="stat-value">156</div>
                    <div class="stat-change">
                        <i class="fas fa-arrow-up"></i> +8 이번 주 (post_type='HOTEL')
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">이번 달 예약 (reservations)</div>
                        <div class="stat-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                    </div>
                    <div class="stat-value">1,293</div>
                    <div class="stat-change">
                        <i class="fas fa-arrow-up"></i> +18.7% (CONFIRMED: 1,156 | PENDING: 137)
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">이번 달 매출 (sales_statistics)</div>
                        <div class="stat-icon">
                            <i class="fas fa-won-sign"></i>
                        </div>
                    </div>
                    <div class="stat-value">₩124M</div>
                    <div class="stat-change">
                        <i class="fas fa-arrow-up"></i> +22.3% (confirmed_revenue 기준)
                    </div>
                </div>
            </div>
<%

	conn = DBCPUtil.getConnection();
	List<UserVO> list = new ArrayList<>();
	try{
		String sql = "SELECT member_num,username,name,email,user_type FROM users WHERE status = 'PENDING'";	
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			UserVO vo = new UserVO();
			vo.setMemberNum(rs.getLong(1));
			vo.setUsername(rs.getString(2));
			vo.setName(rs.getString(3));
			vo.setEmail(rs.getString(4));
			vo.setUserType(rs.getString(5));
			list.add(vo);
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBCPUtil.close(pstmt, rs, conn);
	}
  

%>
            <!-- Pending Approvals -->
            <section class="content-section">
                <div class="section-header">
                    <h2 class="section-title">승인 대기 목록</h2>
                    <a href="#" class="btn btn-outline">
                        <i class="fas fa-eye"></i> 전체 보기
                    </a>
                </div>
			<%if(list != null){ %>
			<%for(UserVO s : list){ %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>회원번호</th>
                            <th>사용자명</th>
     	                    <th>실명</th>
                            <th>사용자 타입</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><%=s.getMemberNum()%></td>
                            <td><%=s.getUsername()%></td>
                            <td><%=s.getName() %></td>
                            <td><span class="status-badge status-pending"><%=s.getUserType() %></span></td>
                            <td>
                                <div class="action-buttons">
                                
                                    <a href="approve.jsp?approval=approve&membernum=<%=s.getMemberNum() %>" class="action-btn approve">승인</a>
                                    <a href="approve.jsp?approval=reject&membernum=<%=s.getMemberNum() %>" class="action-btn reject">거부</a>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <%} %>
              <%} %>
            </section>

            <!-- Recent Activities -->
            <section class="content-section">
                <div class="section-header">
                    <h2 class="section-title">최근 활동</h2>
                    <a href="#" class="btn btn-outline">
                        <i class="fas fa-history"></i> 전체 기록
                    </a>
                </div>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>시간</th>
                            <th>활동 유형</th>
                            <th>사용자명</th>
                            <th>대상</th>
                            <th>설명</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>14:30</td>
                            <td>USER 가입</td>
                            <td>kim_user</td>
                            <td>member_num: 1005</td>
                            <td>새 일반 회원이 가입했습니다</td>
                            <td><span class="status-badge status-approved">완료</span></td>
                        </tr>
                        <tr>
                            <td>13:45</td>
                            <td>RESERVATION 생성</td>
                            <td>lee_travel</td>
                            <td>reservation_id: 25</td>
                            <td>그랜드 호텔 - 스탠다드룸 예약</td>
                            <td><span class="status-badge status-approved">CONFIRMED</span></td>
                        </tr>
                        <tr>
                            <td>12:20</td>
                            <td>COMMENT 작성</td>
                            <td>park_guest</td>
                            <td>comment_id: 15</td>
                            <td>부산 오션뷰 호텔 리뷰 (평점: 4.5)</td>
                            <td><span class="status-badge status-approved">게시</span></td>
                        </tr>
                        <tr>
                            <td>11:15</td>
                            <td>HOTEL 등록</td>
                            <td>manager_choi</td>
                            <td>post_id: 12</td>
                            <td>대구 시티 호텔 등록 신청</td>
                            <td><span class="status-badge status-pending">승인 대기</span></td>
                        </tr>
                        <tr>
                            <td>10:30</td>
                            <td>HOTEL_MANAGER 신청</td>
                            <td>jung_admin</td>
                            <td>member_num: 1006</td>
                            <td>호텔 매니저 가입 신청</td>
                            <td><span class="status-badge status-pending">검토중</span></td>
                        </tr>
                        <tr>
                            <td>09:45</td>
                            <td>ROOM_TYPE 등록</td>
                            <td>manager1</td>
                            <td>post_id: 18</td>
                            <td>그랜드 호텔 - 이그제큐티브 스위트 추가</td>
                            <td><span class="status-badge status-approved">완료</span></td>
                        </tr>
                    </tbody>
                </table>
            </section>

            <!-- Revenue Chart -->
            <section class="content-section">
                <div class="section-header">
                    <h2 class="section-title">매출 통계 (sales_statistics)</h2>
                    <div>
                    <form action="admin-dashboard.jsp" method="get" id="periodForm">
                        <select class="btn btn-outline" name="prid" onchange="submitForm();">
                            <option value="MONTHLY" <%= prid.equals("MONTHLY") ? "selected" : "" %>>이번 달 (MONTHLY)</option>
                            <option value="LASTMONTHLY"<%= prid.equals("LASTMONTHLY") ? "selected" : "" %>>지난 달 (LASTMONTHLY)</option>
                            <option value="WEEKLY"<%= prid.equals("WEEKLY") ? "selected" : "" %>>최근 주간 (WEEKLY)</option>
                            <option value="DAILY" <%= prid.equals("DAILY") ? "selected" : "" %>>일별 현황 (DAILY)</option>
                        </select>
                       </form>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 2rem;">
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-title">전체 호텔 총 매출</div>
                            <div class="stat-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                        </div>
                        <div class="stat-value">₩5,400,000</div>
                        <div class="stat-change">
                            <i class="fas fa-arrow-up"></i> confirmed_revenue 기준
                        </div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-header">
                            <div class="stat-title">월간 총 예약 건수</div>
                            <div class="stat-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                        </div>
                        <div class="stat-value">43</div>
                        <div class="stat-change">
                            <i class="fas fa-arrow-up"></i> total_reservations 집계
                        </div>
                    </div>
                </div>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>호텔명</th>
                            <th>매니저</th>
                            <th>총예약</th>
                            <th>총매출</th>
                            <th>평균매출</th>
                        </tr>
                    </thead>
                    <tbody>
 			<%
 			
 							try{
 								conn = DBCPUtil.getConnection();
 								String sql = "SELECT post_id from posts WHERE member_num = 2 AND post_type = 'HOTEL'";
 								pstmt = conn.prepareStatement(sql);
 								rs = pstmt.executeQuery();
 								while(rs.next()){
 									result = rs.getInt(1);
 									numbers.add(result);
 									
 								}
 								
 							}catch(Exception e){
 								
 							}finally{
 								
 							}

						    // 1. 달력 가져오기 (오늘 날짜 기준)
						    Calendar cal = Calendar.getInstance();

						    // 2. 날짜 형식 설정 (예: 2024-12-16)
						    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

						    // 3. 이번주 월요일 찾기
						    cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);  // 오늘을 이번주 월요일로 바꾸기
						    String monday = sdf.format(cal.getTime());        // 월요일을 문자열로 변환

						    // 4. 이번주 일요일 찾기 (월요일 + 6일)
						    cal.add(Calendar.DATE, 6);       // 월요일에서 6일 더하기 = 일요일
						    String sunday = sdf.format(cal.getTime());        // 일요일을 문자열로 변환

						    // 5. 결과 출력

						    
						    

				for(int s : numbers){
						   	try{
						   		conn = DBCPUtil.getConnection();
						   		String sql = "SELECT total_amount FROM reservations WHERE TO_CHAR(booking_date, 'YYYY-MM-DD') BETWEEN '"+monday+"' AND '"+sunday+"'";
						   			   sql += " AND hotel_post_id = ?";
						   		pstmt = conn.prepareStatement(sql);
						   		pstmt.setInt(1, s);
						   		
						   		
						        rs = pstmt.executeQuery();
						
								while(rs.next()){
									int money = rs.getInt(1);
									weeklyMoney += money;
								}
				
						    } catch (Exception e) {
						        e.printStackTrace();
						    } finally {
								DBCPUtil.close(pstmt, rs, conn);
						    }  
						 				   
						   	try{
						   		conn = DBCPUtil.getConnection();
						   		String sql = "SELECT COUNT(*) FROM reservations WHERE TO_CHAR(booking_date, 'YYYY-MM-DD') BETWEEN '"+monday+"' AND '"+sunday+"'";
					   			   sql += " AND hotel_post_id = ?";
					   			pstmt = conn.prepareStatement(sql);
					   			pstmt.setInt(1, s);
					   			rs = pstmt.executeQuery();
					   			
					   			if(rs.next()){
					   				weeklyCount = rs.getInt(1);
					   			}
					   			
						   	}catch(Exception e){
						   		e.printStackTrace();
						   	}finally{
						   		DBCPUtil.close(pstmt, rs, conn);
						   	}
				}
							
						   	if(weeklyCount == 0){
							   	weeklySum = 0;


						   	}else{
						   		weeklySum = weeklyMoney / weeklyCount;
						   	}
						   	
						   	String weekformattedNumber = df.format(weeklySum);
				 	
						   	// 주데이터 출력
						   	
						   	Date today = new Date();
						   	sdf = new SimpleDateFormat("yyyy-MM");
							String monthStr = sdf.format(today);
							
							
							
						for(int s : numbers){
						  	try{
						  		
						  		conn = DBCPUtil.getConnection();
						  		String sql = "SELECT total_amount FROM reservations WHERE TO_CHAR(booking_date, 'YYYY-MM')= ?";
						  		 sql += " AND hotel_post_id = ?";
						  		pstmt = conn.prepareStatement(sql);
						  		pstmt.setString(1, monthStr);
						  		pstmt.setInt(2, s);
						  		rs = pstmt.executeQuery();
						  		
						  		while(rs.next()){
						  			int money = rs.getInt(1);
						  			monthMoney += money;
						  		}
						  	}catch(Exception e){
						  		e.printStackTrace();
						  	}finally{
						  		DBCPUtil.close(pstmt, rs, conn);
						  	}
						  	

						  	try{
						   		conn = DBCPUtil.getConnection();
						   		String sql = "SELECT COUNT(*) FROM reservations WHERE TO_CHAR(booking_date, 'YYYY-MM') = ?";
					   			   sql += " AND hotel_post_id = ?";
					   			pstmt = conn.prepareStatement(sql);
					   			pstmt.setString(1,monthStr);
					   			pstmt.setInt(2, s);
					   			rs = pstmt.executeQuery();
					   			
					   			if(rs.next()){
					   				monthlyCount = rs.getInt(1);
					   				totalMonthlyCount += monthlyCount;
					   			}
					   			
						   	}catch(Exception e){
						   		e.printStackTrace();
						   	}finally{
						   		DBCPUtil.close(pstmt, rs, conn);
						   	}
						  	
						 }
						
						  	// ------------------------------------------------------
						  	
						   	if(monthlyCount == 0){
							   	monthlySum = 0;

						   	}else{
						   		monthlySum = monthMoney / monthlyCount;
						   	}
						   	String monthformattedNumber = df.format(monthlySum);
						  	// 월별 
						   	
						   	String lastMonthStr = monthStr.substring(monthStr.length() -2 , monthStr.length());
						   	
						  	int lastMonth = Integer.parseInt(lastMonthStr) -1;
						  	String year = monthStr.substring(0 , 5);
						  	
						  	if(lastMonth == 0){
						  		lastMonth = 12;
						  		year = monthStr.substring(0 , 4);
						  		int years = Integer.parseInt(year) -1;
						  		year = years+"-";
						  	}
						  	
						  	if(lastMonth == 1){
						  		lastMonth = 12;
						  	}
						  	String last = null;
						  	if(lastMonth < 10){
						  		last = "0" + lastMonth;
						  	}
						  	
						 	
						  
						  	StringBuilder stb = new StringBuilder();

						  	stb.append(year).append(last);
						  	
						
						  	System.out.println(stb);
						  	
						  	
						  	
						  	
						  	
						  				  	
			// ----------------------------------------------------------------------------------------------------------------------			  	
						  	
				for(int s : numbers){
                            try{
						  		
						  		conn = DBCPUtil.getConnection();
						  		String sql = " SELECT total_amount FROM reservations WHERE TO_CHAR(booking_date, 'YYYY-MM')=  ? ";
						  			   sql += " AND hotel_post_id = ?";
						  		pstmt = conn.prepareStatement(sql);
						  		pstmt.setString(1, stb.toString());
						  		pstmt.setInt(2, s);
						  		rs = pstmt.executeQuery();
						  		
						  		while(rs.next()){
						  			int money = rs.getInt(1);
						  			lastMonthMoney += money;
						  		}
						  	}catch(Exception e){
						  		e.printStackTrace();
						  	}finally{
						  		DBCPUtil.close(pstmt, rs, conn);
						  	}
						  	
                            try{
						   		conn = DBCPUtil.getConnection();
						   		String sql = "SELECT COUNT(*) FROM reservations WHERE TO_CHAR(booking_date, 'YYYY-MM') = ?";
					   			       sql += " AND hotel_post_id = ?";
					   			pstmt = conn.prepareStatement(sql);
					   			pstmt.setString(1, stb.toString());
					   			pstmt.setInt(2, s);
					   			rs = pstmt.executeQuery();
					   			
					   			if(rs.next()){
					   				lastMonthCount = rs.getInt(1);
					   				lastMonthCounts += lastMonthCount;
					   			}
					   			
						   	}catch(Exception e){
						   		e.printStackTrace();
						   	}finally{
						   		DBCPUtil.close(pstmt, rs, conn);
						   	}
                            
                   	}    
                            // ------------------------------------------------
                            DecimalFormat dflast = new DecimalFormat("#,###");
						   	if(lastMonthCounts != 0){
						   		lastMonthSum = lastMonthMoney / lastMonthCounts;
						   		
						   	}else{
						   		lastMonthSum = 0;

						   	}
                         
						   	String lastformattedNumber = df.format(lastMonthSum);
						   	

						   	
						   // 지난달
						
						 	Date day = new Date();
						   	sdf = new SimpleDateFormat("yyyy-MM-DD");
							String dayStr = sdf.format(today);
						   
				   for(int s : numbers){
						  	try{
						  		
						  		conn = DBCPUtil.getConnection();
						  		String sql = " SELECT total_amount FROM reservations WHERE TO_CHAR(booking_date, 'YYYY-MM-DD')=  ? ";
						  		       sql += " AND hotel_post_id = ?";
						  		pstmt = conn.prepareStatement(sql);
						  		pstmt.setString(1, stb.toString());
						  		pstmt.setInt(2, s);
						  		rs = pstmt.executeQuery();
						  		
						  		while(rs.next()){
						  			int money = rs.getInt(1);
						  			dailyMoney += money;
						  		}
						  	}catch(Exception e){
						  		e.printStackTrace();
						  	}finally{
						  		DBCPUtil.close(pstmt, rs, conn);
						  	}
						  	
						
						   	
						   	try{
						   		conn = DBCPUtil.getConnection();
						   		String sql = "SELECT COUNT(*) FROM reservations WHERE TO_CHAR(booking_date, 'YYYY-MM-DD') = ?";
					   			   sql += " AND hotel_post_id = ?";
					   			pstmt = conn.prepareStatement(sql);
					   			pstmt.setString(1, stb.toString());
						  		pstmt.setInt(2, s);
					   			rs = pstmt.executeQuery();
					   			
					   			if(rs.next()){
					   				dailyCount = rs.getInt(1);
					   			}
					   			
						   	}catch(Exception e){
						   		e.printStackTrace();
						   	}finally{
						   		DBCPUtil.close(pstmt, rs, conn);
						   	}
						   	
						}
						   	//  -------------------------------------
						   	if(monthlyCount == 0){
							   	dailySum = 0;

						   	}else{
						   		dailySum = dailyMoney / dailyCount;
						   	}
						   	String dailyformattedNumber = df.format(monthlySum);
						 // 일별
						  	
						    try {
		
						        conn = DBCPUtil.getConnection();
						        String sql = "SELECT title FROM posts WHERE member_num = 2";
						        pstmt = conn.prepareStatement(sql);
						        rs = pstmt.executeQuery();
						
						        if (rs.next()) {
						            hotelName = rs.getString(1);
						        }
						    } catch (Exception e) {
						        e.printStackTrace();
						    } finally {
								DBCPUtil.close(pstmt, rs, conn);
						    }
						 // 호텔명
						  
			 				try{
			 					conn = DBCPUtil.getConnection();
			 					String sql = "SELECT username FROM users WHERE member_num = 2";
			 					pstmt = conn.prepareStatement(sql);
			 					rs = pstmt.executeQuery();
			 					if(rs.next()){
			 						name = rs.getString(1);
			 					}
			 					
			 				}catch(Exception e){
			 					
			 				}finally{
			 					DBCPUtil.close(pstmt, rs, conn);
			 				}
			 				// 호텔 매니저
			 				
				%>						   
											
						<tr>
						    <td><%= hotelName %> </td>
						    <td><%=name%></td>
						    <%if(prid != null && prid.equals("WEEKLY")){ %>
						    <td><%= weeklyCount %></td>
						    <td>₩<%= weeklyMoney %></td>
						    <td>₩<%= weekformattedNumber %></td>
						    <%}else if(prid != null && prid.equals("MONTHLY")){%>
						    <td><%= monthlyCount %></td>
						    <td>₩<%=totalMonthlyCount %></td>
						    <td>₩<%= monthformattedNumber %></td>
						    <%}else if(prid != null && prid.equals("DAILY")){%>
						    <td><%= dailyCount %></td>
						    <td>₩<%= dailyMoney %></td>
						    <td>₩<%= dailyformattedNumber %></td>
						    <%}else if(prid != null && prid.equals("LASTMONTHLY")){%>
						    <td><%= lastMonthCounts %></td>
						    <td>₩<%= lastMonthMoney %></td>
						    <td>₩<%= lastformattedNumber %></td>
							<%} %>
						    
						</tr>
                    </tbody>
                </table>

                <div class="chart-container" style="margin-top: 2rem;">
                    <div style="text-align: center;">
                        <i class="fas fa-chart-line" style="font-size: 3rem; margin-bottom: 1rem; color: #ddd;"></i>
                        <p>매출 차트 영역</p>
                        <small>실제 구현시 Chart.js로 sales_statistics 테이블 데이터 시각화</small>
                        <br><small>period_type, period_date별 total_revenue, confirmed_revenue 추이</small>
                    </div>
                </div>
            </section>

            <!-- Quick Actions -->
            <section class="content-section">
                <div class="section-header">
                    <h2 class="section-title">빠른 작업</h2>
                </div>

                <div class="stats-grid">
                    <a href="hotel-register.jsp" class="btn btn-primary" style="padding: 2rem; text-align: center; text-decoration: none; display: flex; flex-direction: column; gap: 1rem;">
                        <i class="fas fa-plus-circle" style="font-size: 2rem;"></i>
                        <span>새 호텔 등록</span>
                        <small>(posts - HOTEL 타입)</small>
                    </a>
                    
                    <a href="#" class="btn btn-outline" style="padding: 2rem; text-align: center; text-decoration: none; display: flex; flex-direction: column; gap: 1rem;">
                        <i class="fas fa-users-cog" style="font-size: 2rem;"></i>
                        <span>회원 관리</span>
                        <small>(users 테이블 관리)</small>
                    </a>
                    
                    <a href="#" class="btn btn-outline" style="padding: 2rem; text-align: center; text-decoration: none; display: flex; flex-direction: column; gap: 1rem;">
                        <i class="fas fa-chart-bar" style="font-size: 2rem;"></i>
                        <span>통계 보고서</span>
                        <small>(sales_statistics 분석)</small>
                    </a>
                    
                    <a href="#" class="btn btn-outline" style="padding: 2rem; text-align: center; text-decoration: none; display: flex; flex-direction: column; gap: 1rem;">
                        <i class="fas fa-calendar-check" style="font-size: 2rem;"></i>
                        <span>예약 관리</span>
                        <small>(reservations 현황)</small>
                    </a>
                    
                    <a href="#" class="btn btn-outline" style="padding: 2rem; text-align: center; text-decoration: none; display: flex; flex-direction: column; gap: 1rem;">
                        <i class="fas fa-comments" style="font-size: 2rem;"></i>
                        <span>리뷰 관리</span>
                        <small>(comments 테이블)</small>
                    </a>
                    
                    <a href="#" class="btn btn-outline" style="padding: 2rem; text-align: center; text-decoration: none; display: flex; flex-direction: column; gap: 1rem;">
                        <i class="fas fa-cog" style="font-size: 2rem;"></i>
                        <span>시스템 설정</span>
                        <small>(전체 테이블 관리)</small>
                    </a>
                </div>
            </section>
        </main>
    </div>
<script>
function submitForm() {
    document.getElementById('periodForm').submit();
}
</script>
</body>
</html> 