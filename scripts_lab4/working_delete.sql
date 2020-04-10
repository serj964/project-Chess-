--удалить рейтинг шахматистов с топ 3 рейтингом, которые проиграли
DELETE FROM rating
WHERE rating.rating in (select top(3) rating
                        from rating, STAGERESULTS, PLAYER_GAME
                        where rating.player_id = STAGERESULTS.player_id
                        and STAGERESULTS.position != '1'
                        and PLAYER_GAME.player_id = STAGERESULTS.player_id
                        and PLAYER_GAME.points = 0
                        order by rating desc)
