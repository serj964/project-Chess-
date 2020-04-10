--вывести названия турниров в которых участвовал самый молодой шахматист
SELECT distinct TOURNAMENT
FROM TOURNAMENTS, CHESS_PLAYERS, STAGES, STAGERESULTS
WHERE TOURNAMENTS.tournament_id = STAGES.tournament_id
and STAGES.stage_id=STAGERESULTS.stage_id
and STAGERESULTS.player_id = CHESS_PLAYERS.player_id
and birth_date IN (SELECT TOP(1) birth_date from CHESS_PLAYERS
                     order by birth_date desc)
