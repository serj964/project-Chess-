--удалить все дебюты, которые когда-либо привели к поражению белых
DELETE FROM DEBUTS
WHERE DEBUTS.debut_id in (SELECT distinct DEBUTS.debut_id 
                          FROM DEBUTS, PLAYER_GAME, GAMES
                          WHERE GAMES.game_id=PLAYER_GAME.game_id
                          and DEBUTS.debut_id=GAMES.debut_id
                          and PLAYER_GAME.colour_id = 102
                          and PLAYER_GAME.points = 0)
