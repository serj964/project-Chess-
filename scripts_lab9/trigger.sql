IF OBJECT_ID ('trigger1', 'TR') IS NOT NULL
   DROP TRIGGER trigger1;
GO
--при занесении занятого шахматистом места рейтинг шахматиста, занявшего место не ниже 3-го увеличивается на величину: ( 4 - место ) * квалификационный уровень турнира
CREATE TRIGGER trigger1 ON dbo.STAGERESULTS AFTER INSERT
AS
BEGIN
INSERT INTO dbo.RATING
SELECT DISTINCT CP.player_id, rlast + (4 - INS.position) * t1.[кв. уровень], GETDATE()
FROM CHESS_PLAYERS AS CP
LEFT OUTER JOIN RATING AS RT
ON CP.player_id = RT.player_id
LEFT OUTER JOIN STAGERESULTS AS ST
ON CP.player_id = ST.player_id
JOIN inserted AS INS
ON RT.player_id = INS.player_id
LEFT OUTER JOIN STAGES AS S
ON ST.stage_id = S.stage_id
LEFT OUTER JOIN TOURNAMENTS AS TT
ON S.tournament_id = TT.tournament_id
LEFT OUTER JOIN (SELECT T.tournament_id, 'кв. уровень' =
	    CASE
	       WHEN  T.tournament = 'Кубок планеты 1975' THEN 4
	       WHEN  T.tournament IN ('Турнир чемпионов 2018', 'Турнир чемпионов 2016', 'Турнир чемпионов 2014') THEN 3
	       WHEN  T.tournament IN ('Гран-при Москва', 'Гран-при Торонто', 'Гран-при Манчестер') THEN 2
	       WHEN  T.tournament = 'Самый крутой турнир на диком западе' THEN 5
	       ELSE 1  
	    END  
	FROM TOURNAMENTS AS T) t1
ON TT.tournament_id = t1.tournament_id
INNER JOIN (SELECT CHESS_PLAYERS.player_id, RATING.rating AS 'rlast', tt.lastest_date FROM CHESS_PLAYERS
	              LEFT OUTER JOIN RATING
	              ON CHESS_PLAYERS.player_id = RATING.player_id
	              LEFT OUTER JOIN (SELECT CHESS_PLAYERS.player_id, MAX(RATING.change_date) as 'lastest_date' FROM CHESS_PLAYERS
	 													             LEFT OUTER JOIN RATING
	 													             ON CHESS_PLAYERS.player_id = RATING.player_id
	 													             group by CHESS_PLAYERS.player_id) tt
				  ON CHESS_PLAYERS.player_id = tt.player_id
				  where RATING.change_date = tt.lastest_date) t2
ON CP.player_id = t2.player_id
WHERE rating in (SELECT RATING.rating AS 'rlast' FROM CHESS_PLAYERS
	              LEFT OUTER JOIN RATING
	              ON CHESS_PLAYERS.player_id = RATING.player_id
	              WHERE ISNULL(RATING.change_date, '01/01/2015') in (SELECT MAX(ISNULL(RATING.change_date, '01/01/2015')) FROM CHESS_PLAYERS
	 													             LEFT OUTER JOIN RATING
	 													             ON CHESS_PLAYERS.player_id = RATING.player_id
	 													             group by CHESS_PLAYERS.player_id))
AND ST.stage_id = INS.stage_id
AND RT.change_date = t2.lastest_date
AND INS.position in ('1', '2', '3')
END


IF OBJECT_ID ('trigger2', 'TR') IS NOT NULL
   DROP TRIGGER trigger2;
GO
--при занесении занятого шахматистом места рейтинг шахматиста рейтинг шахматиста из первой десятки и занявшего место ниже двадцатого понижается на величину: 0,1 * занятое место.
CREATE TRIGGER trigger2 ON dbo.STAGERESULTS AFTER INSERT
AS	
BEGIN 
INSERT INTO dbo.RATING
SELECT DISTINCT CP.player_id, rlastmax - FLOOR(0.1 * CAST(INS.position AS int)), GETDATE()
FROM CHESS_PLAYERS AS CP
LEFT OUTER JOIN RATING AS RT
ON CP.player_id = RT.player_id
LEFT OUTER JOIN STAGERESULTS AS ST
ON CP.player_id = ST.player_id
JOIN inserted AS INS
ON RT.player_id = INS.player_id
INNER JOIN (SELECT TOP(10) CHESS_PLAYERS.player_id, RATING.rating AS 'rlastmax', tt.lastest_date FROM CHESS_PLAYERS
	              LEFT OUTER JOIN RATING
	              ON CHESS_PLAYERS.player_id = RATING.player_id
	              LEFT OUTER JOIN (SELECT CHESS_PLAYERS.player_id, MAX(RATING.change_date) as 'lastest_date' FROM CHESS_PLAYERS
	 													             LEFT OUTER JOIN RATING
	 													             ON CHESS_PLAYERS.player_id = RATING.player_id
	 													             group by CHESS_PLAYERS.player_id) tt
				  ON CHESS_PLAYERS.player_id = tt.player_id
				  where RATING.change_date = tt.lastest_date
ORDER BY RATING.rating DESC) t4
ON CP.player_id = t4.player_id
WHERE INS.position NOT IN (SELECT inserted.position from inserted
					        WHERE inserted.position = 'игрок перешёл в следующий тур')
AND INS.position > 20
AND RT.change_date = t4.lastest_date
AND ST.stage_id = INS.stage_id
END
