-- users 테이블에 status 컬럼 추가
ALTER TABLE users ADD status VARCHAR2(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED'));

-- 기존 데이터에 대해 status 업데이트
-- ADMIN과 USER는 자동으로 승인된 상태로 설정
UPDATE users SET status = 'APPROVED' WHERE user_type IN ('ADMIN', 'USER');

-- HOTEL_MANAGER는 기본적으로 PENDING 상태 유지
-- (이미 승인된 호텔 매니저가 있다면 수동으로 APPROVED로 변경)

-- status 컬럼에 대한 인덱스 생성
CREATE INDEX idx_users_status ON users(status);

-- 변경사항 커밋
COMMIT; 