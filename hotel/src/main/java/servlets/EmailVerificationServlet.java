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

@WebServlet("/email-verification")
public class EmailVerificationServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        
        if ("send".equals(action)) {
            // 인증번호 발송
            sendVerificationCode(request, response, email);
        } else if ("verify".equals(action)) {
            // 인증번호 확인
            verifyCode(request, response);
        }
    }
    
    // 인증번호 발송
    private void sendVerificationCode(HttpServletRequest request, HttpServletResponse response, String email) 
            throws ServletException, IOException {
        
        try {
            // 1. 이메일 중복 확인
            if (isEmailExists(email)) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"이미 등록된 이메일입니다.\"}");
                return;
            }
            
            // 2. 인증번호 생성 (6자리)
            String verificationCode = generateVerificationCode();
            
            // 3. 세션에 인증번호 저장
            HttpSession session = request.getSession();
            session.setAttribute("verificationCode", verificationCode);
            session.setAttribute("verificationEmail", email);
            session.setAttribute("verificationTime", System.currentTimeMillis());
            
            // 4. 이메일 발송
            boolean emailSent = sendEmail(email, verificationCode);
            
            if (emailSent) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":true,\"message\":\"인증번호가 발송되었습니다.\"}");
            } else {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"이메일 발송에 실패했습니다.\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"오류가 발생했습니다: " + e.getMessage() + "\"}");
        }
    }
    
    // 인증번호 확인
    private void verifyCode(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String inputCode = request.getParameter("code");
        HttpSession session = request.getSession();
        
        String storedCode = (String) session.getAttribute("verificationCode");
        Long verificationTime = (Long) session.getAttribute("verificationTime");
        
        // 인증번호 만료 확인 (10분)
        if (verificationTime == null || System.currentTimeMillis() - verificationTime > 600000) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"인증번호가 만료되었습니다. 다시 발송해주세요.\"}");
            return;
        }
        
        if (storedCode != null && storedCode.equals(inputCode)) {
            // 인증 성공
            session.setAttribute("emailVerified", true);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"message\":\"이메일 인증이 완료되었습니다.\"}");
        } else {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"인증번호가 올바르지 않습니다.\"}");
        }
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
    
    // 인증번호 생성
    private String generateVerificationCode() {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        
        for (int i = 0; i < 6; i++) {
            code.append(random.nextInt(10));
        }
        
        return code.toString();
    }
    
    // 이메일 발송
    private boolean sendEmail(String toEmail, String verificationCode) {
        try {
            GmailAuthenticator authenticator = new GmailAuthenticator();
            Properties props = authenticator.getProps();
            
            Session session = Session.getInstance(props, authenticator);
            Message message = new MimeMessage(session);
            
            // 발신자 설정
            message.setFrom(new InternetAddress(authenticator.getUser()));
            
            // 수신자 설정
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            
            // 제목 설정
            message.setSubject("[Hotel Booking System] 이메일 인증번호");
            
            // 내용 설정
            String content = "안녕하세요!\n\n" +
                           "Hotel Booking System 회원가입을 위한 이메일 인증번호입니다.\n\n" +
                           "인증번호: " + verificationCode + "\n\n" +
                           "이 인증번호는 10분간 유효합니다.\n" +
                           "본인이 요청하지 않은 경우 이 메일을 무시하세요.\n\n" +
                           "감사합니다.\n" +
                           "Hotel Booking System";
            
            message.setText(content);
            
            // 메일 발송
            Transport.send(message);
            
            return true;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
