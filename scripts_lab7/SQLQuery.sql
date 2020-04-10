EXEC sp_droprolemember 'role1', 'serj';
EXEC sp_droprole 'role1';
DROP USER serj;
DROP LOGIN serj;
GO

CREATE LOGIN serj WITH PASSWORD = '1234';
CREATE USER serj FOR LOGIN serj with default_schema = dbo;

--по крайней мере дл€ одной таблицы новому пользователю присваиваютс€ права SELECT, INSERT, UPDATE в полном объеме
GRANT INSERT, SELECT, UPDATE ON CHESS_PLAYERS TO serj;
EXECUTE AS USER = 'serj';  --инструкци€, котора€ переключает контекст выполнени€ сеанса на заданное им€ входа или им€ пользовател€
SELECT * FROM CHESS_PLAYERS;
UPDATE CHESS_PLAYERS SET name = 'ћ.' WHERE name = 'ћихаил';
INSERT INTO CHESS_PLAYERS (surname,name,birth_date,country_id) VALUES('¬асилевска€', '¬арвара', '05/12/2000', 1);	
SELECT * FROM CHESS_PLAYERS;
REVERT;

--по крайней мере дл€ одной таблицы новому пользователю присваиваютс€ права SELECT и UPDATE только избранных столбцов
GRANT SELECT(beginning_date, ending_date, stage_number), UPDATE(stage_number) ON STAGES TO serj;
EXECUTE AS USER = 'serj';
SELECT beginning_date, ending_date FROM STAGES;
UPDATE STAGES SET stage_number = stage_number + 1 WHERE stage_number > 5;
SELECT beginning_date, ending_date FROM STAGES;
REVERT;

--по крайней мере дл€ одной таблицы новому пользователю присваиваетс€ только право SELECT
GRANT SELECT ON TOURNAMENTS TO serj;
EXECUTE AS USER = 'serj';
SELECT * FROM TOURNAMENTS;
REVERT;

--присвоить новому пользователю право доступа (SELECT) к представлению, созданному в лабораторной работе є5
BEGIN TRANSACTION
GRANT SELECT ON View1 TO test;
EXECUTE AS USER = 'test';
SELECT * FROM View1;
REVERT;
ROLLBACK;

--создать стандартную роль уровн€ базы данных, присвоить ей право доступа (UPDATE на некоторые столбцы) к представлению и назначить новому пользователю созданную роль.

CREATE ROLE role1;
GRANT SELECT ON view4 TO role1;
EXEC sp_addrolemember role1, 'serj';