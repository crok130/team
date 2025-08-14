/**
	게시글 작성 (호텔 등록, 대용량 내용 저장)
	게시글(호텔, 객실, 시설) 등록 시 제목(title), 내용(content), 작성자(member_num) 저장
	시설(대용량 텍스트도 CLOB 필드에 저장 가능)
*/


package servlets;

import java.io.*;
import java.util.*;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import utils.*;
import vo.*;
import java.sql.*;

@WebServlet("/upload")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
maxFileSize = 1024 * 1024 * 10,      // 10MB
maxRequestSize = 1024 * 1024 * 50)   // 50MB

public class uploadservlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// 호텔 등록 폼에서 받은 데이터를 처리하는 doPost 메서드
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 호텔 관련 변수 선언 (폼 데이터 수신용)
		String title = null;
		String phone = null;
		String content = null;
		String address = null;
		String city = null;
		String country = null;
		String[] roomTypes = null;
		String[] room_price_str = null;
		String[] room_count_str = null;
		String[] room_content = null;
		int[] room_prices = null;
		int[] room_count = null;
		int result = 0;
		int hotelPostId = 0; // 호텔 등록 후 생성된 post_id를 저장할 변수
		ServletContext application = request.getServletContext();
		String uploadPath = application.getRealPath("/img");
		List<String> filenames = new ArrayList<>();
		
		// 시설명 및 시설설명 등록
		String[] facility_titles = request.getParameterValues("facility_titles");
		String[] facility_contents = request.getParameterValues("facility_contents");

		String msg = "";
		// 업로드 폴더가 없으면 생성
		File file = new File(uploadPath);
		if(!file.exists()) {
			file.mkdirs();
		}
		
		// 세션에서 "memberNum" 가져와서 문자열 -> 정수로 변환
		HttpSession session = request.getSession(); 			 // 세션 객체 얻기
		Object memberNumObj = session.getAttribute("memberNum"); // 세션에서 "memberNum" 값 꺼내기

		int memberNum = 0; // 기본값 (예외처리용)
		int parentId =0;
		if (memberNumObj != null) {
		    // toString()으로 String 변환 후, Integer.parseInt()로 정수 변환
		    memberNum = Integer.parseInt(memberNumObj.toString());
		    System.out.println("member num : " + memberNum);
		} else {
		    // 로그인이 안되어 있거나 세션에 값이 없으면 예외처리
		    request.setAttribute("msg", "로그인 후 이용 가능합니다.");
		    request.getRequestDispatcher("admin-login.jsp").forward(request, response);
		    return;
		}
		
		
		// 업로드된 파트 모두 request 하여 가져오기
		Collection<Part> parts = request.getParts();
		
		/**
			이 코드는 여러 개의 이미지 파일을 업로드할 때
			각각의 파일을 서버에 고유한 이름으로 저장하고, 저장된 파일명 리스트를 만들어
			나중에 DB에 저장하거나 화면에 출력할 때 사용할 수 있도록 준비하는 역할
		*/
		// 1. 업로드 된 모든 파트(폼 데이터 / 파일 등) 반복
		for (Part part : parts) {
			// 2. 현재 파트(파일)의 크기(바이트)를 가져옴
		    long size = part.getSize();	
		    // 3. 파트 이름이 'image_files'라면(이미지 파일만 처리)
		    if (part.getName().equals("image_files")) {
		    	// 4. 파일 크기가 0보다 크면(실제 업로드된 파일이 있을 때)
		        if (size > 0) {
		            // 실제 파일 이름 가져오기
		        	// 5. 업로드된 원본 파일명 추출
		            String originalFileName = part.getSubmittedFileName();

		            // UUID로 고유한 파일 이름 생성
		            // 6. 랜덤 UUID 생성(고유값)
		            UUID uid = UUID.randomUUID();
		            // 7. UUID와 원본 파일명을 결합해서 고유한 파일명 생성(중복 방지)
		            String uniqueFileName = uid.toString().replace("-", "") + "_" + originalFileName;

		            // 저장 경로 설정
		            // 8. 저장경로에 파일명 추가
		            String saveFile = uploadPath + File.separator + uniqueFileName;
		            // 9. 파일 저장
		            part.write(saveFile);
		            // 10. 임시 파일 삭제(서버 메모리 정리)
		            part.delete();
		            
		            // 리스트에 파일 이름 추가
		            // 11. 저장된 파일명을 리스트에 추가(DB 저장/추후 사용 목적)
		            filenames.add(uniqueFileName);
		        }
		    }

		 // 일반 폼 데이터 파라미터 처리 (호텔 정보 및 객실 정보)
			if(part.getContentType() == null || part.getSubmittedFileName() == null) {
				title = request.getParameter("hotel_title");
				phone = request.getParameter("hotel_phone");
				content = request.getParameter("hotel_content");
				address = request.getParameter("hotel_address");
				city = request.getParameter("hotel_city");
				country = request.getParameter("hotel_country");
				roomTypes = request.getParameterValues("room_titles"); // JSP의 배열 파라미터명과 일치
				room_price_str = request.getParameterValues("room_prices");
				room_count_str = request.getParameterValues("room_counts");
				room_content = request.getParameterValues("room_contents");
			}
		}
		
		// 객실 가격 배열 처리 (문자열 -> 정수 변환)
		if (room_price_str != null) {
		    room_prices = new int[room_price_str.length];
		    for (int i = 0; i < room_price_str.length; i++) {
		        try {
		            room_prices[i] = Integer.parseInt(room_price_str[i]);
		        } catch (NumberFormatException e) {
		            room_prices[i] = 0;
		        }
		    }
		}
		
		// 객실 개수 배열 처리(문자열 -> 정수 변환)
		if (room_count_str != null) {
			room_count = new int[room_count_str.length];
		    for (int i = 0; i < room_count_str.length; i++) {
		        try {
		        	room_count[i] = Integer.parseInt(room_count_str[i]);
		        } catch (NumberFormatException e) {
		        	room_count[i] = 0; 
		        }
		    }
		}
		 // 호텔 정보 VO에 담기
		PostVO vo = new PostVO();
		vo.setTitle(title);
		vo.setPhone(phone);
		vo.setContent(content);
		vo.setAddress(address);
		vo.setCity(city);
		vo.setCountry(country);
		vo.setPrices(room_prices);
		vo.setRoom_counts(room_count);
		
		// DB 연결 및 호텔 정보 insert
		Connection conn = DBCPUtil.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String joinedFilenames = String.join(",", filenames);
		
		try{
			// 1. 호텔 정보 등록
			String sql = "INSERT INTO posts (member_num, parent_id, post_type, title, content, address, city, country, phone, file_name)";
			sql += " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, memberNum);
			pstmt.setInt(2, parentId);
			pstmt.setString(3, "HOTEL");
			pstmt.setString(4, vo.getTitle());
			pstmt.setString(5, vo.getContent());
			pstmt.setString(6, vo.getAddress());
			pstmt.setString(7, vo.getCity());
			pstmt.setString(8, vo.getCountry());
			pstmt.setString(9, vo.getPhone());
			pstmt.setString(10, joinedFilenames);

			result = pstmt.executeUpdate();
			
			if(result == 1) {
				// 생성된 호텔의 post_id 가져오기 (별도 쿼리 사용)
				String selectSql = "SELECT post_id FROM posts WHERE member_num = ? AND post_type = 'HOTEL' AND title = ? AND phone = ? ORDER BY created_at DESC";
				pstmt = conn.prepareStatement(selectSql);
				pstmt.setInt(1, memberNum);
				pstmt.setString(2, vo.getTitle());
				pstmt.setString(3, vo.getPhone());
				rs = pstmt.executeQuery();
				
				if(rs.next()) {
					hotelPostId = rs.getInt("post_id");
					System.out.println("호텔 등록 성공, post_id: " + hotelPostId);
				}
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			msg = "호텔 등록 실패";
			System.out.println("호텔 등록 실패: " + e.getMessage());
		}finally {
			DBCPUtil.close(rs, pstmt, conn);
		}
		
		
		// 2. 객실 타입들 등록 (호텔 등록이 성공한 경우에만)
		if(hotelPostId > 0 && roomTypes != null && roomTypes.length > 0) {
			System.out.println("room 정보 삽입");
			String room_type = "ROOM_TYPE";
			conn = DBCPUtil.getConnection();
			try {
				String sql = "INSERT INTO posts (member_num, parent_id, post_type, title, content, price, room_count)";
				sql += " VALUES (?, ?, ?, ?, ?, ?, ?)";
				pstmt = conn.prepareStatement(sql);
				
				for(int i = 0; i < roomTypes.length; i++) {
					pstmt.setInt(1, memberNum); // member_num
					pstmt.setInt(2, hotelPostId); // 호텔의 post_id를 parent_id로 사용
					pstmt.setString(3, room_type);
					pstmt.setString(4, roomTypes[i]); // 객실 타입명
					pstmt.setString(5, room_content != null && i < room_content.length ? room_content[i] : ""); // 객실 설명
					pstmt.setInt(6, room_prices != null && i < room_prices.length ? room_prices[i] : 0); // 가격
					pstmt.setInt(7, room_count != null && i < room_count.length ? room_count[i] : 0); // 객실 개수
					result = pstmt.executeUpdate();
					if(result == 1) {
						System.out.println("객실 타입 등록 성공: " + roomTypes[i]);
					} else {
						System.out.println("객실 타입 등록 실패: " + roomTypes[i]);
					}
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				msg = "객실 타입 등록 실패";
				System.out.println("객실 타입 등록 실패: " + e.getMessage());
			} finally {
				DBCPUtil.close(pstmt, conn);
			}
			
			// facility 으로 포스트타입 만들기
			// 시설명 : title / 시설설명 : content
			
			// 3. 시설 등록 (호텔 등록이 성공한 경우에만)
			
			
			String facility = "FACILITY";
            if(hotelPostId > 0 && facility_titles != null && facility_titles.length > 0) {
                conn = DBCPUtil.getConnection();
                
                try {
                    String sql = "INSERT INTO posts (member_num, parent_id, post_type, title, content) VALUES (?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql);

                    for(int i = 0; i < facility_titles.length; i++) {
                        pstmt.setInt(1, memberNum); // member_num (로그인 연동 시 수정)
                        pstmt.setInt(2, hotelPostId); // parent_id: 호텔 post_id
                        pstmt.setString(3, facility);
                        pstmt.setString(4, facility_titles[i]); // 시설명
                        pstmt.setString(5, facility_contents != null && i < facility_contents.length ? facility_contents[i] : ""); // 시설설명
                        result = pstmt.executeUpdate();
                        if(result == 1) {
                            System.out.println("시설 등록 성공: " + facility_titles[i]);
                        } else {
                            System.out.println("시설 등록 실패: " + facility_titles[i]);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("시설 등록 실패: " + e.getMessage());
                } finally {
                    DBCPUtil.close(pstmt, conn);
                }
            }
			
		}
		if(hotelPostId > 0) {
			msg = "호텔 및 객실 타입 등록 성공";
		}
		
		request.setAttribute("msg", msg);
		request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
	}
}
