package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doLogout(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doLogout(request, response);
    }
    
    private void doLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. 세션 가져오기
        HttpSession session = request.getSession(false);
        
        String userType = null;
        if (session != null) {
            // 사용자 타입 저장 (세션 무효화 전에)
            userType = (String) session.getAttribute("userType");
            
            // 2. 세션 무효화
            session.invalidate();
        }
        
        // 3. 자동 로그인 쿠키 삭제
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            String[] autoLoginCookieNames = {"autoLogin_username", "autoLogin_userType", "autoLogin_memberNum"};
            for (Cookie cookie : cookies) {
                for (String cookieName : autoLoginCookieNames) {
                    if (cookieName.equals(cookie.getName())) {
                        cookie.setValue("");
                        cookie.setMaxAge(0);
                        cookie.setPath("/");
                        response.addCookie(cookie);
                    }
                }
            }
        }
        
        // 4. 사용자 타입에 따른 리다이렉트
        String redirectUrl = request.getParameter("redirect");
        
        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            // 특정 페이지로 리다이렉트 (기존 기능 유지)
            response.sendRedirect(redirectUrl);
        } else {
            // 사용자 타입에 따른 자동 리다이렉트
            if ("ADMIN".equals(userType) || "HOTEL_MANAGER".equals(userType)) {
                // 관리자/호텔 매니저는 관리자 로그인 페이지로
                response.sendRedirect("admin-login.jsp");
            } else {
                // 일반 사용자는 메인 페이지로
                response.sendRedirect("index.jsp");
            }
        }
    }
} 