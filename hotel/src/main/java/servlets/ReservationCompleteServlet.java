package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import utils.DBCPUtil;

@WebServlet("/reservation-complete")
public class ReservationCompleteServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            // 세션 체크
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("memberNum") == null) {
                sendJsonResponse(out, false, "로그인이 필요합니다.");
                return;
            }
            
            // 요청 파라미터 받기
            String memberNumStr = request.getParameter("member_num");
            String hotelPostIdStr = request.getParameter("hotel_post_id");
            String roomPostIdStr = request.getParameter("room_post_id");
            String checkInDate = request.getParameter("check_in_date");
            String checkOutDate = request.getParameter("check_out_date");
            String adultsStr = request.getParameter("adults");
            String childrenStr = request.getParameter("children");
            String totalAmountStr = request.getParameter("total_amount");
            String specialRequests = request.getParameter("special_requests");
            
            // 결제 정보
            String impUid = request.getParameter("imp_uid");
            String merchantUid = request.getParameter("merchant_uid");
            String paidAmountStr = request.getParameter("paid_amount");
            String applyNum = request.getParameter("apply_num");
            
            // 파라미터 검증
            if (memberNumStr == null || hotelPostIdStr == null || roomPostIdStr == null ||
                checkInDate == null || checkOutDate == null || totalAmountStr == null) {
                sendJsonResponse(out, false, "필수 정보가 누락되었습니다.");
                return;
            }
            
            // 데이터 변환
            int memberNum = Integer.parseInt(memberNumStr);
            int hotelPostId = Integer.parseInt(hotelPostIdStr);
            int roomPostId = Integer.parseInt(roomPostIdStr);
            int adults = adultsStr != null ? Integer.parseInt(adultsStr) : 1;
            int children = childrenStr != null ? Integer.parseInt(childrenStr) : 0;
            double totalAmount = Double.parseDouble(totalAmountStr);
            double paidAmount = paidAmountStr != null ? Double.parseDouble(paidAmountStr) : totalAmount;
            
            // 데이터베이스에 예약 정보 저장
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBCPUtil.getConnection();
                conn.setAutoCommit(false); // 트랜잭션 시작
                
                // 1. 예약 정보 저장 (reservations 테이블)
                String sql = "INSERT INTO reservations (member_num, hotel_post_id, room_post_id, " +
                           "check_in_date, check_out_date, adults, children, total_amount, " +
                           "special_requests, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED')";
                
                pstmt = conn.prepareStatement(sql, new String[]{"reservation_id"});
                pstmt.setInt(1, memberNum);
                pstmt.setInt(2, hotelPostId);
                pstmt.setInt(3, roomPostId);
                pstmt.setString(4, checkInDate);
                pstmt.setString(5, checkOutDate);
                pstmt.setInt(6, adults);
                pstmt.setInt(7, children);
                pstmt.setDouble(8, totalAmount);
                pstmt.setString(9, specialRequests);
                
                int result = pstmt.executeUpdate();
                
                if (result > 0) {
                    // 생성된 예약 ID 가져오기
                    rs = pstmt.getGeneratedKeys();
                    int reservationId = 0;
                    if (rs.next()) {
                        reservationId = rs.getInt(1);
                    }
                    
                    // 2. 결제 정보 저장 (별도 테이블이 있다면 여기에 추가)
                    // 현재는 예약 테이블에 결제 정보를 저장하지 않으므로 주석 처리
                    /*
                    String paymentSql = "INSERT INTO payments (reservation_id, imp_uid, merchant_uid, " +
                                      "paid_amount, apply_num) VALUES (?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(paymentSql);
                    pstmt.setInt(1, reservationId);
                    pstmt.setString(2, impUid);
                    pstmt.setString(3, merchantUid);
                    pstmt.setDouble(4, paidAmount);
                    pstmt.setString(5, applyNum);
                    pstmt.executeUpdate();
                    */
                    
                    conn.commit(); // 트랜잭션 커밋
                    
                    // 성공 응답
                    sendJsonResponse(out, true, "예약이 성공적으로 완료되었습니다.", 
                                   String.valueOf(reservationId));
                    
                } else {
                    conn.rollback();
                    sendJsonResponse(out, false, "예약 저장에 실패했습니다.");
                }
                
            } catch (SQLException e) {
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                e.printStackTrace();
                sendJsonResponse(out, false, "데이터베이스 오류가 발생했습니다: " + e.getMessage());
                
            } finally {
                if (conn != null) {
                    try {
                        conn.setAutoCommit(true);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                DBCPUtil.close(rs, pstmt, conn);
            }
            
        } catch (NumberFormatException e) {
            sendJsonResponse(out, false, "잘못된 데이터 형식입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(out, false, "오류가 발생했습니다: " + e.getMessage());
        }
    }
    
    private void sendJsonResponse(PrintWriter out, boolean success, String message) {
        sendJsonResponse(out, success, message, null);
    }
    
    private void sendJsonResponse(PrintWriter out, boolean success, String message, String data) {
        out.print("{\"success\":" + success + ",\"message\":\"" + message + "\"");
        if (data != null) {
            out.print(",\"data\":\"" + data + "\"");
        }
        out.print("}");
        out.flush();
    }
}
