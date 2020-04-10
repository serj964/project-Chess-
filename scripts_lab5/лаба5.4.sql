--������, ���, ���������, ������, ����� (��� ��������)
IF (object_id('view4', 'V') IS NOT NULL) DROP VIEW view4
GO

CREATE VIEW view4(������,���,�������,���,������,�������) AS
SELECT  COUNTRIES.country, YEAR(TOURNAMENTS.ending_date), CHESS_PLAYERS.surname, CHESS_PLAYERS.name, t2.������, position
FROM CHESS_PLAYERS
INNER JOIN STAGERESULTS
ON CHESS_PLAYERS.player_id = STAGERESULTS.player_id 
INNER JOIN STAGES
ON STAGERESULTS.stage_id = STAGES.stage_id
INNER join TOURNAMENTS
ON STAGES.tournament_id = TOURNAMENTS.tournament_id
INNER JOIN COUNTRIES
ON TOURNAMENTS.country_id = COUNTRIES.country_id
INNER JOIN (SELECT CHESS_PLAYERS.player_id player_id, '������' =
		        CASE
		           WHEN t1.rnow >= 2500 THEN '������������� ������������'
		           WHEN t1.rnow >= 2400 AND t1.rnow < 2500 THEN '������������� ������'
		           WHEN t1.rnow >= 2200 AND t1.rnow < 2400 THEN '������������ ������'
		           WHEN t1.rnow >= 2000 AND t1.rnow < 2200 THEN '�������� � �������'
		           WHEN t1.rnow >= 1800 AND t1.rnow < 2000 THEN '������ ������'
		           WHEN t1.rnow >= 1600 AND t1.rnow < 1800 THEN '������ ������'
		   		   WHEN t1.rnow >= 1400 AND t1.rnow < 1600 THEN '������ ������'
		           WHEN t1.rnow >= 1000 AND t1.rnow < 1400 THEN '��������� ������'
		           ELSE '�������'  
		        END  
		   FROM CHESS_PLAYERS
		   LEFT OUTER JOIN (SELECT CHESS_PLAYERS.player_id player_id, ISNULL(rating,1100) rnow
		              FROM CHESS_PLAYERS
		   		      LEFT OUTER JOIN RATING
		   		      ON CHESS_PLAYERS.player_id = RATING.player_id
		              WHERE ISNULL(RATING.change_date, '01/01/2015') in (SELECT MAX(ISNULL(RATING.change_date, '01/01/2015')) FROM CHESS_PLAYERS
		   															     LEFT OUTER JOIN RATING
		   															     ON CHESS_PLAYERS.player_id = RATING.player_id
		   															     group by CHESS_PLAYERS.player_id)) t1
		   ON CHESS_PLAYERS.player_id = t1.player_id) t2
ON t2.player_id = CHESS_PLAYERS.player_id
WHERE STAGERESULTS.position in ('1', '2', '3')
AND stage_number in (select max(stage_number) from STAGES
                     group by tournament_id)
GO

SELECT * FROM view4
ORDER BY view4.�������