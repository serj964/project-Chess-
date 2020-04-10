set DATEFORMAT dmy

IF OBJECT_ID (N'RATING', N'TABLE') IS NOT NULL 
DROP TABLE RATING;
IF OBJECT_ID (N'GAMES_MISTAKES', N'TABLE') IS NOT NULL 
DROP TABLE GAMES_MISTAKES;
IF OBJECT_ID (N'MISTAKES', N'TABLE') IS NOT NULL 
DROP TABLE MISTAKES;
IF OBJECT_ID (N'PLAYER_GAME', N'TABLE') IS NOT NULL 
DROP TABLE PLAYER_GAME;
IF OBJECT_ID (N'GAMES', N'TABLE') IS NOT NULL 
DROP TABLE GAMES;
IF OBJECT_ID (N'DEBUTS', N'TABLE') IS NOT NULL 
DROP TABLE DEBUTS;
IF OBJECT_ID (N'DEBUTCLASSIFICATION', N'TABLE') IS NOT NULL 
DROP TABLE DEBUTCLASSIFICATION;
IF OBJECT_ID (N'COLOUR', N'TABLE') IS NOT NULL 
DROP TABLE COLOUR;
IF OBJECT_ID (N'STAGERESULTS', N'TABLE') IS NOT NULL 
DROP TABLE STAGERESULTS;
IF OBJECT_ID (N'TIMECONTROL', N'TABLE') IS NOT NULL 
DROP TABLE TIMECONTROL;
IF OBJECT_ID (N'CHESS_PLAYERS', N'TABLE') IS NOT NULL 
DROP TABLE CHESS_PLAYERS;
IF OBJECT_ID (N'STAGES', N'TABLE') IS NOT NULL 
DROP TABLE STAGES;
IF OBJECT_ID (N'SYSTEMNAME', N'TABLE') IS NOT NULL 
DROP TABLE SYSTEMNAME;
IF OBJECT_ID (N'TOURNAMENTS', N'TABLE') IS NOT NULL 
DROP TABLE TOURNAMENTS;
IF OBJECT_ID (N'COUNTRIES', N'TABLE') IS NOT NULL 
DROP TABLE COUNTRIES;

create table DEBUTCLASSIFICATION (
  classification varchar(25),
  classification_id tinyint NOT NULL PRIMARY KEY,
  comment varchar(400)
);

create table DEBUTS (
  debut varchar(100),
  debut_id smallint IDENTITY(201,1) NOT NULL PRIMARY KEY,
  classification_id tinyint,
  debut_notation varchar(70)
);

create table COUNTRIES (
  country_id smallint NOT NULL PRIMARY KEY,
  country varchar(70)
);

create table COLOUR (
  colour varchar(6),
  colour_id smallint NOT NULL PRIMARY KEY
);

create table PLAYER_GAME (
  player_id smallint NOT NULL,
  game_id int NOT NULL,
  colour_id smallint,
  points numeric(2,1),
  PRIMARY KEY (player_id,game_id)
);

create table CHESS_PLAYERS (
  name varchar(40),
  surname varchar(50),
  player_id smallint IDENTITY(401,1) NOT NULL PRIMARY KEY,
  birth_date date,
  country_id smallint
);

create table STAGERESULTS (
  position varchar(30) DEFAULT 'игрок перешёл в следующий тур',
  player_id smallint NOT NULL,
  stage_id smallint NOT NULL,
  PRIMARY KEY (player_id, stage_id)
);

create table GAMES (
  game_id int IDENTITY(1001,1) NOT NULL PRIMARY KEY,
  stage_id smallint,
  debut_id smallint,
  gamedate date,
  number_of_moves smallint,
  --round_number tinyint,
  timecontrol_id tinyint
);

create table RATING (
  player_id smallint NOT NULL,
  rating smallint,
  change_date datetime NOT NULL,
  PRIMARY KEY (player_id, change_date)
);

create table TIMECONTROL (
  timecontrol varchar(40),
  timecontrol_id tinyint NOT NULL PRIMARY KEY,
  lower_timelimit time(0),
  upper_timelimit time(0)
);

create table TOURNAMENTS (
  tournament varchar(150),
  tournament_id smallint IDENTITY(301,1) NOT NULL PRIMARY KEY,
  beginning_date date,
  ending_date date,
  country_id smallint,
  comment varchar(400)
);

create table GAMES_MISTAKES (
  mistake_id smallint NOT NULL,
  game_id int NOT NULL,
  PRIMARY KEY (mistake_id, game_id)
);

create table MISTAKES (
  mistake varchar(200),
  mistake_id smallint IDENTITY(275,1) NOT NULL PRIMARY KEY,
  comment varchar(400)
);

create table STAGES (
  tournament_id smallint,
  stage_id smallint IDENTITY(3001,1) NOT NULL PRIMARY KEY,
  beginning_date date,
  ending_date date,
  stage_number tinyint,
  system_id tinyint
);

create table SYSTEMNAME (
  systemname varchar(20),
  system_id tinyint NOT NULL PRIMARY KEY,
  comment varchar(400)
);

ALTER TABLE DEBUTS ADD
	FOREIGN KEY (classification_id)
		REFERENCES DEBUTCLASSIFICATION (classification_id)

ALTER TABLE RATING ADD
	FOREIGN KEY (player_id)
		REFERENCES CHESS_PLAYERS (player_id)

ALTER TABLE CHESS_PLAYERS ADD
	FOREIGN KEY (country_id)
		REFERENCES COUNTRIES (country_id)

ALTER TABLE PLAYER_GAME ADD
	FOREIGN KEY (player_id)
		REFERENCES CHESS_PLAYERS (player_id),
	FOREIGN KEY (game_id)
		REFERENCES GAMES (game_id),
	FOREIGN KEY (colour_id)
		REFERENCES COLOUR (colour_id)

ALTER TABLE STAGERESULTS ADD
	FOREIGN KEY (player_id)
		REFERENCES CHESS_PLAYERS (player_id),
	FOREIGN KEY (stage_id)
		REFERENCES STAGES (stage_id)

ALTER TABLE TOURNAMENTS ADD
	FOREIGN KEY (country_id)
		REFERENCES COUNTRIES (country_id)

ALTER TABLE GAMES_MISTAKES ADD
	FOREIGN KEY (mistake_id)
		REFERENCES MISTAKES (mistake_id),
	FOREIGN KEY (game_id)
		REFERENCES GAMES (game_id)

ALTER TABLE GAMES ADD
	FOREIGN KEY (stage_id)
		REFERENCES STAGES (stage_id),
	FOREIGN KEY (debut_id)
		REFERENCES DEBUTS (debut_id)

ALTER TABLE STAGES ADD
	FOREIGN KEY (tournament_id)
		REFERENCES TOURNAMENTS (tournament_id),
	FOREIGN KEY (system_id)
		REFERENCES SYSTEMNAME (system_id)
