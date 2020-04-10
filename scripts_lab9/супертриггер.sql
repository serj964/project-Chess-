--создать специальную таблицу, в которой фиксируется кто когда логинился
IF OBJECT_ID (N'login_data', N'TABLE') IS NOT NULL 
DROP TABLE login_data;

CREATE TABLE login_data
(
user_login VARCHAR(50),
logon_date DATETIME
);


CREATE TRIGGER trigger3
ON ALL SERVER WITH EXECUTE AS 'sa'
AFTER LOGON
AS
INSERT INTO chess1.dbo.login_data VALUES(ORIGINAL_LOGIN(), GETDATE())

SELECT DISTINCT user_login, logon_date FROM login_data
order by logon_date