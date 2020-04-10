EXEC sp_droprolemember 'role1', 'serj';
EXEC sp_droprole 'role1';
DROP USER serj;
DROP LOGIN serj;
GO

CREATE LOGIN serj WITH PASSWORD = '1234';
CREATE USER serj FOR LOGIN serj with default_schema = dbo;  /*���� ������������ ����������� ������ ����������� ��� ������������, ������������� ������� 
� ���������������� ���� ���� ������ (�������� �� ������ ���� ������ � ������������� � ������ ��)*/

--�� ������� ���� ��� ����� ������� ������ ������������ ������������� ����� SELECT, INSERT, UPDATE � ������ ������
GRANT INSERT, SELECT, UPDATE ON CHESS_PLAYERS TO serj;
EXECUTE AS USER = 'serj';  --����������, ������� ����������� �������� ���������� ������ �� �������� ��� ����� ��� ��� ������������
SELECT * FROM CHESS_PLAYERS;
UPDATE CHESS_PLAYERS SET name = '�.' WHERE name = '������';
INSERT INTO CHESS_PLAYERS (surname,name,birth_date,country_id) VALUES('�����������', '�������', '05/12/2000', 1);	
SELECT * FROM CHESS_PLAYERS;
REVERT;

--�� ������� ���� ��� ����� ������� ������ ������������ ������������� ����� SELECT � UPDATE ������ ��������� ��������
GRANT SELECT(beginning_date, ending_date, stage_number), UPDATE(stage_number) ON STAGES TO serj;
EXECUTE AS USER = 'serj';
SELECT beginning_date, ending_date FROM STAGES;
UPDATE STAGES SET stage_number = stage_number + 1 WHERE stage_number > 5;
SELECT beginning_date, ending_date FROM STAGES;
REVERT;

--�� ������� ���� ��� ����� ������� ������ ������������ ������������� ������ ����� SELECT
GRANT SELECT ON TOURNAMENTS TO serj;
EXECUTE AS USER = 'serj';
SELECT * FROM TOURNAMENTS;
REVERT;

--��������� ������ ������������ ����� ������� (SELECT) � �������������, ���������� � ������������ ������ �5
GRANT SELECT ON View1 TO test;
EXECUTE AS USER = 'test';
SELECT * FROM View1;
REVERT;

--������� ����������� ���� ������ ���� ������, ��������� �� ����� ������� (UPDATE �� ��������� �������) � ������������� � ��������� ������ ������������ ��������� ����.

CREATE ROLE role1;
GRANT SELECT ON view4 TO role1;
EXEC sp_addrolemember role1, 'serj';