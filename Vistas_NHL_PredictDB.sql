USE NHL_PredictDB;

-- ==========================================
-- VISTA 1: INFORMACION COMPLETA DE EQUIPOS
-- ==========================================

CREATE OR REPLACE VIEW Vista_Equipos_Completa AS
SELECT
    e.EquipoID,
    e.Nombre_Equipo,
    e.Abreviacion,
    e.Ciudad,
    d.Nombre_Division,
    c.Nombre_Conferencia,
    a.Nombre_Arena
FROM Equipos e
JOIN Divisiones d ON e.DivisionID = d.DivisionID
JOIN Conferencias c ON d.ConferenciaID = c.ConferenciaID
JOIN Arenas a ON e.ArenaID = a.ArenaID;


-- ==========================================
-- VISTA 2: STANDINGS COMPLETOS
-- ==========================================

CREATE OR REPLACE VIEW Vista_Standings AS
SELECT
    t.Nombre_Temporada,
    e.Nombre_Equipo,
    e.Abreviacion,
    se.Partidos_Jugados,
    se.Victorias,
    se.Derrotas,
    se.Derrotas_Overtime,
    se.Puntos,
    se.Goles_Favor,
    se.Goles_Contra,
    se.Diferencia_Goles
FROM Standing_Equipos se
JOIN Equipos e ON se.EquipoID = e.EquipoID
JOIN Temporadas t ON se.TemporadaID = t.TemporadaID;


-- ==========================================
-- VISTA 3: PARTIDOS COMPLETOS
-- ==========================================

CREATE OR REPLACE VIEW Vista_Partidos AS
SELECT
    p.PartidoID,
    p.NHL_GameID,
    t.Nombre_Temporada,
    p.Fecha_Partido,
    el.Nombre_Equipo AS Equipo_Local,
    ev.Nombre_Equipo AS Equipo_Visitante,
    p.Goles_Local,
    p.Goles_Visitante
FROM Partidos p
JOIN Temporadas t ON p.TemporadaID = t.TemporadaID
JOIN Equipos el ON p.Equipo_Local = el.EquipoID
JOIN Equipos ev ON p.Equipo_Visitante = ev.EquipoID;


-- ==========================================
-- VISTA 4: RESUMEN ESTADISTICO POR EQUIPO
-- ==========================================

CREATE OR REPLACE VIEW Vista_Resumen_Equipos AS
SELECT
    e.EquipoID,
    e.Nombre_Equipo,
    e.Abreviacion,

    AVG(
        CASE
            WHEN p.Equipo_Local = e.EquipoID THEN p.Goles_Local
            WHEN p.Equipo_Visitante = e.EquipoID THEN p.Goles_Visitante
        END
    ) AS Promedio_Goles_Favor,

    AVG(
        CASE
            WHEN p.Equipo_Local = e.EquipoID THEN p.Goles_Visitante
            WHEN p.Equipo_Visitante = e.EquipoID THEN p.Goles_Local
        END
    ) AS Promedio_Goles_Contra,

    AVG(ep.Tiros_Gol) AS Promedio_Tiros,
    AVG(ep.PowerPlay_Goles) AS Promedio_PowerPlay_Goles,
    AVG(ep.Penales_Minutos) AS Promedio_Penales

FROM Equipos e

JOIN Partidos p
ON e.EquipoID = p.Equipo_Local
OR e.EquipoID = p.Equipo_Visitante

JOIN Estadisticas_Equipo_Partido ep
ON ep.PartidoID = p.PartidoID
AND ep.EquipoID = e.EquipoID

GROUP BY
    e.EquipoID,
    e.Nombre_Equipo,
    e.Abreviacion;


-- ==========================================
-- VISTA 5: PLAYOFFS
-- ==========================================

CREATE OR REPLACE VIEW Vista_Playoffs AS
SELECT
    t.Nombre_Temporada,
    p.Ronda,
    el.Nombre_Equipo AS Equipo_1,
    ev.Nombre_Equipo AS Equipo_2,
    g.Nombre_Equipo AS Ganador,
    p.Juegos_Local,
    p.Juegos_Visitante
FROM Playoffs p
JOIN Temporadas t ON p.TemporadaID = t.TemporadaID
JOIN Equipos el ON p.Equipo_Local = el.EquipoID
JOIN Equipos ev ON p.Equipo_Visitante = ev.EquipoID
LEFT JOIN Equipos g ON p.Ganador = g.EquipoID;