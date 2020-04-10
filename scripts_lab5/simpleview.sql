--страна, количество шахматистов из этой страны, принимавших участие в турнирах, количество побед шахматистов из этой страны, количество побед на родине
create view view2 as
SELECT country, X1.players_from_country, X1.number_of_victories 
FROM COUNTRIES, CHESS_PLAYERS, STAGERESULTS;
