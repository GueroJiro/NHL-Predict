USE NHL_PredictDB;

-- INSERTS ARENAS NHL

INSERT INTO Arenas (Nombre_Arena, Ciudad, Estado, Pais, Capacidad) VALUES
('Honda Center', 'Anaheim', 'California', 'Estados Unidos', NULL),
('Mullett Arena', 'Tempe', 'Arizona', 'Estados Unidos', NULL),
('TD Garden', 'Boston', 'Massachusetts', 'Estados Unidos', NULL),
('KeyBank Center', 'Buffalo', 'New York', 'Estados Unidos', NULL),
('PNC Arena', 'Raleigh', 'North Carolina', 'Estados Unidos', NULL),
('Nationwide Arena', 'Columbus', 'Ohio', 'Estados Unidos', NULL),
('Scotiabank Saddledome', 'Calgary', 'Alberta', 'Canadá', NULL),
('United Center', 'Chicago', 'Illinois', 'Estados Unidos', NULL),
('Ball Arena', 'Denver', 'Colorado', 'Estados Unidos', NULL),
('American Airlines Center', 'Dallas', 'Texas', 'Estados Unidos', NULL),
('Little Caesars Arena', 'Detroit', 'Michigan', 'Estados Unidos', NULL),
('Rogers Place', 'Edmonton', 'Alberta', 'Canadá', NULL),
('Amerant Bank Arena', 'Sunrise', 'Florida', 'Estados Unidos', NULL),
('Crypto.com Arena', 'Los Angeles', 'California', 'Estados Unidos', NULL),
('Grand Casino Arena', 'Saint Paul', 'Minnesota', 'Estados Unidos', NULL),
('Bell Centre', 'Montreal', 'Quebec', 'Canadá', NULL),
('Prudential Center', 'Newark', 'New Jersey', 'Estados Unidos', NULL),
('Bridgestone Arena', 'Nashville', 'Tennessee', 'Estados Unidos', NULL),
('UBS Arena', 'Elmont', 'New York', 'Estados Unidos', NULL),
('Madison Square Garden', 'New York', 'New York', 'Estados Unidos', NULL),
('Canadian Tire Centre', 'Ottawa', 'Ontario', 'Canadá', NULL),
('Xfinity Mobile Arena', 'Philadelphia', 'Pennsylvania', 'Estados Unidos', NULL),
('PPG Paints Arena', 'Pittsburgh', 'Pennsylvania', 'Estados Unidos', NULL),
('Climate Pledge Arena', 'Seattle', 'Washington', 'Estados Unidos', NULL),
('SAP Center at San Jose', 'San Jose', 'California', 'Estados Unidos', NULL),
('Enterprise Center', 'St. Louis', 'Missouri', 'Estados Unidos', NULL),
('Benchmark International Arena', 'Tampa', 'Florida', 'Estados Unidos', NULL),
('Scotiabank Arena', 'Toronto', 'Ontario', 'Canadá', NULL),
('Delta Center', 'Salt Lake City', 'Utah', 'Estados Unidos', NULL),
('Rogers Arena', 'Vancouver', 'British Columbia', 'Canadá', NULL),
('T-Mobile Arena', 'Las Vegas', 'Nevada', 'Estados Unidos', NULL),
('Canada Life Centre', 'Winnipeg', 'Manitoba', 'Canadá', NULL),
('Capital One Arena', 'Washington', 'D.C.', 'Estados Unidos', NULL);

-- ACTUALIZAR EQUIPOS CON SU ARENA

UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Honda Center') WHERE Abreviacion = 'ANA';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Mullett Arena') WHERE Abreviacion = 'ARI';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'TD Garden') WHERE Abreviacion = 'BOS';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'KeyBank Center') WHERE Abreviacion = 'BUF';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'PNC Arena') WHERE Abreviacion = 'CAR';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Nationwide Arena') WHERE Abreviacion = 'CBJ';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Scotiabank Saddledome') WHERE Abreviacion = 'CGY';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'United Center') WHERE Abreviacion = 'CHI';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Ball Arena') WHERE Abreviacion = 'COL';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'American Airlines Center') WHERE Abreviacion = 'DAL';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Little Caesars Arena') WHERE Abreviacion = 'DET';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Rogers Place') WHERE Abreviacion = 'EDM';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Amerant Bank Arena') WHERE Abreviacion = 'FLA';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Crypto.com Arena') WHERE Abreviacion = 'LAK';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Grand Casino Arena') WHERE Abreviacion = 'MIN';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Bell Centre') WHERE Abreviacion = 'MTL';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Prudential Center') WHERE Abreviacion = 'NJD';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Bridgestone Arena') WHERE Abreviacion = 'NSH';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'UBS Arena') WHERE Abreviacion = 'NYI';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Madison Square Garden') WHERE Abreviacion = 'NYR';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Canadian Tire Centre') WHERE Abreviacion = 'OTT';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Xfinity Mobile Arena') WHERE Abreviacion = 'PHI';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'PPG Paints Arena') WHERE Abreviacion = 'PIT';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Climate Pledge Arena') WHERE Abreviacion = 'SEA';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'SAP Center at San Jose') WHERE Abreviacion = 'SJS';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Enterprise Center') WHERE Abreviacion = 'STL';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Benchmark International Arena') WHERE Abreviacion = 'TBL';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Scotiabank Arena') WHERE Abreviacion = 'TOR';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Delta Center') WHERE Abreviacion = 'UTA';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Rogers Arena') WHERE Abreviacion = 'VAN';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'T-Mobile Arena') WHERE Abreviacion = 'VGK';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Canada Life Centre') WHERE Abreviacion = 'WPG';
UPDATE Equipos SET ArenaID = (SELECT ArenaID FROM Arenas WHERE Nombre_Arena = 'Capital One Arena') WHERE Abreviacion = 'WSH';

-- BORRAR ARENA TEMPORAL
DELETE FROM Arenas
WHERE ArenaID = 1;

SELECT COUNT(*) AS Total_Arenas
FROM Arenas;

SELECT COUNT(*)
FROM Equipos
WHERE ArenaID = 1;