----------
-- DB 객체
----------

-- VIEW: 한개 혹은 복수 개의 테이블을 기반으로 함, 실제 데이터는 갖고 있지 않다
-- VIEW 생성을 위해서는 CREATE VIEW 권한이 필요
-- system으로 로그인
--cmd에 치기
GRANT CREATE VIEW TO C##SUMIN;  --  C##NAMSK에게 VIEW 생성 권한을 부여

-- Simple VIEW
--  단일 테이블 혹은 뷰를 기반으로 생성
--  제약조건 위반이 없다면 INSERT, UPDATE, DELETE 가능
-- employees 테이블로부터 department_id가 10인 사람들만 VIEW로 생성
-- 기반 테이블 생성
DELETE FROM emp_10;
CREATE TABLE emp_10
    AS SELECT employee_id, first_name, last_name, salary 
        FROM hr.employees;
        
SELECT * FROM emp_10; --확인

CREATE OR REPLACE VIEW view_emp_10
    AS SELECT * FROM emp_10; -- 기반 테이블 emp_10
    
DESC view_emp_10;
--  VIEW는 테이블처럼 조회할 수 있다
--   실제 데이터는 기반 테이블에서 가지고 온다
SELECT * FROM view_emp_10;

-- SIMPLE VIEW는 제약 사항에 위배되지 않으면 내용 갱신 가능
--  view_emp_10의 급여를 두배로
UPDATE view_emp_10 SET salary = salary * 2;

-- 가급적이면 VIEW는 조회용으로만 활용하도록 하자
-- VIEW 생성시 변경 불가 객체로 만들 필요가 있다
-- READ ONLY 옵션을 부여
CREATE OR REPLACE VIEW view_emp_10
    AS SELECT * FROM emp_10 WITH READ ONLY; -- 읽기 전용 VIEW
    
UPDATE view_emp_10 SET salary = salary * 2;
--그래서 이건  읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.라고 뜬다. 

-- Complex View
-- 복수 개의 Table or View를 기반으로 한다
-- 함수, 표현식을 포함할 수 있다.
-- 기본적으로는 INSERT, UPDATE, DELETE 불가
-- book 테이블 JOIN author -> VIEW
SELECT * FROM author; 
SELECT * FROM book;

INSERT INTO book 
VALUES(1, '토지', sysdate, 1);


INSERT INTO book (book_id, title, author_id)
VALUES(2, '살인자의 기억법', 2);   -- pub_date는 DEFAULT 값이 입력된다

SELECT * FROM book;
commit;

CREATE OR REPLACE VIEW book_detail
    (book_id, title, author_name, pub_date)
    AS SELECT book_id, title, author_name, pub_date
        FROM book b, author a
        WHERE b.author_id = a.author_id;
        
DESC book_detail;

SELECT * FROM book_detail;

UPDATE book_detail SET author_name='미상';    -- 복합 VIEW는 수정이 불가(기본적으로)

----------
-- VIEW를 위한 딕셔너리
SELECT * FROM user_views;
-- 특정 View의 정보를 확인하려면 VIEW_NAME 조건으로 조회
SELECT * FROM user_views
WHERE view_name='BOOK_DETAIL';

SELECT * FROM user_objects
WHERE object_type='VIEW';

-- VIEW 삭제
--  실제 데이터는 VIEW가 아닌 기반테이블에 위치
DROP VIEW book_detail;
SELECT * FROM user_views;

--  VIEW 삭제해도 데이터는 유지
SELECT * FROM book;
SELECT * FROM author;
     
--        
--06ppt /7p/14

        
----------
-- INDEX
----------

-- 레코드 검색 속도 향상을 위한 색인 작업
--  WHERE 절의 조건에서 사용되는 필드
--  JOIN의 조건으로 사용되는 필드에 적용하면
--  검색 속도 향상 가능

CREATE TABLE s_emp
  AS SELECT * FROM hr.employees;
  --인덱스 확인
SELECT *FROM USER_INDEXES;

--s_emp테이블 employee_id칼럼에 UNIQUE 인덱스 생성
CREATE UNIQUE INDEX s_emp_id_pk   --인덱스 이름
 ON s_emp (employee_id);          --테이블 명(칼럼이름 )
  
SELECT *FROM user_indexes;
                                                                                    -----------------------???????????????다시보기 
--어떤 인덱스가 어느 칼럼에 걸려있는지 확인
SELECT *FROM user_ind_columns;

SELECT t.index_name , t.table_name, c.column_name, c.column_position
FROM user_indexes t, user_ind_columns c
WHERE t.index_name = c.index_name AND
  t.table_name = 'S_EMP';
  
--인덱스 삭제 
DROP INDEX  s_emp_id_pk;
SELECT *FROM user_indexes;

--SEQUENCE
---------

--만약 author테이블에 새 레코드 추가해야한다.
SELECT *FROM author;
  
--중복되지 않는 pk를 얻어와야한다.
INSERT INTO author(author_id, author_name)
    VALUES(
    (SELECT MAX (author_id)+1 FROM author), '스티븐 킹');
    
SELECT * FROM author;
-- but이 방식은 안전하지 않다. 
ROLLBACK;

--중복되지 않는 값을 추출하기 위해  -SEQUENCE필요
SELECT MAX(author_id)+1 FROM author;

CREATE SEQUENCE seq_author_id
START WITH 3  --3부터 추출
INCREMENT BY 1 --1씩 증가
MAXVALUE 1000000; -- 최댓값 1000000

--시퀀스를 이용한 INSERT(PK)
--중복되지 않는 pk를 얻어와야한다.
INSERT INTO author(author_id, author_name) 복되지 않는 정수를 생성
         '스티븐 킹');
   SELECT * FROM author;
   
--새 시퀀스를 생성해 봅니다. 
CREATE SEQUENCE my_seq
   START WITH 1
   INCREMENT BY 1 --1씩 증가
    MAXVALUE 10;
    
--NEXTVAL, CURRVAL가상 칼럼을 이용
SELECT my_seq.NEXTVAL FROM daul;   --새값의 추출  --1나옴
SELECT my_seq.CURRVAL FROM daul;   --현재 시퀀스의 값확인  (증가안함) -- 1나옴
 
 
 --시퀀스 수정
 ALTER SEQUENCE my_seq
  INCREMENT BY 2 
  MAXVALUE 1000000;
SELECT my_seq.NEXTVAL FROM daul;   --새값의 추출  --3나옴-5-7-9
SELECT my_seq.CURRVAL FROM daul;   --현재 시퀀스의 값확인  (증가안함) -- 3나옴
 
 
 --시퀀스를 위한 딕셔너리
 SELECT * FROM user_sequences;
 SELECT object_name FROM user_objects
 WHERE object_type='SEQUENCE';
 
 
 --시퀀스 삭제
 DROP  SEQUENCE my_seq;
 SELECT * FROM user_sequences;
