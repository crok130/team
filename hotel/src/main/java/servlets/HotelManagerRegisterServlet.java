package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;
import utils.DBCPUtil;

@WebServlet("/hotel-manager-register")
public class HotelManagerRegisterServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 회원가입 폼 페이지로 이동
        request.getRequestDispatcher("admin-register.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 파라미터 받기
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String birthDate = request.getParameter("birthDate");
        String gender = request.getParameter("gender");
        String userType = request.getParameter("userType");
        String agreeTerms = request.getParameter("agreeTerms");
        String agreePrivacy = request.getParameter("agreePrivacy");
        
        String msg = "";
        boolean success = false;
        
        try {
            // 1. 유효성 검사
            if (!validateInputs(username, password, confirmPassword, name, agreeTerms, agreePrivacy)) {
                msg = "입력 정보를 확인해주세요.";
            } else if (!password.equals(confirmPassword)) {
                msg = "비밀번호가 일치하지 않습니다.";
            } else if (!isValidPassword(password)) {
                msg = "비밀번호는 8자 이상이며, 영문, 숫자, 특수문자를 포함해야 합니다.";
            } else if (isDuplicate(username)) {
                msg = "이미 사용 중인 사용자명입니다.";
            } else {
                // 2. 호텔 매니저 회원가입
                success = registerHotelManager(username, password, name, phone, birthDate, gender);
                
                if (success) {
                    msg = "호텔 매니저 계정 신청이 완료되었습니다. 관리자 승인 후 사용 가능합니다.";
                    response.sendRedirect("admin-login.jsp?success=true");
                    return;
                } else {
                    msg = "회원가입 중 오류가 발생했습니다.";
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            msg = "회원가입 중 오류가 발생했습니다: " + e.getMessage();
        }
        
        // 에러 시 입력값 유지
        request.setAttribute("msg", msg);
        request.setAttribute("username", username);
        request.setAttribute("name", name);
        request.setAttribute("phone", phone);
        request.setAttribute("birthDate", birthDate);
        request.setAttribute("gender", gender);
        
        request.getRequestDispatcher("admin-register.jsp").forward(request, response);
    }
    
    // 입력값 유효성 검사
    private boolean validateInputs(String username, String password, String confirmPassword, 
                                 String name, String agreeTerms, String agreePrivacy) {
        return username != null && !username.trim().isEmpty() &&
               password != null && !password.trim().isEmpty() &&
               confirmPassword != null && !confirmPassword.trim().isEmpty() &&
               name != null && !name.trim().isEmpty() &&
               agreeTerms != null && agreePrivacy != null;
    }
    
    // 비밀번호 복잡도 검증
    private boolean isValidPassword(String password) {
        // 8자 이상, 영문+숫자+특수문자 포함
        String passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,}$";
        return password.matches(passwordRegex);
    }
    
    // 중복 체크
    private boolean isDuplicate(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    // 호텔 매니저 회원가입
    private boolean registerHotelManager(String username, String password, String name, 
                                       String phone, String birthDate, String gender) throws SQLException {
        
        String sql = "INSERT INTO users (username, password, name, phone, birth_date, gender, user_type, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'HOTEL_MANAGER', 'PENDING')";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password); // 실제로는 암호화해야 함
            pstmt.setString(3, name);
            pstmt.setString(4, phone);
            pstmt.setString(5, birthDate);
            pstmt.setString(6, gender);
            
            int result = pstmt.executeUpdate();
            return result == 1;
        }
    }
} 