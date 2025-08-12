package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;
import java.sql.Date;
import utils.DBCPUtil;

@WebServlet("/user-register")
public class UserRegisterServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 회원가입 폼 페이지로 이동
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 파라미터 받기
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String birthDateStr = request.getParameter("birthDate");
        String gender = request.getParameter("gender");
        String userType = request.getParameter("userType");
        String agreeTerms = request.getParameter("agreeTerms");
        String agreePrivacy = request.getParameter("agreePrivacy");
        String agreeMarketing = request.getParameter("agreeMarketing");
        
        String msg = "";
        
        try {
            // 1. 유효성 검사
            if (!validateInputs(username, name, email, password, confirmPassword, agreeTerms, agreePrivacy)) {
                msg = "필수 항목을 모두 입력해주세요.";
            } else if (!password.equals(confirmPassword)) {
                msg = "비밀번호가 일치하지 않습니다.";
            } else if (!isPasswordValid(password)) {
                msg = "비밀번호는 8자 이상이며, 영문, 숫자, 특수문자를 포함해야 합니다.";
            } else if (isUsernameExists(username)) {
                msg = "이미 사용 중인 사용자명입니다.";
            } else if (isEmailExists(email)) {
                msg = "이미 등록된 이메일입니다.";
            } else {
                // 2. 이메일 인증 확인
                HttpSession session = request.getSession();
                Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
                String verificationEmail = (String) session.getAttribute("verificationEmail");
                
                if (emailVerified == null || !emailVerified || !email.equals(verificationEmail)) {
                    msg = "이메일 인증이 필요합니다.";
                } else {
                    // 3. 회원가입 처리
                    boolean registerSuccess = registerUser(username, name, email, password, phone, 
                                                        birthDateStr, gender, userType, agreeMarketing);
                    
                    if (registerSuccess) {
                        // 4. 인증 정보 삭제
                        session.removeAttribute("verificationCode");
                        session.removeAttribute("verificationEmail");
                        session.removeAttribute("verificationTime");
                        session.removeAttribute("emailVerified");
                        
                        // 5. 성공 메시지와 함께 로그인 페이지로 리다이렉트
                        request.setAttribute("msg", "회원가입이 완료되었습니다. 로그인해주세요.");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    } else {
                        msg = "회원가입 중 오류가 발생했습니다.";
                    }
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
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("birthDate", birthDateStr);
        request.setAttribute("gender", gender);
        request.setAttribute("userType", userType);
        if ("on".equals(agreeMarketing)) {
            request.setAttribute("agreeMarketing", "checked");
        }
        
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
    
    // 입력값 유효성 검사
    private boolean validateInputs(String username, String name, String email, 
                                 String password, String confirmPassword, 
                                 String agreeTerms, String agreePrivacy) {
        return username != null && !username.trim().isEmpty() &&
               name != null && !name.trim().isEmpty() &&
               email != null && !email.trim().isEmpty() &&
               password != null && !password.trim().isEmpty() &&
               confirmPassword != null && !confirmPassword.trim().isEmpty() &&
               "on".equals(agreeTerms) && "on".equals(agreePrivacy);
    }
    
    // 비밀번호 유효성 검사
    private boolean isPasswordValid(String password) {
        // 8자 이상, 영문, 숫자, 특수문자 포함
        return password.length() >= 8 && 
               password.matches(".*[a-zA-Z].*") && 
               password.matches(".*\\d.*") && 
               password.matches(".*[@$!%*#?&].*");
    }
    
    // 사용자명 중복 확인
    private boolean isUsernameExists(String username) throws SQLException {
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
    
    // 이메일 중복 확인
    private boolean isEmailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    // 회원가입 처리
    private boolean registerUser(String username, String name, String email, String password,
                               String phone, String birthDateStr, String gender, 
                               String userType, String agreeMarketing) throws SQLException {
        
        String sql = "INSERT INTO users (username, name, email, password, phone, birth_date, gender, user_type, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'APPROVED', SYSDATE)";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, name);
            pstmt.setString(3, email);
            pstmt.setString(4, password); // 실제로는 암호화해야 함
            pstmt.setString(5, phone);
            
            // 생년월일 처리
            if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
                pstmt.setDate(6, Date.valueOf(birthDateStr));
            } else {
                pstmt.setNull(6, Types.DATE);
            }
            
            pstmt.setString(7, gender);
            pstmt.setString(8, userType != null ? userType : "USER");
            
            int result = pstmt.executeUpdate();
            return result > 0;
        }
    }
}
