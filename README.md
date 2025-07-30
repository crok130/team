# 🏨 Hotel Booking System

<div align="center">

![Java](https://img.shields.io/badge/Java-21-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)
![Oracle](https://img.shields.io/badge/Oracle-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)

**🌟 JSP와 Java 21을 사용한 모던 호텔 예약 시스템 🌟**

*사용자는 호텔을 검색하고 예약할 수 있으며, 호텔 매니저는 관리자 대시보드를 통해 예약과 매출을 관리할 수 있습니다.*

</div>

---

## 👥 팀 구성 및 역할 분담

<table align="center">
<tr>
<td align="center"><b>🔐 김진영</b></td>
<td align="center"><b>🏨 박석우</b></td>
<td align="center"><b>💳 최수빈</b></td>
<td align="center"><b>📊 김효진</b></td>
</tr>
<tr>
<td align="center"><b>사용자 인증</b></td>
<td align="center"><b>호텔 등록 관리</b></td>
<td align="center"><b>예약 시스템</b></td>
<td align="center"><b>관리자 기능</b></td>
</tr>
<tr>
<td>
• 로그인/로그아웃<br>
• 회원가입 (이메일 인증)<br>
• 사용자 관리<br>
• 세션 관리
</td>
<td>
• 호텔 등록 시스템<br>
• 호텔 정보 관리<br>
• 호텔 이미지 업로드<br>
• 편의시설 관리<br>
• 호텔 검색 기능
</td>
<td>
• 호텔 예약<br>
• 결제 시스템<br>
• 예약 관리<br>
• 결제 검증
</td>
<td>
• 호텔 매니저 승인/거부<br>
• 통계 대시보드<br>
• 매출 분석<br>
• 시스템 관리
</td>
</tr>
</table>

---

## 🗄️ 데이터베이스 구조

### 📋 주요 테이블
| 테이블 | 설명 | 주요 컬럼 |
|--------|------|-----------|
| 👥 **users** | 사용자 정보 | `user_id`, `email`, `password`, `user_type` |
| 🏨 **hotels** | 호텔 정보 | `hotel_id`, `name`, `description`, `address`, `rating` |
| 📅 **reservations** | 예약 정보 | `reservation_id`, `user_id`, `hotel_id`, `status` |
| 📈 **sales_statistics** | 매출 통계 | `stat_id`, `hotel_name`, `revenue`, `period` |

### 🔑 주요 Enum 값
- **사용자 타입**: `USER`, `HOTEL_MANAGER`, `ADMIN`
- **예약 상태**: `PENDING`, `CONFIRMED`, `CHECKED_IN`, `CHECKED_OUT`, `CANCELLED`, `NO_SHOW`
- **호텔 등급**: `1성급`, `2성급`, `3성급`, `4성급`, `5성급`

---

## 🏗️ 프로젝트 구조

```
🏨 hotel/
├── 📄 README.md
├── 📁 src/
│   └── 📁 main/
│       ├── 📁 java/                      # ☕ Java 소스 코드 (백엔드 로직)
│       └── 📁 webapp/                    # 🌐 웹 애플리케이션 루트
│           ├── 🏠 index.jsp              # 메인 홈페이지
│           ├── 🔐 login.jsp              # 로그인 페이지
│           ├── 📝 register.jsp           # 회원가입 페이지
│           ├── 🏨 hotels.jsp             # 호텔 목록/검색
│           ├── 🏨 hotel-register.jsp     # 호텔 등록 페이지
│           ├── 📅 reservations.jsp       # 예약 페이지
│           ├── 👑 admin-login.jsp        # 관리자 로그인
│           ├── 👥 admin-register.jsp     # 관리자 회원가입
│           ├── 🏛️ admin-main.jsp         # 관리자 메인페이지
│           ├── 📊 admin-dashboard.jsp    # 관리자 대시보드
│           ├── 📁 META-INF/
│           │   └── ⚙️ MANIFEST.MF
│           └── 📁 WEB-INF/
│               ├── 📚 lib/               # 라이브러리
│               └── ⚙️ web.xml            # 웹 설정
```

---

## 📱 페이지별 기능

### 🏠 **index.jsp** - 메인 홈페이지
> **🎯 목적**: 사용자의 첫 진입점, 호텔 검색 및 서비스 소개
- ✨ **주요 기능**: 호텔 검색, 인기 호텔 표시, 서비스 소개
- 🎨 **특징**: 반응형 디자인, 직관적인 검색 폼, 호텔 추천 섹션

### 🔐 **login.jsp** - 로그인 페이지
> **🎯 목적**: 사용자 인증 및 세션 관리
- ✨ **주요 기능**: 이메일/비밀번호 로그인, 비밀번호 찾기
- 🎨 **특징**: 이메일 검증, 로그인 상태 유지, 관리자 페이지 연결

### 📝 **register.jsp** - 회원가입 페이지
> **🎯 목적**: 신규 사용자 등록
- ✨ **주요 기능**: 사용자 정보 입력, 이메일 인증
- 🎨 **특징**: 
  - 📋 단계별 가입 프로세스
  - 📧 이메일 인증 시스템
  - 🔒 비밀번호 강도 체크
  - 👤 사용자 유형 선택
  - ✅ 약관 동의

### 🏨 **hotels.jsp** - 호텔 목록/검색
> **🎯 목적**: 호텔 검색 및 상세 정보 제공
- ✨ **주요 기능**: 호텔 검색, 필터링, 정렬, 페이징
- 🎨 **특징**:
  - 🔍 검색 필터 (가격, 별점, 편의시설, 호텔타입)
  - 🏷️ 호텔 카드 레이아웃
  - 🖼️ 이미지 갤러리
  - ⭐ 평점 및 리뷰 표시

### 🏨 **hotel-register.jsp** - 호텔 등록 페이지
> **🎯 목적**: 호텔 매니저의 호텔 등록 신청
- ✨ **주요 기능**: 호텔 정보 등록, 이미지 업로드, 편의시설 선택
- 🎨 **특징**:
  - 📋 단계별 호텔 정보 입력
  - 📷 메인/추가 이미지 업로드
  - 🗺️ 위치 정보 입력
  - 💰 가격 정보 설정
  - 🎯 편의시설 다중 선택

### 📅 **reservations.jsp** - 예약 페이지
> **🎯 목적**: 호텔 예약 프로세스 관리
- ✨ **주요 기능**: 예약 정보 입력, 결제 처리
- 🎨 **특징**:
  - 📆 날짜/인원 선택
  - 🛏️ 객실 타입 선택
  - 👤 투숙객 정보 입력
  - 💳 결제 정보 입력
  - 💰 실시간 가격 계산

### 📄 **post-detail.jsp** - 호텔 상세/등록 페이지
> **🎯 목적**: 호텔 상세 정보 표시 및 호텔 등록 (매니저용)
- ✨ **주요 기능**: 
  - 🏨 호텔 상세 정보 표시
  - ✍️ 호텔 등록/수정 폼 (`?action=write` 파라미터로 전환)
  - 📷 이미지 갤러리
  - ⭐ 평점 및 리뷰 표시
- 🎨 **특징**: 조건부 렌더링으로 다목적 페이지 구현

### 💬 **reviews.jsp** - 리뷰 관리 페이지
> **🎯 목적**: 호텔 리뷰 작성 및 관리
- ✨ **주요 기능**: 리뷰 작성, 평점 등록, 리뷰 목록 표시
- 🎨 **특징**:
  - ⭐ 5점 평점 시스템
  - 📝 상세 리뷰 작성
  - 📷 리뷰 사진 첨부
  - 🔍 리뷰 검색 및 필터링
  - 👍 리뷰 좋아요/신고 기능

### 👑 **admin-login.jsp** - 관리자 로그인
> **🎯 목적**: 관리자 전용 로그인
- ✨ **주요 기능**: 관리자 인증, 권한 검증
- 🎨 **특징**: 일반 로그인과 구분된 관리자 전용 UI

### 👥 **admin-register.jsp** - 관리자 회원가입
> **🎯 목적**: 호텔 매니저 계정 등록
- ✨ **주요 기능**: 호텔 매니저 정보 입력, 사업자 정보 등록
- 🎨 **특징**: 호텔 관련 추가 정보 입력 폼

### 🏛️ **admin-main.jsp** - 관리자 메인페이지
> **🎯 목적**: 관리자 로그인 후 메인 허브 페이지
- ✨ **주요 기능**: 관리 기능 네비게이션, 빠른 통계 확인
- 🎨 **특징**:
  - 📊 빠른 통계 카드 (회원수, 호텔수, 예약수, 승인대기)
  - 🎯 메뉴 카드 그리드 (6개 주요 관리 기능)
  - 🎨 모던한 카드 레이아웃
  - 📱 반응형 디자인

### 📊 **admin-dashboard.jsp** - 관리자 대시보드
> **🎯 목적**: 상세 통계 분석 및 데이터 모니터링
- ✨ **주요 기능**: 상세 통계 대시보드, 회원 관리, 호텔 승인
- 🎨 **특징**:
  - 📱 반응형 사이드바
  - 📈 실시간 통계 차트
  - ✅ 회원 승인/거부 시스템
  - 📋 예약 현황 모니터링

---

## 🛠️ 기술 스택

### 🎨 Frontend
| 기술 | 버전 | 용도 |
|------|------|------|
| ![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white) | HTML5 | 시맨틱 마크업 |
| ![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white) | CSS3 | 모던 스타일링, Flexbox, Grid |
| ![FontAwesome](https://img.shields.io/badge/Font%20Awesome-339AF0?style=flat-square&logo=fontawesome&logoColor=white) | 6.0+ | 아이콘 |

### ⚙️ Backend
| 기술 | 버전 | 용도 |
|------|------|------|
| ![Java](https://img.shields.io/badge/Java-21-ED8B00?style=flat-square&logo=java&logoColor=white) | 21 | 백엔드 로직 |
| ![JSP](https://img.shields.io/badge/JSP-007396?style=flat-square&logo=java&logoColor=white) | 3.1+ | 서버사이드 렌더링 |
| ![Oracle](https://img.shields.io/badge/Oracle-F80000?style=flat-square&logo=oracle&logoColor=white) | 21c | 데이터베이스 |
| ![JDBC](https://img.shields.io/badge/JDBC-007396?style=flat-square&logo=java&logoColor=white) | - | 데이터베이스 연결 |

### 🚀 서버 & 개발 도구
| 기술 | 버전 | 용도 |
|------|------|------|
| ![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=flat-square&logo=apache-tomcat&logoColor=black) | 10+ | 웹 서버 |
관리 |
| ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white) | - | 코드 저장소 & 협업 |

---

## ✨ 디자인 특징

<div align="center">

### 🎨 **모던 UI/UX**
**카드 레이아웃** • **부드러운 애니메이션** • **직관적인 인터페이스**

### 📱 **반응형 디자인**  
**모바일** • **태블릿** • **데스크톱** 모든 기기 지원

### ♿ **접근성 고려**
**시맨틱 HTML** • **키보드 네비게이션** • **명확한 피드백**

</div>

---

## 🚀 주요 기능

### 👤 사용자 기능
- ✅ **회원가입/로그인**: 이메일 인증 시스템
- 🔍 **호텔 검색**: 다양한 필터와 정렬 옵션
- 📅 **예약 시스템**: 단계별 예약 프로세스

### 🏨 호텔 매니저 기능
- 🏨 **호텔 등록**: 호텔 정보 등록 및 관리
- 📷 **이미지 관리**: 호텔 사진 업로드 및 수정
- 📊 **예약 현황**: 자신의 호텔 예약 관리
- 💹 **매출 분석**: 자기 호텔 수익 및 매출 분석

### 👑 관리자 기능
- 📊 **대시보드**: 실시간 통계 모니터링
- 👥 **회원 관리**: 호텔 매니저 승인/거부
- 📋 **예약 관리**: 전체 예약 현황 및 상태 관리
- 🛠️ **시스템 관리**: 전반적인 시스템 운영 관리

---

## ⚡ 설치 및 실행

### 📋 환경 요구사항
```bash
☕ Java 21+
🗄️ Oracle Database 21c+
🚀 Apache Tomcat 11+
```

### 🗄️ 데이터베이스 설정
```sql
-- 1. Oracle DB에 스키마 생성
-- 2. 제공된 SQL 스크립트 실행
-- 3. 테이블 및 초기 데이터 생성
```

### 🚀 프로젝트 실행
```bash
# 1. 프로젝트 클론
git clone [repository-url]

# 2. Tomcat 서버에 배포
cp -r hotel/ $TOMCAT_HOME/webapps/

# 3. 서버 시작
$TOMCAT_HOME/bin/startup.sh

# 4. 브라우저에서 접속
http://localhost:8080/hotel
```

---

## 🌐 브라우저 지원

<div align="center">

![Chrome](https://img.shields.io/badge/Chrome-80+-4285F4?style=for-the-badge&logo=google-chrome&logoColor=white)
![Firefox](https://img.shields.io/badge/Firefox-75+-FF7139?style=for-the-badge&logo=firefox&logoColor=white)
![Safari](https://img.shields.io/badge/Safari-13+-000000?style=for-the-badge&logo=safari&logoColor=white)
![Edge](https://img.shields.io/badge/Edge-80+-0078D4?style=for-the-badge&logo=microsoft-edge&logoColor=white)

</div>

---

## 📄 라이선스

<div align="center">

📚 **이 프로젝트는 교육 목적으로 제작되었습니다.**

*팀 프로젝트를 통한 웹 개발 실습 및 협업 경험*

---

**Made with ❤️ by Team Hotel**

</div> 