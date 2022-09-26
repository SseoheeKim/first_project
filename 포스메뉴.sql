-- SYS 관리자 계정 이용
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- 사용자 계정 생성
CREATE USER sh IDENTIFIED BY sh1234;

-- 생성한 사용자 계정에 권한을 부여
GRANT CONNECT, RESOURCE, CREATE VIEW TO sh;


-- 테이블 스페이스 할당
ALTER USER sh DEFAULT 
TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM;


---------------------------------------------------------------------------
-- sh계정

-- menu 테이블
CREATE TABLE MENU(
	MENU_NO NUMBER PRIMARY KEY,
	MENU_NM VARCHAR2(30) UNIQUE NOT NULL,
	MENU_PRICE NUMBER NOT NULL,
	SALE_FL CHAR(1) DEFAULT 'Y' CHECK( SALE_FL IN ('Y', 'N') )
);


COMMENT ON COLUMN MENU.MENU_NO IS '메뉴 번호';
COMMENT ON COLUMN MENU.MENU_NM IS '메뉴명';
COMMENT ON COLUMN MENU.MENU_PRICE IS '메뉴 가격';
COMMENT ON COLUMN MENU.SALE_FL IS '판매 여부';


CREATE SEQUENCE SEQ_MENU_NO NOCACHE;

DROP SEQUENCE SEQ_MENU_NO;

INSERT INTO MENU VALUES(SEQ_MENU_NO.NEXTVAL, '아메리카노', 4500, DEFAULT);
INSERT INTO MENU VALUES(SEQ_MENU_NO.NEXTVAL, '카페라떼', 5000, DEFAULT);
INSERT INTO MENU VALUES(SEQ_MENU_NO.NEXTVAL, '카페모카', 5500, DEFAULT);
INSERT INTO MENU VALUES(SEQ_MENU_NO.NEXTVAL, '카라멜마끼아또', 5500, DEFAULT);

COMMIT;
SELECT * FROM MENU;
DROP TABLE MENU;

-- 메뉴 가격 변동
UPDATE MENU SET MENU_PRICE = 5500
WHERE SALE_FL = 'Y'
AND MENU_NO = 5;

commit
---------------------------------------------------------------------
-- 주문내역

CREATE TABLE ORDER_TB(
	ORDER_NO NUMBER PRIMARY KEY,
	MENU_NO NUMBER CONSTRAINT FK_MENU_NO REFERENCES MENU,
	ORDER_QUANTITY NUMBER DEFAULT 0 NOT NULL,
	ORDER_DATE DATE DEFAULT SYSDATE
);

COMMENT ON COLUMN ORDER_TB.ORDER_NO IS '주문 번호';
COMMENT ON COLUMN ORDER_TB.ORDER_QUANTITY IS '판매 수량';
COMMENT ON COLUMN ORDER_TB.ORDER_DATE IS '판매 날짜';

CREATE SEQUENCE SEQ_ORDER_NO NOCACHE;
DROP SEQUENCE SEQ_ORDER_NO;

INSERT INTO ORDER_TB VALUES
(SEQ_ORDER_NO.NEXTVAL, 2, 2, DEFAULT);

COMMIT;
SELECT * FROM ORDER_TB;
DROP TABLE ORDER_TB;
SELECT SEQ_ORDER_NO.NEXTVAL FROM DUAL;


-- 메뉴별 판매수량과 금액 조회
SELECT MENU_NM, SUM(ORDER_QUANTITY) "총 판매수량", (MENU_PRICE * SUM(ORDER_QUANTITY)) ||'원' AS "총 판매금액" 
FROM MENU
JOIN ORDER_TB USING(MENU_NO)
GROUP BY MENU_NM, MENU_PRICE;
