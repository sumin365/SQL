
/*
사용자 생성
	CREATE USER C##NAMSK IDENTIFIED BY 1234;
	- Oracle: 사용자 생성 -> 동일 이름의 SCHEMA도 같이 생성
사용자 삭제
	DROP USER C##NAMSK
	DROP USER C##NAMSK CASCADE  - 연결된 객체도 모두 삭제
권한을 가지지 않으면 아무 일도 못해요
*/

-- system으로 진행
-- 사용자 정보 확인
-- USER_USERS: 현재 사용자 관련 정보
-- ALL_USERS: DB의 모든 사용자 정보
-- DBA_USERS: 모든 사용자의 상세 정보(DBA Only)

-- 현재 사용자 확인
SELECT * FROM USER_USERS;
--  전체 사용자 확인
SELECT * FROM ALL_USERS;

-- 로그인 권한 부여
GRANT create session TO C##SUMIN;--  C##NAMSK에게 세션 생성(로그인) 권한을 부여

/* 로그인 해서 다음의 쿼리를 수행해 봅니다.
cmd 에서 작성하기
테이블을 만들어가야함 
CREATE TABLE test(a NUMBER); 라고 치기-- 권한 불충분하다고 뜸
--그래서 일반적으로 두가지 권한을 줘야함
GRANT CONNECT, RESOURCE TO C##SUMIN; 라고 치기 
*/
GRANT connect, resource TO C##SUMIN;    --  접속과 자원 접근 롤을 C##NAMSK에게 부여

/* 다시 로그인 해서 다음의 쿼리를 수행해 봅니다.
CREATE TABLE test(a NUMBER); 치기-- 테이블이 생성
SELECT * FROM tab; 치기-
DESC test; 치기-
INSERT INTO test VALUES(10); 치기-
-- 테이블 스페이스 'USERS'에 대한 권한이 없습니다.라고 나옴
*/ 

/*
보충 설명
Oracle 12이후
    - 일반 계정 구분하기 위해 C## 접두어
    - CONNECT, RESOURCE권한이 있다하더라도
    - 실제 데이터가 저장될 테이블 스페이스 마련해 줘야 한다 - USERS 테이블 스페이스에 공간을 마련
*/
/* C## 없이 계정을 생성하는 방법 - 팁 */
ALTER SESSION SET "_ORACLE_SCRIPT" = true;
CREATE USER SUMIN IDENTIFIED BY 1234; 
/* 사용자 데이터 저장 테이블 스페이스 부여 */
ALTER USER C##SUMIN DEFAULT TABLESPACE USERS    -- C##NAMSK 사용자의 저장 공간을 USERS에 마련
    QUOTA unlimited ON USERS;   --  저장 공간 한도를 무한으로 부여



-- ROLE의 생성
DROP ROLE dbuser;
CREATE ROLE dbuser; --  dbuser 역할을 만들어 여러개의 권한을 담아둔다
GRANT create session TO dbuser;   --  dbuser 역할에 접속할 수 있는 권한을 부여
GRANT resource TO dbuser;       --  dbuser 역할에 자원 생성 권한을 부여

-- ROLE을 GRANT 하면 내부에 있는 개별 Privilege(권한)이 모두 부여
GRANT dbuser TO SUMIN;      --  namsk 사용자에게 dbuser 역할을 부여
-- 권한의 회수 REVOKE 
REVOKE dbuser FROM SUMIN;   --  namsk 사용자로부터 dbuser 역할을 회수

-- 계정 삭제
DROP USER SUMIN CASCADE;


--13/37
-- 현재 사용자에게 부여된 ROLE 확인
-- 사용자 계정으로 로그인
show user;
SELECT * FROM user_role_privs;

-- CONNECT 역할에는 어떤 권한이 포함되어 있는가?
DESC role_sys_privs;
SELECT * FROM role_sys_privs WHERE role='CONNECT';  -- CONNECT롤이 포함하고 있는 권한
SELECT * FROM role_sys_privs WHERE role='RESOURCE'; --CREATE TABLE가 있어서 테이블 만들수 있는 권한도 있음

SHOW USER;
-- System 계정으로 진행   오른쪽위에 바꿔~~
-- HR 계정의 employees 테이블의 조회 권한을 C##SUMIN에게 부여하고 싶다면
GRANT SELECT ON hr.employees TO C##SUMIN; 

-- C#SUMIN으로 바꿔~~~
SHOW USER;
SELECT * FROM hr.employees; --  hr.employees의 SELECT 권한을 부여받았으므로 테이블 조회 가능
