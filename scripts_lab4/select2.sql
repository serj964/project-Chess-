--������� ������� ��� ��������� ������ �� �����, � ������� �� ��� �������
select surname as '�������', name as '���', count(chess_players.player_id) as '����� ���, ��������� ������', RATING as '�������', count(PLAYER_GAME.points) as '����� ���������� ���'
from PLAYER_GAME, CHESS_PLAYERS INNER JOIN RATING ON CHESS_PLAYERS.player_id=RATING.player_id
where CHESS_PLAYERS.player_id=PLAYER_GAME.player_id
and CHESS_PLAYERS.player_id=RATING.player_id
and colour_id=102
and points=1
group by surname , name, RATING 