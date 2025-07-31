package vo;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * 사용자 정보를 담는 VO 클래스
 * users 테이블과 매핑
 */
public class UserVO {
    
    // 기본키
    private Long memberNum;          // 회원 고유 번호 (자동 증가)
    
    // 로그인 정보
    private String username;         // 사용자명 (로그인용, 중복 불가)
    private String password;         // 비밀번호 (암호화 저장)
    private String email;            // 이메일 주소 (중복 불가)
    
    // 개인 정보
    private String name;             // 실명
    private String phone;            // 전화번호
    private Date birthDate;          // 생년월일
    private String gender;           // 성별 (M:남성, F:여성)
    
    // 계정 정보
    private String userType;         // 사용자 타입 (USER, HOTEL_MANAGER, ADMIN)
    
    // 시간 정보
    private Timestamp createdAt;     // 가입 일시
    private Timestamp updatedAt;     // 정보 수정 일시
    
    // 기본 생성자
    public UserVO() {}
    
    // 회원가입용 생성자
    public UserVO(String username, String password, String email, String name, 
                  String phone, Date birthDate, String gender, String userType) {
        this.username = username;
        this.password = password;
        this.email = email;
        this.name = name;
        this.phone = phone;
        this.birthDate = birthDate;
        this.gender = gender;
        this.userType = userType;
    }
    
    // 전체 필드 생성자
    public UserVO(Long memberNum, String username, String password, String email, String name,
                  String phone, Date birthDate, String gender, String userType,
                  Timestamp createdAt, Timestamp updatedAt) {
        this.memberNum = memberNum;
        this.username = username;
        this.password = password;
        this.email = email;
        this.name = name;
        this.phone = phone;
        this.birthDate = birthDate;
        this.gender = gender;
        this.userType = userType;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getter & Setter
    public Long getMemberNum() {
        return memberNum;
    }
    
    public void setMemberNum(Long memberNum) {
        this.memberNum = memberNum;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public Date getBirthDate() {
        return birthDate;
    }
    
    public void setBirthDate(Date birthDate) {
        this.birthDate = birthDate;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public String getUserType() {
        return userType;
    }
    
    public void setUserType(String userType) {
        this.userType = userType;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // 편의 메서드들
    
    /**
     * 사용자 타입이 일반 사용자인지 확인
     */
    public boolean isUser() {
        return "USER".equals(this.userType);
    }
    
    /**
     * 사용자 타입이 호텔 매니저인지 확인
     */
    public boolean isHotelManager() {
        return "HOTEL_MANAGER".equals(this.userType);
    }
    
    /**
     * 사용자 타입이 관리자인지 확인
     */
    public boolean isAdmin() {
        return "ADMIN".equals(this.userType);
    }
    
    /**
     * 성별을 한글로 반환
     */
    public String getGenderName() {
        if ("M".equals(this.gender)) {
            return "남성";
        } else if ("F".equals(this.gender)) {
            return "여성";
        } else {
            return "미정";
        }
    }
    
    /**
     * 사용자 타입을 한글로 반환
     */
    public String getUserTypeName() {
        switch (this.userType) {
            case "USER":
                return "일반 사용자";
            case "HOTEL_MANAGER":
                return "호텔 매니저";
            case "ADMIN":
                return "관리자";
            default:
                return "미정";
        }
    }
    
    @Override
    public String toString() {
        return "UserVO{" +
                "memberNum=" + memberNum +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", name='" + name + '\'' +
                ", phone='" + phone + '\'' +
                ", birthDate=" + birthDate +
                ", gender='" + gender + '\'' +
                ", userType='" + userType + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        UserVO userVO = (UserVO) obj;
        return memberNum != null && memberNum.equals(userVO.memberNum);
    }
    
    @Override
    public int hashCode() {
        return memberNum != null ? memberNum.hashCode() : 0;
    }
} 