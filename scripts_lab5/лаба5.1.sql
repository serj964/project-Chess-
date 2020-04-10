--������, ���������� ����������� � ���� ������, ���������� ����� �� �������� � ������� ����, ������� ����� �� �������� � ������� ����
IF (object_id('view1', 'V') IS NOT NULL) DROP VIEW view1
GO

CREATE VIEW view1 AS
SELECT t2.������, ISNULL(t3.number_win,0) AS '���-�� ����� � ������ � 2015', COUNT(*) AS '���-�� ����������� � ������' 
FROM (SELECT CHESS_PLAYERS.player_id player_id, '������' =
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
	  LEFT JOIN (SELECT CHESS_PLAYERS.player_id player_id, ISNULL(rating,1100) rnow
	             FROM CHESS_PLAYERS
	 		     LEFT OUTER JOIN RATING
	 		     ON CHESS_PLAYERS.player_id = RATING.player_id
	             WHERE ISNULL(RATING.change_date, '01/01/2015') in (SELECT MAX(ISNULL(RATING.change_date, '01/01/2015')) FROM CHESS_PLAYERS
	 															    LEFT OUTER JOIN RATING
	 															    ON CHESS_PLAYERS.player_id = RATING.player_id
	 															    group by CHESS_PLAYERS.player_id)) t1
	  ON CHESS_PLAYERS.player_id = t1.player_id) t2
LEFT JOIN (SELECT ������, COUNT(*) as number_win FROM (SELECT CHESS_PLAYERS.player_id player_id, '������' =
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
		   LEFT OUTER JOIN CHESS_PLAYERS
		   ON t2.player_id = CHESS_PLAYERS.player_id
		   WHERE  CHESS_PLAYERS.player_id IN (SELECT player_id
		   								      FROM STAGERESULTS, STAGES
		   								      WHERE position IN ('1', '2', '3')
		   								      AND STAGES.stage_number in (select max(stage_number) from STAGES
		   									   						      group by tournament_id))
		   								      GROUP BY ������) t3
ON t2.������ = t3.������
GROUP BY t2.������, t3.number_win
GO

SELECT * FROM view1