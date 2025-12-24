<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 자동로그인 쿠키 확인
    boolean isAutoLogin = false;
    String autoLoginUserId = null;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("autoLogin".equals(cookie.getName())) {
                isAutoLogin = true;
                autoLoginUserId = cookie.getValue();
                break;
            }
        }
    }
    
    // 세션에서 사용자 정보 확인
    String username = (String)session.getAttribute("username");
    String name = (String)session.getAttribute("name");
    Integer memberNum = (Integer)session.getAttribute("memberNum");
    boolean isLoggedIn = (username != null) || isAutoLogin;
    
    // 자동로그인 쿠키가 있지만 세션이 없는 경우 세션에 사용자 정보 설정
    if (isAutoLogin && username == null && autoLoginUserId != null) {
        session.setAttribute("username", autoLoginUserId);
        isLoggedIn = true;
    }
%>

<!-- Header -->
<header class="header">
    <nav class="nav-container">
        <a href="index.jsp" class="logo">
            <i class="fas fa-hotel"></i> Hotel Booking
        </a>
        
        <ul class="nav-menu">
            <li><a href="index.jsp">홈</a></li>
            <li><a href="hotels.jsp">호텔 검색</a></li>
            <li><a href="reservations.jsp">예약 내역</a></li>
        </ul>
        
        <div class="auth-buttons">
            <% if (isLoggedIn) { %>
                <div class="user-dropdown">
                    <div class="user-info">
                        <i class="fas fa-user-circle"></i>
                        <span><%= name != null ? name : (username != null ? username : autoLoginUserId) %></span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="user-dropdown-content">
                        <a href="#">예약 내역</a>
                        <a href="logout.jsp">로그아웃</a>
                    </div>
                </div>
            <% } else { %>
                <a href="login.jsp" class="btn btn-outline">로그인</a>
                <a href="register.jsp" class="btn btn-primary">회원가입</a>
            <% } %>
        </div>
    </nav>
</header>
