--Повысить рейтинг всех Российских шахматистов на 50, если они хоть где-то заняли первое место
UPDATE RATING
	SET rating = rating + 50
    WHERE player_id in (SELECT DISTINCT CHESS_PLAYERS.player_id
	                    FROM CHESS_PLAYERS, COUNTRIES, STAGERESULTS
                        WHERE CHESS_PLAYERS.player_id = STAGERESULTS.player_id
                        and position = '1'
                        and CHESS_PLAYERS.country_id = COUNTRIES.country_id
                        and country = 'Россия')
