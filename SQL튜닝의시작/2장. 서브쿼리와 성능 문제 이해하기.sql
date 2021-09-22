DROP TABLE SUBQUERY_T1 PURGE;
DROP TABLE SUBQUERY_T2 PURGE;
DROP TABLE SUBQUERY_T3 PURGE;

CREATE TABLE SUBQUERY_T1 AS
SELECT LEVEL AS C4, CHR(65+MOD(LEVEL,26)) AS C5, LEVEL+99999 AS C6
   FROM DUAL
 CONNECT BY LEVEL <= 250000
 ;
 
 -- 250000 ���� �����͸� ���� �� �� ������ ���̺� ���� 6�� �ݺ��Ͽ� ������
 BEGIN
    FOR I IN 1..6 LOOP
        INSERT INTO SUBQUERY_T1 SELECT * FROM SUBQUERY_T1;
        COMMIT;
    END LOOP;
END;
/

-- �� �÷��� �ε��� ���� �� ��������� ����
EXEC dbms_stats.gather_table_stats(OWNNAME=>'SCOTT',TABNAME=>'SUBQUERY_T1',CASCADE=>TRUE,ESTIMATE_PERCENT=>100);

CREATE INDEX SUBQUERY_T1_IDX_01 ON SUBQUERY_T1 (C4, C5);
CREATE INDEX SUBQUERY_T1_IDX_02 ON SUBQUERY_T1 (C5);

< SUBQUERY_T2>

-- �������
- ���̺� ������ �Ǽ��� 500000 �ο�
- �÷� C1�� ���� ������ 500000 ���� ��, Unique�� ����
- �÷� C2�� ���� ������ 26����
- �÷� C3�� ���� ������ 50000 �����̸�, 100000 ���� ���������� ����
- �÷� C4�� ���� ������ 26����

-- ���̺� ����
CREATE TABLE SUBQUERY_T2 AS
SELECT LEVEL AS C1, CHR(65+MOD(LEVEL,26)) AS C2, LEVEL+99999 AS C3, CHR(65+MOD(LEVEL,26)) AS C4 
   FROM DUAL
 CONNECT BY LEVEL <= 500000;
 
 -- �� �÷��� �ε��� ���� �� ������� ����
 EXEC dbms_stats.gather_table_stats(OWNNAME=>'SCOTT',TABNAME=>'SUBQUERY_T2',CASCADE=>TRUE,ESTIMATE_PERCENT=>100);
 
 CREATE INDEX SUBQUERY_T2_IDX_01 ON SUBQUERY_T2 ( C2, C1);
 ALTER TABLE SUBQUERY_T2 ADD CONSTRAINTS PK_SUBQUERY_2 PRIMARY KEY (C1);
 
 < SUBQUERY_T3 >
 
 -- ��������
 - ���̺� ������ �Ǽ� 500000 �ο�
 - �÷� C1�� ���� ������ 500000�����̸�, Unique�� ���� �������� ����
 - �÷� C2�� ���� ������ 26������ �ǵ��� ����
 - �÷� C3�� ���� ������ 500000�����̸�, 100000 ���� ���������� �����ϵ��� ����
 
 CREATE TABLE SUBQUERY_T3 AS
 SELECT LEVEL AS C1, CHR(65+MOD(LEVEL,26)) AS C2, LEVEL+99999 AS C3
    FROM DUAL
 CONNECT BY LEVEL <= 500000;
 
 -- �� �÷��� �ε��� ���� �� ������� ����
 EXEC dbms_stats.gather_table_stats(OWNNAME=>'SCOTT',TABNAME=>'SUBQUERY_T3',CASCADE=>TRUE,ESTIMATE_PERCENT=>100);
 
 CREATE INDEX SUBQUERY_T3_IDX_01 ON SUBQUERY_T2 ( C1, C2);
 ALTER TABLE SUBQUERY_T3 ADD CONSTRAINTS PK_SUBQUERY_3 PRIMARY KEY (C1);