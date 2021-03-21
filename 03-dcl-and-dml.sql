 
/*CMD에서
사용자 생성
	CREATE USER C##NAMSK IDENTIFIED BY 1234;
	- Oracle: 사용자 생성 -> 동일 이름의 SCHEMA도 같이 생성
사용자 삭제
	DROP USER C##NAMSK
	DROP USER C##NAMSK CASCADE  - 연결된 객체도 모두 삭제
권한을 가지지 않으면 아무 일도 못해요
*/
-- CMD에서  
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

CREATE USER C##SUMIN  IDENTIFIED BY 1234; 로그인 할 수 없는 상태
--적절한 권한을 부여해야한다. 
GRANT create session TO C##SUMIN;--  C##NAMSK에게 세션 생성(로그인) 권한을 부여

/* 로그인 해서 다음의 쿼리를 수행해 봅니다.
cmd 에서 작성하기
테이블을 만들어가야함 
CREATE TABLE test(a NUMBER); 라고 치기-- 권한 불충분하다고 뜸
--그래서 일반적으로 두가지 권한을 줘야함
GRANT CONNECT, RESOURCE TO C##SUMIN; 라고 여기에 치기 
*/
GRANT connect, resource TO C##SUMIN;    --  접속과 자원 접근 롤을 C##NAMSK에게 부여

/* 다시 로그인 해서 다음의 쿼리를 수행해 봅니다.
CMD에서 치기 
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
-- System 계정으로 진행   오른쪽위에서  바꿔~~
-- HR 계정의 employees 테이블의 조회 권한을 C##SUMIN에게 부여하고 싶다면
GRANT SELECT ON hr.employees TO C##SUMIN; --권한의 부여
REVOKE SELECT ON hr.employees FROM C##SUMIN; --권한의 회수 

-- C#SUMIN으로 바꿔~~~
SHOW USER;
SELECT * FROM hr.employees; --  hr.employees의 SELECT 권한을 부여받았으므로 테이블 조회 가능

--실제로 객체를 만들어볼꺼다


--04-17/37  : 테이블 만들고 두 테이블을 연결해 보자
----------
-- DDL
----------

-- 내가 가진 table 확인
SELECT * FROM tab;
-- 테이블의 구조 확인
DESC test;

-- 테이블 삭제
DROP TABLE test;
SELECT * FROM tab;
--  휴지통
PURGE RECYCLEBIN;   -- 삭제된 테이블은 휴지통에 보관

SELECT * FROM tab;

-- CREATE TABLE
CREATE TABLE book ( -- 컬럼 명세
    book_id NUMBER(5),  --  5자리 숫자
    title VARCHAR2(50), --  50글자 가변문자
    author VARCHAR2(10),    -- 10글자 가변문자열
    pub_date DATE DEFAULT SYSDATE   -- 기본값은 현재시간
);
DESC book;
 

 -- 서브쿼리를 활용한 테이블 생성
-- hr.employees 테이블을 기반으로 일부 데이터를 추출
--  새 테이블                                                                     ???????????????????????????????????????
SELECT * FROM hr.employees WHERE job_id like 'IT_%';

CREATE TABLE it_emps AS (
    SELECT * FROM hr.employees WHERE job_id like 'IT_%'
);

SELECT * FROM it_emps;

CREATE TABLE emp_summary AS (
    SELECT employee_id, 
        first_name || ' ' || last_name full_name,
        hire_date, salary
    FROM hr.employees    --hr계정의 employees
);
DESC emp_summary;
SELECT * FROM emp_summary;


------------------------------------------------------------------------
--29/37
-- author 테이블 
DESC book;
 CREATE TABLE author (
    author_id NUMBER(10),
    author_name VARCHAR2(100) NOT NULL, -- NULL일 수 없다
    author_desc VARCHAR2(500),
    PRIMARY KEY (author_id) -- author_id 컬럼을 PK로
);
DESC author;

-- book테이블에 author 테이블 연결을 위해
-- book 테이블의 author 컬럼을 삭제: DROP COLUMN
ALTER TABLE book
DROP COLUMN author;
DESC book;

-- author테이블 참조를 위한 author_id 컬럼을 book에 추가
ALTER TABLE book
ADD (author_id NUMBER(10));
DESC book;

-- book 테이블의 PK로 사용할 book_id도 NUMBER(10)으로 변경
ALTER TABLE book
MODIFY (book_id NUMBER(10));
DESC book;

-- 제약조건의 추가: ADD CONSTRAINT  그리고 그 뒤는 제약조건의 별명을 지어준다. 안지어줘도 되지만 안하면 오라클이 임의로 지정하기 떄문에 지정하기 
-- 그 뒷 내용은 :  book 테이블의 book_id를 PRIMARY KEY 제약조건 부여 하겠다라는 말이다. 
ALTER TABLE book
ADD CONSTRAINT pk_book_id PRIMARY KEY(book_id);
DESC book;

-- FOREIGN KEY 추가
-- book 테이블의 author_id가 author의 author_id를 참조
ALTER TABLE book
ADD CONSTRAINT
    fk_author_id FOREIGN KEY (author_id)
        REFERENCES author(author_id);
DESC book;

-- COMMENT 붙이기 
COMMENT ON TABLE book IS 'Book Information';
COMMENT ON TABLE author IS 'Author Information';

-- 테이블 커멘트 확인
SELECT * FROM user_tab_comments;
SELECT comments FROM user_tab_comments 
WHERE table_name='BOOK';

  --  35/37
--  Data Dictionary
-- Oracle은 내부에서 발생하는 모든 정로를 Data Dictionary에 담아두고 있다
--  계정별로 USER_(일반 사용자), ALL_(전체 사용자), DBA_(관리자 전용) 접근 범위를 제한함
-- 모든 딕셔너리 확인
SHOW user;
SELECT * FROM dictionary;

-- DBA_ 딕셔너리 확인
-- dba로 로그인 필요 as sysdba

-- 사용자 DB 객체 dictionary USER_OBJECTS
SELECT * FROM user_objects;
SELECT object_name, object_type FROM user_objects;
SELECT * FROM user_objects WHERE OBJECT_NAME='BOOK';

-- 제약조건 확인 dictionary USER_CONSTRAINTS
SELECT * FROM user_constraints;
-- 제약조건이 걸린 컬럼 확인
SELECT * FROM user_cons_columns;
 --------------------------------------------------------------------------------------------------------------------------
 
 