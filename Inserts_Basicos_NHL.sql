USE NHL_PredictDB;

-- INSERTS CONFERENCIAS
INSERT INTO Conferencias (Nombre_Conferencia) VALUES ('Eastern');
INSERT INTO Conferencias (Nombre_Conferencia) VALUES ('Western');

-- INSERTS DIVISIONES
INSERT INTO Divisiones (Nombre_Division, ConferenciaID) VALUES ('Atlantic', (SELECT ConferenciaID FROM Conferencias WHERE Nombre_Conferencia = 'Eastern'));
INSERT INTO Divisiones (Nombre_Division, ConferenciaID) VALUES ('Central', (SELECT ConferenciaID FROM Conferencias WHERE Nombre_Conferencia = 'Western'));
INSERT INTO Divisiones (Nombre_Division, ConferenciaID) VALUES ('Metropolitan', (SELECT ConferenciaID FROM Conferencias WHERE Nombre_Conferencia = 'Eastern'));
INSERT INTO Divisiones (Nombre_Division, ConferenciaID) VALUES ('Pacific', (SELECT ConferenciaID FROM Conferencias WHERE Nombre_Conferencia = 'Western'));

-- INSERTS TEMPORADAS
INSERT INTO Temporadas (Nombre_Temporada, Fecha_Inicio, Fecha_Fin) VALUES
('2021-2022', '2021-10-12', '2022-06-26'),
('2022-2023', '2022-10-07', '2023-06-13'),
('2023-2024', '2023-10-10', '2024-06-24'),
('2024-2025', '2024-10-04', '2025-06-17'),
('2025-2026', '2025-10-07', NULL);

-- INSERTS ESTADO_PARTIDO
INSERT INTO Estado_Partido (EstadoID, Nombre_Estado) VALUES
(1, 'Futuro'),
(2, 'En Vivo'),
(3, 'Finalizado'),
(4, 'Previo');

-- INSERTS ARENAS TEMPORALES
INSERT INTO Arenas (Nombre_Arena, Ciudad, Estado, Pais, Capacidad) VALUES
('Arena Pendiente', 'Pendiente', NULL, 'Pendiente', NULL);

-- INSERTS EQUIPOS
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Anaheim Ducks', 'ANA', 'Anaheim', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Pacific'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Arizona Coyotes', 'ARI', 'Arizona', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Boston Bruins', 'BOS', 'Boston', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Atlantic'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Buffalo Sabres', 'BUF', 'Buffalo', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Atlantic'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Carolina Hurricanes', 'CAR', 'Carolina', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Metropolitan'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Columbus Blue Jackets', 'CBJ', 'Columbus', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Metropolitan'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Calgary Flames', 'CGY', 'Calgary', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Pacific'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Chicago Blackhawks', 'CHI', 'Chicago', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Colorado Avalanche', 'COL', 'Colorado', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Dallas Stars', 'DAL', 'Dallas', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Detroit Red Wings', 'DET', 'Detroit', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Atlantic'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Edmonton Oilers', 'EDM', 'Edmonton', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Pacific'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Florida Panthers', 'FLA', 'Florida', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Atlantic'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Los Angeles Kings', 'LAK', 'Los Angeles', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Pacific'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Minnesota Wild', 'MIN', 'Minnesota', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Montréal Canadiens', 'MTL', 'Montréal', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Atlantic'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('New Jersey Devils', 'NJD', 'New Jersey', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Metropolitan'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Nashville Predators', 'NSH', 'Nashville', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('New York Islanders', 'NYI', 'NY Islanders', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Metropolitan'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('New York Rangers', 'NYR', 'NY Rangers', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Metropolitan'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Ottawa Senators', 'OTT', 'Ottawa', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Atlantic'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Philadelphia Flyers', 'PHI', 'Philadelphia', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Metropolitan'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Pittsburgh Penguins', 'PIT', 'Pittsburgh', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Metropolitan'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Seattle Kraken', 'SEA', 'Seattle', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Pacific'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('San Jose Sharks', 'SJS', 'San Jose', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Pacific'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('St. Louis Blues', 'STL', 'St. Louis', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Tampa Bay Lightning', 'TBL', 'Tampa Bay', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Atlantic'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Toronto Maple Leafs', 'TOR', 'Toronto', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Atlantic'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Utah Mammoth', 'UTA', 'Utah', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Vancouver Canucks', 'VAN', 'Vancouver', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Pacific'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Vegas Golden Knights', 'VGK', 'Vegas', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Pacific'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Winnipeg Jets', 'WPG', 'Winnipeg', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Central'), 1);
INSERT INTO Equipos (Nombre_Equipo, Abreviacion, Ciudad, DivisionID, ArenaID) VALUES ('Washington Capitals', 'WSH', 'Washington', (SELECT DivisionID FROM Divisiones WHERE Nombre_Division = 'Metropolitan'), 1);


SELECT COUNT(*) AS Conferencias FROM Conferencias;

SELECT COUNT(*) AS Divisiones FROM Divisiones;

SELECT COUNT(*) AS Equipos FROM Equipos;

SELECT COUNT(*) AS Temporadas FROM Temporadas;

SELECT COUNT(*) AS Estados FROM Estado_Partido;

SELECT Abreviacion,
       Nombre_Equipo,
       Ciudad
FROM Equipos
ORDER BY Abreviacion;

SELECT *
FROM Arenas;

SELECT COUNT(*)
FROM Equipos
WHERE ArenaID = 1;

SELECT COUNT(*) AS Total_Arenas
FROM Arenas;