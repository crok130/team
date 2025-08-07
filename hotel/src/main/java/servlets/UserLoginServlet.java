package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;
import utils.DBCPUtil;

@WebServlet("/user-login")
public class UserLoginServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 로그인 폼 페이지로 이동
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 파라미터 받기
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        String autoLogin = request.getParameter("autoLogin");
        
        String msg = "";
        
        // 자동 로그인 처리 (쿠키에서 사용자 정보 확인)
        if ("true".equals(autoLogin)) {
            handleAutoLogin(request, response);
            return;
        }
        
        try {
            // 1. 로그인 인증
            String userType = authenticateUser(username, password, request);
            
            if (userType != null) {
                // 2. 세션에 사용자 정보 저장
                HttpSession session = request.getSession();
                
                // 사용자 정보 조회
                String sql = "SELECT member_num, username, name, email, user_type FROM users WHERE username = ?";
                try (Connection conn = DBCPUtil.getConnection();
                     PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    
                    pstmt.setString(1, username);
                    ResultSet rs = pstmt.executeQuery();
                    
                    if (rs.next()) {
                        session.setAttribute("memberNum", rs.getInt("member_num"));
                        session.setAttribute("username", rs.getString("username"));
                        session.setAttribute("name", rs.getString("name"));
                        session.setAttribute("email", rs.getString("email"));
                        session.setAttribute("userType", rs.getString("user_type"));
                        
                        // 3. 자동 로그인 처리
                        if ("on".equals(remember)) {
                            // 자동 로그인 쿠키 생성 (30일 유지) - 키-값 쌍으로 분리
                            int memberNum = rs.getInt("member_num");
                            
                            Cookie usernameCookie = new Cookie("autoLogin_username", username);
                            usernameCookie.setMaxAge(30 * 24 * 60 * 60); // 30일
                            usernameCookie.setPath("/");
                            response.addCookie(usernameCookie);
                            
                            Cookie userTypeCookie = new Cookie("autoLogin_userType", userType);
                            userTypeCookie.setMaxAge(30 * 24 * 60 * 60); // 30일
                            userTypeCookie.setPath("/");
                            response.addCookie(userTypeCookie);
                            
                            Cookie memberNumCookie = new Cookie("autoLogin_memberNum", String.valueOf(memberNum));
                            memberNumCookie.setMaxAge(30 * 24 * 60 * 60); // 30일
                            memberNumCookie.setPath("/");
                            response.addCookie(memberNumCookie);
                        } else {
                            // 기존 쿠키 삭제
                            deleteAutoLoginCookies(response);
                        }
                        
                        // 4. 사용자 타입에 따른 리다이렉트
                        if ("ADMIN".equals(userType) || "HOTEL_MANAGER".equals(userType)) {
                            response.sendRedirect("admin-dashboard");
                        } else {
                            response.sendRedirect("index.jsp");
                        }
                        return;
                    }
                }
            } else {
                msg = "아이디 또는 비밀번호가 올바르지 않습니다.";
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            msg = "로그인 중 오류가 발생했습니다: " + e.getMessage();
        }
        
        // 에러 시 입력값 유지
        request.setAttribute("msg", msg);
        request.setAttribute("username", username);
        if ("on".equals(remember)) {
            request.setAttribute("remember", "checked");
        }
        
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    // 사용자 인증 및 타입 반환
    private String authenticateUser(String username, String password, HttpServletRequest request) throws SQLException {
        String sql = "SELECT user_type, status FROM users WHERE username = ? AND password = ?";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String userType = rs.getString("user_type");
                String status = rs.getString("status");
                
                // 일반 사용자는 승인 상태와 관계없이 로그인 가능
                if ("USER".equals(userType)) {
                    return userType;
                }
                
                // 관리자/호텔 매니저는 승인 상태 확인
                if ("ADMIN".equals(userType) || "HOTEL_MANAGER".equals(userType)) {
                    if ("REJECTED".equals(status)) {
                        request.setAttribute("msg", "승인 거절되었습니다. 관리자에게 문의하세요.");
                        return null;
                    } else if ("PENDING".equals(status)) {
                        request.setAttribute("msg", "계정이 승인 대기 중입니다. 관리자 승인 후 로그인 가능합니다.");
                        return null;
                    } else if ("APPROVED".equals(status)) {
                        return userType;
                    }
                }
            }
        }
        return null;
    }
    
    // 자동 로그인 처리 (쿠키에서 사용자 정보 확인)
    private void handleAutoLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. 자동 로그인 쿠키 확인
        Cookie[] cookies = request.getCookies();
        String username = null;
        String userType = null;
        String memberNumStr = null;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("autoLogin_username".equals(cookie.getName())) {
                    username = cookie.getValue();
                } else if ("autoLogin_userType".equals(cookie.getName())) {
                    userType = cookie.getValue();
                } else if ("autoLogin_memberNum".equals(cookie.getName())) {
                    memberNumStr = cookie.getValue();
                }
            }
        }
        
        // 2. 필수 쿠키가 없으면 로그인 페이지로 리다이렉트
        if (username == null || userType == null || memberNumStr == null) {
            deleteAutoLoginCookies(response);
            response.sendRedirect("login.jsp");
            return;
        }
        
        // 3. 세션이 이미 있으면 대시보드로 리다이렉트
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            String sessionUserType = (String) session.getAttribute("userType");
            if ("ADMIN".equals(sessionUserType) || "HOTEL_MANAGER".equals(sessionUserType)) {
                response.sendRedirect("admin-dashboard");
            } else {
                response.sendRedirect("index.jsp");
            }
            return;
        }
        
        // 5. 사용자 정보 조회 및 세션 생성
        try {
            String sql = "SELECT member_num, username, name, email, user_type, status FROM users WHERE username = ?";
            
            try (Connection conn = DBCPUtil.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {
                
                pstmt.setString(1, username);
                ResultSet rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    String status = rs.getString("status");
                    String dbUserType = rs.getString("user_type");
                    
                                         // 쿠키의 사용자 타입과 DB의 사용자 타입이 일치하는지 확인
                     if (!userType.equals(dbUserType)) {
                         deleteAutoLoginCookies(response);
                         response.sendRedirect("login.jsp");
                         return;
                     }
                    
                                         // 쿠키의 회원번호와 DB의 회원번호가 일치하는지 확인
                     try {
                         int cookieMemberNum = Integer.parseInt(memberNumStr);
                         int dbMemberNum = rs.getInt("member_num");
                         if (cookieMemberNum != dbMemberNum) {
                             deleteAutoLoginCookies(response);
                             response.sendRedirect("login.jsp");
                             return;
                         }
                     } catch (NumberFormatException e) {
                         deleteAutoLoginCookies(response);
                         response.sendRedirect("login.jsp");
                         return;
                     }
                    
                    // 일반 사용자는 승인 상태와 관계없이 자동 로그인 가능
                    if ("USER".equals(dbUserType)) {
                        // 세션 생성 및 사용자 정보 저장
                        session = request.getSession();
                        session.setAttribute("memberNum", rs.getInt("member_num"));
                        session.setAttribute("username", rs.getString("username"));
                        session.setAttribute("name", rs.getString("name"));
                        session.setAttribute("email", rs.getString("email"));
                        session.setAttribute("userType", rs.getString("user_type"));
                        
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    
                    // 관리자/호텔 매니저는 승인 상태 확인
                    if ("ADMIN".equals(dbUserType) || "HOTEL_MANAGER".equals(dbUserType)) {
                                                 if ("REJECTED".equals(status)) {
                             // 거절된 계정은 쿠키 삭제 후 로그인 페이지로
                             deleteAutoLoginCookies(response);
                             response.sendRedirect("login.jsp?msg=rejected");
                             return;
                         } else if ("PENDING".equals(status)) {
                             // 대기 중인 계정은 쿠키 삭제 후 로그인 페이지로
                             deleteAutoLoginCookies(response);
                             response.sendRedirect("login.jsp?msg=pending");
                             return;
                        } else if ("APPROVED".equals(status)) {
                            // 세션 생성 및 사용자 정보 저장
                            session = request.getSession();
                            session.setAttribute("memberNum", rs.getInt("member_num"));
                            session.setAttribute("username", rs.getString("username"));
                            session.setAttribute("name", rs.getString("name"));
                            session.setAttribute("email", rs.getString("email"));
                            session.setAttribute("userType", rs.getString("user_type"));
                            
                            response.sendRedirect("admin-dashboard");
                            return;
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // 자동 로그인 실패 시 쿠키 삭제하고 로그인 페이지로
        deleteAutoLoginCookies(response);
        response.sendRedirect("login.jsp");
    }
    
    // 자동 로그인 쿠키 삭제
    private void deleteAutoLoginCookies(HttpServletResponse response) {
        String[] cookieNames = {"autoLogin_username", "autoLogin_userType", "autoLogin_memberNum"};
        
        for (String cookieName : cookieNames) {
            Cookie cookie = new Cookie(cookieName, "");
            cookie.setMaxAge(0);
            cookie.setPath("/");
            response.addCookie(cookie);
        }
    }
}
