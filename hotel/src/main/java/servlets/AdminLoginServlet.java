package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;
import utils.DBCPUtil;

@WebServlet("/admin-login")
public class AdminLoginServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 로그인 폼 페이지로 이동
        request.getRequestDispatcher("admin-login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 파라미터 받기
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        String msg = "";
        
        try {
            // 1. 유효성 검사
            if (username == null || username.trim().isEmpty() || 
                password == null || password.trim().isEmpty()) {
                msg = "모든 필드를 입력해주세요.";
            } else {
                // 2. 사용자 인증 및 타입 확인
                String userType = authenticateAndGetUserType(username, password, request);
                
                if (userType != null) {
                    // 3. 세션에 사용자 정보 저장 (authenticateAndGetUserType에서 이미 저장됨)
                    // userType, username, memberNum, name이 이미 세션에 저장되어 있음
                    
                    // 4. 관리자 대시보드로 리다이렉트
                    response.sendRedirect("admin-dashboard.jsp");
                    return;
                    
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            msg = "로그인 중 오류가 발생했습니다: " + e.getMessage();
        }
        
        // 에러 시 입력값 유지
        request.setAttribute("msg", msg);
        request.setAttribute("username", username);
        
        request.getRequestDispatcher("admin-login.jsp").forward(request, response);
    }
    
    // 사용자 인증 및 타입 조회
    private String authenticateAndGetUserType(String username, String password, HttpServletRequest request) throws SQLException {
        String sql = "SELECT member_num, username, name, user_type, status FROM users " +
                     "WHERE username = ? AND password = ? AND user_type IN ('ADMIN', 'HOTEL_MANAGER')";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password); // 실제로는 암호화된 비밀번호와 비교해야 함
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("status");
                
                // 상태 확인
                if ("REJECTED".equals(status)) {
                    request.setAttribute("msg", "승인 거절되었습니다. 관리자에게 문의하세요.");
                    return null;
                } else if ("PENDING".equals(status)) {
                    request.setAttribute("msg", "계정이 승인 대기 중입니다. 관리자 승인 후 로그인 가능합니다.");
                    return null;
                } else if ("APPROVED".equals(status)) {
                    // 세션에 추가 정보 저장
                    HttpSession session = request.getSession();
                    session.setAttribute("memberNum", rs.getInt("member_num"));
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("name", rs.getString("name"));
                    session.setAttribute("userType", rs.getString("user_type"));
                    return rs.getString("user_type");
                } else {
                    request.setAttribute("msg", "계정 상태가 올바르지 않습니다.");
                    return null;
                }
            }
        }
        return null;
    }
} 