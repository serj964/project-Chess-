--������, ���������� ����������� �� ���� ������, ����������� ������� � ��������, ���������� ����� ����������� �� ���� ������, ���������� ����� �� ������
create view view2 as
SELECT country, X1.players_from_country, X1.number_of_victories 
FROM COUNTRIES, CHESS_PLAYERS, STAGERESULTS;