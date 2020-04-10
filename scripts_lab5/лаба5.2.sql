--cтрана, количество шахматистов из этой страны, принимавших участие в турнирах, количество побед шахматистов из этой страны, количество побед на родине.
IF (object_id('view2', 'V') IS NOT NULL) DROP VIEW view2
GO

CREATE VIEW view2 AS
SELECT t3.country AS 'страна', t3.number_player AS 'кол-во шахматистов из страны', t3.number_win AS 'кол-во побед шахматистов', ISNULL(t4.number_win_country,0) AS 'кол-во побед на Родине'
FROM
(SELECT t1.country, t1.number_player, ISNULL(t2.number_win,0) number_win
FROM  (SELECT country, COUNT(*) number_player
	   FROM COUNTRIES, CHESS_PLAYERS
	   WHERE COUNTRIES.country_id = CHESS_PLAYERS.country_id
	   GROUP BY country) t1 
	   LEFT OUTER JOIN (SELECT country, COUNT(*) as number_win
						FROM COUNTRIES, CHESS_PLAYERS
						WHERE COUNTRIES.country_id = CHESS_PLAYERS.country_id
						AND CHESS_PLAYERS.player_id IN (SELECT DISTINCT player_id
													    FROM STAGERESULTS, STAGES
													    WHERE position IN ('1', '2', '3')
													    AND STAGES.stage_number in (select max(stage_number) from STAGES
													    group by tournament_id))
					    GROUP BY country) t2 
	   ON t1.country = t2.country) t3
LEFT OUTER JOIN (SELECT country, COUNT(*) number_win_country
                 FROM COUNTRIES, (SELECT DISTINCT CHESS_PLAYERS.player_id, CHESS_PLAYERS.country_id, COUNTRIES.country_id country_id1
                 				  FROM CHESS_PLAYERS, TOURNAMENTS, COUNTRIES, STAGES, STAGERESULTS
                 				  WHERE TOURNAMENTS.country_id = COUNTRIES.country_id
                 				  AND TOURNAMENTS.tournament_id = STAGES.tournament_id
                 				  AND STAGES.stage_id = STAGERESULTS.stage_id
                 				  AND STAGERESULTS.player_id = CHESS_PLAYERS.player_id
                 				  AND CHESS_PLAYERS.player_id IN (SELECT DISTINCT player_id
                 				 					              FROM STAGERESULTS, STAGES
                 				 					              WHERE position IN ('1', '2', '3')
                 				 					              AND STAGES.stage_number in (select max(stage_number) from STAGES
                 				 					              group by tournament_id))) t5
                 WHERE t5.country_id = COUNTRIES.country_id
                 AND t5.country_id = t5.country_id1
                 GROUP BY country) t4
ON t3.country = t4.country
GO

SELECT * FROM view2