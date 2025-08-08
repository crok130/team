package servlets;

import java.io.*;
import java.sql.*;
import java.util.Random;
import java.util.Properties;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import utils.DBCPUtil;
import utils.GmailAuthenticator;
import jakarta.mail.*;
import jakarta.mail.internet.*;

@WebServlet("/find-password")
public class FindPasswordServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // GET 요청은 비밀번호 찾기 페이지로 리다이렉트
        response.sendRedirect("find-password.jsp");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");
        
        try {
            if ("checkUsername".equals(action)) {
                handleCheckUsername(request, response, out);
            } else if ("sendVerificationCode".equals(action)) {
                handleSendVerificationCode(request, response, out);
            } else if ("verifyCode".equals(action)) {
                handleVerifyCode(request, response, out);
            } else if ("changePassword".equals(action)) {
                handleChangePassword(request, response, out);
            } else {
                sendJsonResponse(out, false, "잘못된 요청입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(out, false, "오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    // 1단계: 아이디 확인
    private void handleCheckUsername(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws SQLException {
        String username = request.getParameter("username");
        
        System.out.println("아이디 확인 요청 받음: " + username);
        
        if (username == null || username.trim().isEmpty()) {
            System.out.println("아이디가 비어있음");
            sendJsonResponse(out, false, "아이디를 입력해주세요.");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBCPUtil.getConnection();
            String sql = "SELECT member_num, email FROM users WHERE username = ?";
            System.out.println("실행할 SQL: " + sql + " (username: " + username + ")");
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int memberNum = rs.getInt("member_num");
                String email = rs.getString("email");
                
                System.out.println("사용자 찾음 - member_num: " + memberNum + ", email: " + email);
                
                // 세션에 사용자 정보 저장
                HttpSession session = request.getSession();
                session.setAttribute("reset_member_num", memberNum);
                session.setAttribute("reset_email", email);
                session.setAttribute("reset_username", username);
                
                sendJsonResponse(out, true, "아이디가 확인되었습니다. 이메일로 인증번호를 발송합니다.", email);
            } else {
                System.out.println("존재하지 않는 아이디: " + username);
                sendJsonResponse(out, false, "존재하지 않는 아이디입니다.");
            }
        } catch (SQLException e) {
            System.out.println("SQL 오류: " + e.getMessage());
            e.printStackTrace();
            sendJsonResponse(out, false, "데이터베이스 오류가 발생했습니다.");
        } finally {
            DBCPUtil.close(rs, pstmt, conn);
        }
    }
    
    // 2단계: 인증번호 발송
    private void handleSendVerificationCode(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws SQLException, MessagingException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("reset_email");
        
        if (email == null) {
            sendJsonResponse(out, false, "사용자 정보를 찾을 수 없습니다. 다시 시도해주세요.");
            return;
        }
        
        // 6자리 랜덤 인증번호 생성
        String verificationCode = generateVerificationCode();
        
        // 세션에 인증번호 저장
        session.setAttribute("verification_code", verificationCode);
        session.setAttribute("verification_time", System.currentTimeMillis());
        
        // GmailAuthenticator를 활용한 이메일 발송
        sendVerificationEmail(email, verificationCode);
        
        sendJsonResponse(out, true, "인증번호가 이메일로 발송되었습니다.");
    }
    
    // 3단계: 인증번호 확인
    private void handleVerifyCode(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        String inputCode = request.getParameter("verificationCode");
        HttpSession session = request.getSession();
        
        String storedCode = (String) session.getAttribute("verification_code");
        Long verificationTime = (Long) session.getAttribute("verification_time");
        
        if (storedCode == null || verificationTime == null) {
            sendJsonResponse(out, false, "인증번호가 만료되었습니다. 다시 발송해주세요.");
            return;
        }
        
        // 10분 제한 시간 확인
        long currentTime = System.currentTimeMillis();
        if (currentTime - verificationTime > 600000) { // 10분 = 600,000ms
            session.removeAttribute("verification_code");
            session.removeAttribute("verification_time");
            sendJsonResponse(out, false, "인증번호가 만료되었습니다. 다시 발송해주세요.");
            return;
        }
        
        if (storedCode.equals(inputCode)) {
            session.setAttribute("code_verified", true);
            sendJsonResponse(out, true, "인증번호가 확인되었습니다.");
        } else {
            sendJsonResponse(out, false, "인증번호가 일치하지 않습니다.");
        }
    }
    
    // 4단계: 새 비밀번호 설정
    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, PrintWriter out) 
            throws SQLException {
        
        HttpSession session = request.getSession();
        Boolean codeVerified = (Boolean) session.getAttribute("code_verified");
        Integer memberNum = (Integer) session.getAttribute("reset_member_num");
        
        if (codeVerified == null || !codeVerified || memberNum == null) {
            sendJsonResponse(out, false, "인증이 필요합니다.");
            return;
        }
        
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            sendJsonResponse(out, false, "새 비밀번호를 입력해주세요.");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            sendJsonResponse(out, false, "비밀번호가 일치하지 않습니다.");
            return;
        }
        
        if (newPassword.length() < 6) {
            sendJsonResponse(out, false, "비밀번호는 6자리 이상이어야 합니다.");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBCPUtil.getConnection();
            String sql = "UPDATE users SET password = ? WHERE member_num = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, memberNum);
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                // 세션 정리
                session.removeAttribute("reset_member_num");
                session.removeAttribute("reset_email");
                session.removeAttribute("reset_username");
                session.removeAttribute("verification_code");
                session.removeAttribute("verification_time");
                session.removeAttribute("code_verified");
                
                sendJsonResponse(out, true, "비밀번호가 성공적으로 변경되었습니다.");
            } else {
                sendJsonResponse(out, false, "비밀번호 변경에 실패했습니다.");
            }
        } finally {
            DBCPUtil.close(pstmt, conn);
        }
    }
    
    // 인증번호 생성 (6자리 숫자)
    private String generateVerificationCode() {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }
    
    // GmailAuthenticator를 활용한 인증번호 이메일 발송
    private void sendVerificationEmail(String email, String verificationCode) throws MessagingException {
        // GmailAuthenticator 인스턴스 생성
        GmailAuthenticator authenticator = new GmailAuthenticator();
        
        // GmailAuthenticator에서 SMTP 설정 가져오기
        Properties props = authenticator.getProps();
        
        // 메일 세션 생성 (GmailAuthenticator 사용)
        Session session = Session.getInstance(props, authenticator);
        
        // 메일 메시지 생성
        Message message = new MimeMessage(session);
        
        // 발신자 설정 (GmailAuthenticator에서 사용자 이메일 가져오기)
        message.setFrom(new InternetAddress(authenticator.getUser()));
        
        // 수신자 설정
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
        
        // 메일 제목
        message.setSubject("[호텔 예약 시스템] 비밀번호 재설정 인증번호");
        
        // 메일 내용
        String emailContent = String.format(
            "안녕하세요,\n\n" +
            "비밀번호 재설정을 위한 인증번호를 발송합니다.\n\n" +
            "인증번호: %s\n\n" +
            "이 인증번호는 10분간 유효합니다.\n" +
            "인증번호를 입력하여 비밀번호를 재설정해주세요.\n\n" +
            "감사합니다.",
            verificationCode
        );
        
        message.setText(emailContent);
        
        // 메일 발송
        Transport.send(message);
    }
    
    // JSON 응답 전송 (기본)
    private void sendJsonResponse(PrintWriter out, boolean success, String message) {
        sendJsonResponse(out, success, message, null);
    }
    
    // JSON 응답 전송 (데이터 포함)
    private void sendJsonResponse(PrintWriter out, boolean success, String message, String data) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": ").append(success).append(",");
        json.append("\"message\": \"").append(message).append("\"");
        if (data != null) {
            json.append(",\"data\": \"").append(data).append("\"");
        }
        json.append("}");
        
        String response = json.toString();
        System.out.println("JSON 응답 전송: " + response);
        
        out.print(response);
        out.flush();
    }
}
