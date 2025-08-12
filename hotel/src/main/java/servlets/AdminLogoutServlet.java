package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/admin-logout")
public class AdminLogoutServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doLogout(request, response);
    }
    
    private void doLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. 세션 가져오기
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. 세션의 모든 속성 제거
            session.removeAttribute("memberNum");
            session.removeAttribute("username");
            session.removeAttribute("name");
            session.removeAttribute("userType");
            
            // 3. 세션 무효화
            session.invalidate();
        }
        
        // 4. 자동 로그인 쿠키 삭제
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
        
        // 5. 캐시 방지 헤더 설정
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        // 6. 어드민 메인 페이지로 리다이렉트
        response.sendRedirect("admin-main.jsp");
    }
}
