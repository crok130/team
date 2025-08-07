package vo;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Arrays;

/**
 * 게시글 정보를 담는 VO 클래스
 * posts 테이블과 매핑
 */
public class PostVO {
    
    // 기본키: 게시글 고유 ID (자동 증가)
    private int postId;
    
    // 관계 정보: 부모 게시글 ID (계층 구조용), 작성자 회원번호
    private Long parentId;
    private Long memberNum;
    private String file;


	// 게시글 기본 정보
    private String postType;         // 게시글 타입 (HOTEL, ROOM_TYPE, FACILITY, IMAGE, NOTICE, EVENT, REVIEW)
    private String title;            // 제목
    private String content;          // 내용
    
    // 호텔 관련 정보
    private String address;          // 주소 (호텔용)
    private String city;             // 도시 (호텔용)
    private String country;          // 국가 (호텔용)
    private String phone;            // 전화번호 (호텔용)
    
    // 객실 관련 정보
    private int[] price;             // 가격 (객실타입용, 1박 기준)
    private int[] room_count;        // 객실 개수 (객실타입용)
    private int prices;


	// 이미지 관련 정보
    private String imageUrl;         // 이미지 URL (이미지용)
    private String[] fileName;       // 파일명 (이미지용)
    
    // 표시 정보
    private Integer displayOrder;    // 표시 순서
    private Long viewCount;          // 조회수
    
    // 시간 정보
    private Timestamp createdAt;     // 작성 일시
    private Timestamp updatedAt;     // 수정 일시
    
    // 게시글 타입 상수
    public static final String TYPE_HOTEL = "HOTEL";         // 호텔 게시글 타입
    public static final String TYPE_ROOM_TYPE = "ROOM_TYPE"; // 객실타입 게시글 타입
    public static final String TYPE_FACILITY = "FACILITY";   // 시설 게시글 타입
    public static final String TYPE_IMAGE = "IMAGE";         // 이미지 게시글 타입
    public static final String TYPE_NOTICE = "NOTICE";       // 공지사항 게시글 타입
    public static final String TYPE_EVENT = "EVENT";         // 이벤트 게시글 타입
    public static final String TYPE_REVIEW = "REVIEW";       // 리뷰 게시글 타입
    
    // 기본 생성자
    public PostVO() {}
    
    // 호텔 게시글용 생성자
    public PostVO(Long memberNum, String title, String content, String address, 
                  String city, String country, String phone) {
        this.memberNum = memberNum;
        this.postType = TYPE_HOTEL;
        this.title = title;
        this.content = content;
        this.address = address;
        this.city = city;
        this.country = country;
        this.phone = phone;
        this.displayOrder = 0;
        this.viewCount = 0L;
    }
    
    // 객실타입 게시글용 생성자
    public PostVO(Long parentId, Long memberNum,String title, String content, int[] price) {
        this.parentId = parentId;
        this.memberNum = memberNum;
        this.postType = TYPE_ROOM_TYPE;
        this.title = title;
        this.content = content;
        this.price = price;
        this.displayOrder = 0;
        this.viewCount = 0L;
    }
    
    // 시설 게시글용 생성자
    public PostVO(Long parentId, Long memberNum, String title, String content, Integer displayOrder) {
        this.parentId = parentId;
        this.memberNum = memberNum;
        this.postType = TYPE_FACILITY;
        this.title = title;
        this.content = content;
        this.displayOrder = displayOrder;
        this.viewCount = 0L;
    }
    
    // 전체 필드 생성자
    public PostVO(int postId, Long parentId, Long memberNum, String postType, String title,
                  String content, String address, String city, String country, String phone,
                  int[] price, String imageUrl, String[] fileName, Integer displayOrder,
                  Long viewCount, Timestamp createdAt, Timestamp updatedAt) {
        this.postId = postId;
        this.parentId = parentId;
        this.memberNum = memberNum;
        this.postType = postType;
        this.title = title;
        this.content = content;
        this.address = address;
        this.city = city;
        this.country = country;
        this.phone = phone;
        this.price = price;
        this.imageUrl = imageUrl;
        this.fileName = fileName;
        this.displayOrder = displayOrder;
        this.viewCount = viewCount;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getter & Setter
    /**
     * 게시글 고유 번호 반환/설정
     */
    public int getPostId() {
        return postId;
    }
    public void setPostId(int postId) {
        this.postId = postId;
    }

    public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}
    /**
     * 부모 게시글 ID 반환/설정 (계층 구조용)
     */
    public Long getParentId() {
        return parentId;
    }
    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    
    public int getPrices() {
		return prices;
	}

	public void setPrices(int prices) {
		this.prices = prices;
	}
    /**
     * 작성자 회원번호 반환/설정
     */
    public Long getMemberNum() {
        return memberNum;
    }
    public void setMemberNum(Long memberNum) {
        this.memberNum = memberNum;
    }
    
    /**
     * 게시글 타입 반환/설정
     */
    public String getPostType() {
        return postType;
    }
    public void setPostType(String postType) {
        this.postType = postType;
    }

    /**
     * 게시글 제목 반환/설정
     */
    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * 게시글 내용 반환/설정
     */
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }

    /**
     * 호텔 주소 반환/설정
     */
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    /**
     * 호텔 도시 반환/설정
     */
    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }

    /**
     * 호텔 국가 반환/설정
     */
    public String getCountry() {
        return country;
    }
    public void setCountry(String country) {
        this.country = country;
    }

    /**
     * 호텔 전화번호 반환/설정
     */
    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    /**
     * 객실 가격 배열 반환/설정
     */
    public int[] getPrice() {
        return price;
    }
    public void setPrice(int[] price) {
        this.price = price;
    }

    /**
     * 이미지 URL 반환/설정
     */
    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    /**
     * 이미지 파일명 배열 반환/설정
     */
    public String[] getFileName() {
        return fileName;
    }
    public void setFileName(String[] fileName) {
        this.fileName = fileName;
    }

    /**
     * 게시글 표시 순서 반환/설정
     */
    public Integer getDisplayOrder() {
        return displayOrder;
    }
    public void setDisplayOrder(Integer displayOrder) {
        this.displayOrder = displayOrder;
    }

    /**
     * 게시글 조회수 반환/설정
     */
    public Long getViewCount() {
        return viewCount;
    }
    public void setViewCount(Long viewCount) {
        this.viewCount = viewCount;
    }

    /**
     * 게시글 작성일시 반환/설정
     */
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    /**
     * 게시글 수정일시 반환/설정
     */
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    /**
     * 객실 개수 배열 반환/설정
     */
    public int[] getRoom_count() {
        return room_count;
    }
    public void setRoom_count(int[] room_count) {
        this.room_count = room_count;
    }

    // 편의 메서드들
    /**
     * 호텔 게시글인지 확인
     */
    public boolean isHotel() {
        return TYPE_HOTEL.equals(this.postType);
    }

    /**
     * 객실타입 게시글인지 확인
     */
    public boolean isRoomType() {
        return TYPE_ROOM_TYPE.equals(this.postType);
    }

    /**
     * 시설 게시글인지 확인
     */
    public boolean isFacility() {
        return TYPE_FACILITY.equals(this.postType);
    }

    /**
     * 이미지 게시글인지 확인
     */
    public boolean isImage() {
        return TYPE_IMAGE.equals(this.postType);
    }

    /**
     * 공지사항 게시글인지 확인
     */
    public boolean isNotice() {
        return TYPE_NOTICE.equals(this.postType);
    }

    /**
     * 이벤트 게시글인지 확인
     */
    public boolean isEvent() {
        return TYPE_EVENT.equals(this.postType);
    }

    /**
     * 리뷰 게시글인지 확인
     */
    public boolean isReview() {
        return TYPE_REVIEW.equals(this.postType);
    }

    /**
     * 최상위 게시글인지 확인 (부모가 없음)
     */
    public boolean isTopLevel() {
        return this.parentId == null;
    }

    /**
     * 하위 게시글인지 확인 (부모가 있음)
     */
    public boolean isChild() {
        return this.parentId != null;
    }

    /**
     * 게시글 타입을 한글로 반환
     */
    public String getPostTypeName() {
        switch (this.postType) {
            case TYPE_HOTEL:
                return "호텔";
            case TYPE_ROOM_TYPE:
                return "객실타입";
            case TYPE_FACILITY:
                return "시설";
            case TYPE_IMAGE:
                return "이미지";
            case TYPE_NOTICE:
                return "공지사항";
            case TYPE_EVENT:
                return "이벤트";
            case TYPE_REVIEW:
                return "리뷰";
            default:
                return "기타";
        }
    }

    /**
     * 조회수 증가 (호출 시 1 증가)
     */
    public void incrementViewCount() {
        if (this.viewCount == null) {
            this.viewCount = 1L;
        } else {
            this.viewCount++;
        }
    }

	@Override
	public String toString() {
		return "PostVO [postId=" + postId + ", parentId=" + parentId + ", memberNum=" + memberNum + ", postType=" + postType + ", title=" + title + ", content=" + content + ", address="
				+ address + ", city=" + city + ", country=" + country + ", phone=" + phone + ", price="
				+ Arrays.toString(price) + ", room_count=" + Arrays.toString(room_count) + ", imageUrl=" + imageUrl
				+ ", fileName=" + Arrays.toString(fileName) + ", displayOrder=" + displayOrder + ", viewCount="
				+ viewCount + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + "]";
	}

    


}