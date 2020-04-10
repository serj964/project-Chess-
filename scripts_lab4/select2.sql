--вывести сколько игр шахматист сыграл за белых, и сколько из них выиграл
select surname as 'фамилия', name as 'имя', count(chess_players.player_id) as 'сумма игр, сыгранных белыми', RATING as 'рейтинг', count(PLAYER_GAME.points) as 'число выигранных игр'
from PLAYER_GAME, CHESS_PLAYERS INNER JOIN RATING ON CHESS_PLAYERS.player_id=RATING.player_id
where CHESS_PLAYERS.player_id=PLAYER_GAME.player_id
and CHESS_PLAYERS.player_id=RATING.player_id
and colour_id=102
and points=1
group by surname , name, RATING 