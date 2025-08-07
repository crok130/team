package servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.sql.*;
import java.util.*;
import utils.DBCPUtil;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 세션 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userType") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        String userType = (String) session.getAttribute("userType");
        if (!"ADMIN".equals(userType)) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        try {
            // 대시보드 데이터 로드
            loadDashboardData(request);
            
            // 대시보드 페이지로 포워드
            request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "대시보드 로드 중 오류가 발생했습니다: " + e.getMessage());
            request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
        }
    }
    
    private void loadDashboardData(HttpServletRequest request) throws SQLException {
        // 1. 통계 데이터
        loadStatistics(request);
        
        // 2. 호텔 매니저 승인 대기 목록 (일반 회원은 제외)
        loadPendingRequests(request);
        
        // 3. 최근 활동
        loadRecentActivities(request);
    }
    
    private void loadStatistics(HttpServletRequest request) throws SQLException {
        String sql = "SELECT " +
                    "COUNT(*) as totalUsers, " +
                    "SUM(CASE WHEN user_type = 'USER' THEN 1 ELSE 0 END) as totalRegularUsers, " +
                    "SUM(CASE WHEN user_type = 'HOTEL_MANAGER' THEN 1 ELSE 0 END) as totalHotelManagers, " +
                    "SUM(CASE WHEN status = 'PENDING' AND user_type = 'HOTEL_MANAGER' THEN 1 ELSE 0 END) as pendingApprovals " +
                    "FROM users";
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                request.setAttribute("totalUsers", rs.getInt("totalUsers"));
                request.setAttribute("totalRegularUsers", rs.getInt("totalRegularUsers"));
                request.setAttribute("totalHotelManagers", rs.getInt("totalHotelManagers"));
                request.setAttribute("pendingApprovals", rs.getInt("pendingApprovals"));
            }
        }
    }
    
    private void loadPendingRequests(HttpServletRequest request) throws SQLException {
        String sql = "SELECT member_num, username, name, email, phone, created_at, status " +
                    "FROM users " +
                    "WHERE user_type = 'HOTEL_MANAGER' " +
                    "ORDER BY created_at DESC";
        
        List<UserRequest> pendingRequests = new ArrayList<>();
        
        try (Connection conn = DBCPUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                UserRequest userRequest = new UserRequest();
                userRequest.setMemberNum(rs.getInt("member_num"));
                userRequest.setUsername(rs.getString("username"));
                userRequest.setName(rs.getString("name"));
                userRequest.setEmail(rs.getString("email"));
                userRequest.setPhone(rs.getString("phone"));
                userRequest.setCreatedAt(rs.getTimestamp("created_at"));
                userRequest.setStatus(rs.getString("status"));
                pendingRequests.add(userRequest);
            }
        }
        
        request.setAttribute("pendingRequests", pendingRequests);
    }
    
    private void loadRecentActivities(HttpServletRequest request) throws SQLException {
        // 최근 활동은 임시로 빈 리스트로 설정
        List<RecentActivity> recentActivities = new ArrayList<>();
        request.setAttribute("recentActivities", recentActivities);
    }
    
    // 내부 클래스들
    public static class UserRequest {
        private int memberNum;
        private String username;
        private String name;
        private String email;
        private String phone;
        private Timestamp createdAt;
        private String status;
        
        // Getters and Setters
        public int getMemberNum() { return memberNum; }
        public void setMemberNum(int memberNum) { this.memberNum = memberNum; }
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        
        public Timestamp getCreatedAt() { return createdAt; }
        public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
    
    public static class RecentActivity {
        private Timestamp time;
        private String activityType;
        private String username;
        private String target;
        private String description;
        private String status;
        
        // Getters and Setters
        public Timestamp getTime() { return time; }
        public void setTime(Timestamp time) { this.time = time; }
        
        public String getActivityType() { return activityType; }
        public void setActivityType(String activityType) { this.activityType = activityType; }
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getTarget() { return target; }
        public void setTarget(String target) { this.target = target; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }
}