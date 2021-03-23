--07ppt/23p/33

-- DAO 객체 생성 연습
-- 사용자 계정으로 접속
DROP TABLE author CASCADE CONSTRAINTS;
DROP TABLE book;
SELECT * FROM user_objects;
DROP SEQUENCE seq_author_id;

CREATE TABLE author (
    id NUMBER(10),
    name VARCHAR2(50) NOT NULL,
    bio VARCHAR2(100),
    PRIMARY KEY (id)
    );
CREATE SEQUENCE seq_author 
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 1000000;
    
SELECT * FROM user_objects;

INSERT INTO author 
VALUES(seq_author.NEXTVAL,
    '박경리', '토지작가');
SELECT * FROM author;

COMMIT; -- 데이터베이스 반영

SELECT seq_author.NEXTVAL FROM dual;
SELECT * FROM author;

DELETE FROM author WHERE id=21;
ROLLBACK;

-- 미니프로젝트 SQL
CREATE TABLE PHONE_BOOK (
    id NUMBER(10) PRIMARY KEY,
    name VARCHAR2(10),
    hp VARCHAR2(20),
    tel VARCHAR2(20)
    );
    
CREATE SEQUENCE seq_phone_book;
INSERT INTO phone_book 
VALUES(seq_phone_book.NEXTVAL, '고길동', '010-1234-5678', '02-9876-5432');

SELECT * FROM phone_book;
COMMIT;

 