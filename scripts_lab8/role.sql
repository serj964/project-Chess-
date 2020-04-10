--роли
SELECT name
FROM sys.database_principals
WHERE type = 'R';

SELECT name
FROM sys.server_principals
WHERE type = 'R'