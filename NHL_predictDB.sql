CREATE DATABASE NHL_PredictDB;

USE NHL_PredictDB;

CREATE TABLE Conferencias (
    ConferenciaID INT AUTO_INCREMENT,
    Nombre_Conferencia VARCHAR(30) NOT NULL,
    PRIMARY KEY (ConferenciaID)
);

CREATE TABLE Divisiones (
    DivisionID INT AUTO_INCREMENT,
    Nombre_Division VARCHAR(30) NOT NULL,
    ConferenciaID INT NOT NULL,
    PRIMARY KEY (DivisionID),
    CONSTRAINT fk_conferencia
        FOREIGN KEY (ConferenciaID)
        REFERENCES Conferencias(ConferenciaID)
);

CREATE TABLE Arenas (
    ArenaID INT AUTO_INCREMENT,
    Nombre_Arena VARCHAR(60) NOT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Estado VARCHAR(50),
    Pais VARCHAR(50) NOT NULL,
    Capacidad INT,
    PRIMARY KEY (ArenaID)
);

CREATE TABLE Equipos (
    EquipoID INT AUTO_INCREMENT,
    Nombre_Equipo VARCHAR(50) NOT NULL,
    Abreviacion CHAR(3) NOT NULL UNIQUE,
    Ciudad VARCHAR(50) NOT NULL,
    DivisionID INT NOT NULL,
    ArenaID INT,
    PRIMARY KEY (EquipoID),
    CONSTRAINT fk_division_equipo
        FOREIGN KEY (DivisionID)
        REFERENCES Divisiones(DivisionID),
    CONSTRAINT fk_arena_equipo
        FOREIGN KEY (ArenaID)
        REFERENCES Arenas(ArenaID)
);

CREATE TABLE Temporadas (
    TemporadaID INT AUTO_INCREMENT,
    Nombre_Temporada VARCHAR(9) NOT NULL,
    Fecha_Inicio DATE,
    Fecha_Fin DATE,
    PRIMARY KEY (TemporadaID)
);

CREATE TABLE Estado_Partido (
    EstadoID INT,
    Nombre_Estado VARCHAR(30),
    PRIMARY KEY (EstadoID)
);

CREATE TABLE Partidos (
    PartidoID INT AUTO_INCREMENT,
    TemporadaID INT NOT NULL,
    Fecha_Partido DATE NOT NULL,
    Equipo_Local INT NOT NULL,
    Equipo_Visitante INT NOT NULL,
    Goles_Local INT,
    Goles_Visitante INT,
    Estado INT,
    ArenaID INT,
    PRIMARY KEY (PartidoID),
    CONSTRAINT fk_temporada_partido
        FOREIGN KEY (TemporadaID)
        REFERENCES Temporadas(TemporadaID),
    CONSTRAINT fk_equipo_local
        FOREIGN KEY (Equipo_Local)
        REFERENCES Equipos(EquipoID),
    CONSTRAINT fk_equipo_visitante
        FOREIGN KEY (Equipo_Visitante)
        REFERENCES Equipos(EquipoID),
    CONSTRAINT fk_estado_partido
        FOREIGN KEY (Estado)
        REFERENCES Estado_Partido(EstadoID),
    CONSTRAINT fk_arena_partido
        FOREIGN KEY (ArenaID)
        REFERENCES Arenas(ArenaID)
);

ALTER TABLE Partidos
ADD COLUMN NHL_GameID BIGINT;

CREATE TABLE Estadisticas_Equipo_Partido (
    EstadisticaID INT AUTO_INCREMENT,
    PartidoID INT NOT NULL,
    EquipoID INT NOT NULL,
    Tiros_Gol INT,
    PowerPlays INT,
    PowerPlay_Goles INT,
    Penales_Minutos INT,
    Faceoffs_Ganados INT,
    PRIMARY KEY (EstadisticaID),
    CONSTRAINT fk_partido_estadistica
        FOREIGN KEY (PartidoID)
        REFERENCES Partidos(PartidoID),
    CONSTRAINT fk_equipo_estadistica
        FOREIGN KEY (EquipoID)
        REFERENCES Equipos(EquipoID)
);

TRUNCATE TABLE Estadisticas_Equipo_Partido;

CREATE TABLE Standing_Equipos (
    StandingID INT AUTO_INCREMENT,
    TemporadaID INT NOT NULL,
    EquipoID INT NOT NULL,
    Partidos_Jugados INT,
    Victorias INT,
    Derrotas INT,
    Derrotas_Overtime INT,
    Puntos INT,
    Goles_Favor INT,
    Goles_Contra INT,
    Diferencia_Goles INT,
    PRIMARY KEY (StandingID),
    CONSTRAINT fk_temporada_standing
        FOREIGN KEY (TemporadaID)
        REFERENCES Temporadas(TemporadaID),
    CONSTRAINT fk_equipo_standing
        FOREIGN KEY (EquipoID)
        REFERENCES Equipos(EquipoID)
);

CREATE TABLE Playoffs (
    PlayoffID INT AUTO_INCREMENT,
    TemporadaID INT NOT NULL,
    Ronda VARCHAR(30),
    Equipo_Local INT NOT NULL,
    Equipo_Visitante INT NOT NULL,
    Ganador INT,
    Juegos_Local INT,
    Juegos_Visitante INT,
    PRIMARY KEY (PlayoffID),
    CONSTRAINT fk_temporada_playoff
        FOREIGN KEY (TemporadaID)
        REFERENCES Temporadas(TemporadaID)
);

TRUNCATE TABLE Playoffs;

CREATE TABLE Predicciones (
    PrediccionID INT AUTO_INCREMENT,
    PartidoID INT NOT NULL,
    Probabilidad_Local DECIMAL(5,2),
    Probabilidad_Visitante DECIMAL(5,2),
    Equipo_Predicho_Ganador INT,
    Fecha_Prediccion DATE,
    PRIMARY KEY (PrediccionID),
    CONSTRAINT fk_partido_prediccion
        FOREIGN KEY (PartidoID)
        REFERENCES Partidos(PartidoID)
);

CREATE TABLE Resultado_Prediccion (
    ResultadoID INT AUTO_INCREMENT,
    PrediccionID INT NOT NULL,
    Fue_Correcta BOOLEAN,
    Diferencia_Goles_Real INT,
    Observacion VARCHAR(100),
    PRIMARY KEY (ResultadoID),
    CONSTRAINT fk_prediccion_resultado
        FOREIGN KEY (PrediccionID)
        REFERENCES Predicciones(PrediccionID)
);