--шахматист, рейтинг, статистика по всем проводившимся турнирам с 2015, изменение рейтинга за год
IF (object_id('view3', 'V') IS NOT NULL) DROP VIEW view3
GO

CREATE VIEW view3 AS
SELECT CHESS_PLAYERS.surname AS 'фамилия', t2.rnow AS 'рейтинг', COUNT(position) AS 'кол-во побед в турнирах с 2015', t2.rnow-t6.r2015 AS 'изменение рейтинга с 2015' FROM CHESS_PLAYERS
LEFT OUTER JOIN (SELECT CHESS_PLAYERS.player_id player_id, position
                 FROM STAGERESULTS, STAGES, CHESS_PLAYERS, TOURNAMENTS
                 WHERE CHESS_PLAYERS.player_id = STAGERESULTS.player_id
               	 AND STAGERESULTS.stage_id = STAGES.stage_id
               	 AND STAGES.tournament_id = TOURNAMENTS.tournament_id
                 AND position IN ('1', '2', '3')
                 AND YEAR(TOURNAMENTS.beginning_date) >= 2015
              	 AND STAGES.stage_number in (select max(stage_number) from STAGES
                 group by tournament_id)) t1
ON CHESS_PLAYERS.player_id = t1.player_id
LEFT OUTER JOIN (SELECT CHESS_PLAYERS.player_id player_id, ISNULL(rating,1100) rnow
                 FROM CHESS_PLAYERS
				 LEFT OUTER JOIN RATING
				 ON CHESS_PLAYERS.player_id = RATING.player_id
              	 WHERE ISNULL(RATING.change_date, '01/01/2015') in (SELECT MAX(ISNULL(RATING.change_date, '01/01/2015')) FROM CHESS_PLAYERS
																	LEFT OUTER JOIN RATING
																	ON CHESS_PLAYERS.player_id = RATING.player_id
																	group by CHESS_PLAYERS.player_id)) t2
ON CHESS_PLAYERS.player_id = t2.player_id
LEFT JOIN (SELECT CHESS_PLAYERS.player_id, ISNULL(RATING, 1100) AS 'r2015' FROM CHESS_PLAYERS
		   LEFT OUTER JOIN (SELECT CHESS_PLAYERS.player_id, ISNULL(MIN(t4.change_date), '01/01/2015') change_date, t4.rating FROM CHESS_PLAYERS
		   				    LEFT JOIN (SELECT MIN(RATING.change_date) change_date, player_id, rating FROM RATING
		   				    		   GROUP BY RATING.rating, RATING.player_id, RATING.change_date
									   HAVING MAX(YEAR(RATING.change_date)) <= 2015) t4
		   				    ON CHESS_PLAYERS.player_id = t4.player_id
		   				    GROUP BY t4.rating, CHESS_PLAYERS.player_id) t5
		   ON CHESS_PLAYERS.player_id = t5.player_id) t6
ON CHESS_PLAYERS.player_id = t6.player_id
GROUP BY CHESS_PLAYERS.surname, t6.r2015, t2.rnow  
GO

SELECT * FROM view3