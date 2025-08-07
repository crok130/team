package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import utils.DBCPUtil;
import utils.GmailAuthenticator;

@WebServlet("/find-password")
public class FindPasswordServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 비밀번호 찾기 페이지로 이동
        request.getRequestDispatcher("find-password.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "checkUsername":
                    handleCheckUsername(request, response, out);
                    break;
                case "verifyCode":
                    handleVerifyCode(request, response, out);
                    break;
                case "resendCode":
                    handleResendCode(request, response, out);
                    break;
                case "changePassword":
                    handleChangePassword(request, response, out);
                    break;
                default:
                    sendJsonResponse(out, false, "잘못된 요청입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(out, false, "오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    // 아이디 확인 및 이메일 조회
    private void handleCheckUsername(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws SQLException, MessagingException {
        
        String username = request.getParameter("username");
        
        if (username == null || username.trim().isEmpty()) {
            sendJsonResponse(out, false, "아이디를 입력해주세요.");
            return;
        }
        
        // 아이디로 이메일 조회 (일반 사용자만)
        String sql = "SELECT email FROM users WHERE username = ? AND user_type = 'USER'";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String email = rs.getString("email");
                
                // 세션에 사용자 정보 저장
                HttpSession session = request.getSession();
                session.setAttribute("findPassword_username", username);
                session.setAttribute("findPassword_email", email);
                
                // 인증코드 생성 및 발송
                String verificationCode = generateVerificationCode();
                session.setAttribute("findPassword_code", verificationCode);
                session.setAttribute("findPassword_codeTime", System.currentTimeMillis());
                
                // 이메일 발송
                sendVerificationEmail(email, verificationCode);
                
                sendJsonResponse(out, true, "이메일로 인증번호를 발송했습니다.", email);
            } else {
                sendJsonResponse(out, false, "존재하지 않는 아이디입니다.");
            }
        }
    }
    
    // 인증코드 확인
    private void handleVerifyCode(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        
        String inputCode = request.getParameter("code");
        HttpSession session = request.getSession();
        
        if (inputCode == null || inputCode.trim().isEmpty()) {
            sendJsonResponse(out, false, "인증번호를 입력해주세요.");
            return;
        }
        
        String storedCode = (String) session.getAttribute("findPassword_code");
        Long codeTime = (Long) session.getAttribute("findPassword_codeTime");
        
        if (storedCode == null || codeTime == null) {
            sendJsonResponse(out, false, "인증번호가 만료되었습니다. 다시 시도해주세요.");
            return;
        }
        
        // 10분 제한 확인
        long currentTime = System.currentTimeMillis();
        if (currentTime - codeTime > 10 * 60 * 1000) { // 10분
            session.removeAttribute("findPassword_code");
            session.removeAttribute("findPassword_codeTime");
            sendJsonResponse(out, false, "인증번호가 만료되었습니다. 다시 시도해주세요.");
            return;
        }
        
        if (inputCode.equals(storedCode)) {
            // 인증 성공
            session.setAttribute("findPassword_verified", true);
            session.removeAttribute("findPassword_code");
            session.removeAttribute("findPassword_codeTime");
            sendJsonResponse(out, true, "이메일 인증이 완료되었습니다.");
        } else {
            sendJsonResponse(out, false, "인증번호가 올바르지 않습니다.");
        }
    }
    
    // 인증코드 재발송
    private void handleResendCode(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws MessagingException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("findPassword_email");
        
        if (email == null) {
            sendJsonResponse(out, false, "사용자 정보를 찾을 수 없습니다. 처음부터 다시 시도해주세요.");
            return;
        }
        
        // 새로운 인증코드 생성 및 발송
        String verificationCode = generateVerificationCode();
        session.setAttribute("findPassword_code", verificationCode);
        session.setAttribute("findPassword_codeTime", System.currentTimeMillis());
        
        // 이메일 발송
        sendVerificationEmail(email, verificationCode);
        
        sendJsonResponse(out, true, "인증번호를 재발송했습니다.");
    }
    
    // 비밀번호 변경
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws SQLException {
        
        String newPassword = request.getParameter("newPassword");
        HttpSession session = request.getSession();
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            sendJsonResponse(out, false, "새 비밀번호를 입력해주세요.");
            return;
        }
        
        // 비밀번호 유효성 검사
        if (!isValidPassword(newPassword)) {
            sendJsonResponse(out, false, "비밀번호는 8자 이상이며, 대문자, 소문자, 숫자, 특수문자를 포함해야 합니다.");
            return;
        }
        
        // 이메일 인증 확인
        Boolean isVerified = (Boolean) session.getAttribute("findPassword_verified");
        if (isVerified == null || !isVerified) {
            sendJsonResponse(out, false, "이메일 인증이 필요합니다.");
            return;
        }
        
        String username = (String) session.getAttribute("findPassword_username");
        if (username == null) {
            sendJsonResponse(out, false, "사용자 정보를 찾을 수 없습니다. 처음부터 다시 시도해주세요.");
            return;
        }
        
        // 비밀번호 변경
        String sql = "UPDATE users SET password = ? WHERE username = ? AND user_type = 'USER'";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setString(2, username);
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                // 세션 정리
                session.removeAttribute("findPassword_username");
                session.removeAttribute("findPassword_email");
                session.removeAttribute("findPassword_verified");
                
                sendJsonResponse(out, true, "비밀번호가 성공적으로 변경되었습니다.");
            } else {
                sendJsonResponse(out, false, "비밀번호 변경에 실패했습니다.");
            }
        }
    }
    
    // 인증코드 생성 (6자리 숫자)
    private String generateVerificationCode() {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }
    
    // 이메일 발송
    private void sendVerificationEmail(String email, String code) throws MessagingException {
        // GmailAuthenticator 활용
        GmailAuthenticator authenticator = new GmailAuthenticator();
        Properties props = authenticator.getProps();
        
        Session session = Session.getInstance(props, authenticator);
        
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(authenticator.getUser()));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
        message.setSubject("[호텔 예약 시스템] 비밀번호 찾기 인증번호");
        
        String emailContent = String.format(
            "안녕하세요,\n\n" +
            "비밀번호 찾기를 위한 인증번호입니다.\n\n" +
            "인증번호: %s\n\n" +
            "이 인증번호는 10분간 유효합니다.\n" +
            "본인이 요청하지 않은 경우 이 메일을 무시하세요.\n\n" +
            "감사합니다.",
            code
        );
        
        message.setText(emailContent);
        
        Transport.send(message);
    }
    
    // 비밀번호 유효성 검사
    private boolean isValidPassword(String password) {
        if (password.length() < 8) return false;
        
        boolean hasUppercase = password.matches(".*[A-Z].*");
        boolean hasLowercase = password.matches(".*[a-z].*");
        boolean hasNumber = password.matches(".*\\d.*");
        boolean hasSpecial = password.matches(".*[!@#$%^&*(),.?\":{}|<>].*");
        
        return hasUppercase && hasLowercase && hasNumber && hasSpecial;
    }
    
    // JSON 응답 전송
    private void sendJsonResponse(PrintWriter out, boolean success, String message) {
        sendJsonResponse(out, success, message, null);
    }
    
    private void sendJsonResponse(PrintWriter out, boolean success, String message, String email) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": ").append(success).append(",");
        json.append("\"message\": \"").append(message).append("\"");
        if (email != null) {
            json.append(",\"email\": \"").append(email).append("\"");
        }
        json.append("}");
        
        out.print(json.toString());
        out.flush();
    }
}
