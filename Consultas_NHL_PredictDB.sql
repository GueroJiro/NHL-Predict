USE NHL_PredictDB;

-- 1. Ver todos los equipos con conferencia, división y arena
SELECT e.EquipoID,
       e.Nombre_Equipo,
       e.Abreviacion,
       e.Ciudad,
       d.Nombre_Division,
       c.Nombre_Conferencia,
       a.Nombre_Arena
FROM Equipos e
JOIN Divisiones d ON e.DivisionID = d.DivisionID
JOIN Conferencias c ON d.ConferenciaID = c.ConferenciaID
JOIN Arenas a ON e.ArenaID = a.ArenaID
ORDER BY e.Nombre_Equipo;


-- 2. Ver standings por temporada
SELECT t.Nombre_Temporada,
       e.Nombre_Equipo,
       se.Partidos_Jugados,
       se.Victorias,
       se.Derrotas,
       se.Derrotas_Overtime,
       se.Puntos,
       se.Goles_Favor,
       se.Goles_Contra,
       se.Diferencia_Goles
FROM Standing_Equipos se
JOIN Temporadas t ON se.TemporadaID = t.TemporadaID
JOIN Equipos e ON se.EquipoID = e.EquipoID
ORDER BY t.Nombre_Temporada, se.Puntos DESC;


-- 3. Top 10 equipos con más puntos en todas las temporadas
SELECT e.Nombre_Equipo,
       SUM(se.Puntos) AS Total_Puntos,
       SUM(se.Victorias) AS Total_Victorias,
       SUM(se.Goles_Favor) AS Total_Goles_Favor
FROM Standing_Equipos se
JOIN Equipos e ON se.EquipoID = e.EquipoID
GROUP BY e.Nombre_Equipo
ORDER BY Total_Puntos DESC
LIMIT 10;


-- 4. Mejores ofensivas por goles a favor
SELECT e.Nombre_Equipo,
       t.Nombre_Temporada,
       se.Goles_Favor
FROM Standing_Equipos se
JOIN Equipos e ON se.EquipoID = e.EquipoID
JOIN Temporadas t ON se.TemporadaID = t.TemporadaID
ORDER BY se.Goles_Favor DESC
LIMIT 10;


-- 5. Mejores defensivas por menos goles en contra
SELECT e.Nombre_Equipo,
       t.Nombre_Temporada,
       se.Goles_Contra
FROM Standing_Equipos se
JOIN Equipos e ON se.EquipoID = e.EquipoID
JOIN Temporadas t ON se.TemporadaID = t.TemporadaID
ORDER BY se.Goles_Contra ASC
LIMIT 10;


-- 6. Partidos de una temporada específica
SELECT p.PartidoID,
       p.NHL_GameID,
       t.Nombre_Temporada,
       p.Fecha_Partido,
       el.Nombre_Equipo AS Equipo_Local,
       ev.Nombre_Equipo AS Equipo_Visitante,
       p.Goles_Local,
       p.Goles_Visitante,
       ep.Nombre_Estado
FROM Partidos p
JOIN Temporadas t ON p.TemporadaID = t.TemporadaID
JOIN Equipos el ON p.Equipo_Local = el.EquipoID
JOIN Equipos ev ON p.Equipo_Visitante = ev.EquipoID
LEFT JOIN Estado_Partido ep ON p.Estado = ep.EstadoID
WHERE t.Nombre_Temporada = '2024-2025'
ORDER BY p.Fecha_Partido;


-- 7. Playoffs por temporada
SELECT t.Nombre_Temporada,
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
LEFT JOIN Equipos g ON p.Ganador = g.EquipoID
ORDER BY t.Nombre_Temporada, p.Ronda;


-- 8. Promedio de goles anotados y recibidos por equipo
SELECT e.Nombre_Equipo,
       AVG(CASE 
           WHEN p.Equipo_Local = e.EquipoID THEN p.Goles_Local
           WHEN p.Equipo_Visitante = e.EquipoID THEN p.Goles_Visitante
       END) AS Promedio_Goles_Anotados,
       AVG(CASE 
           WHEN p.Equipo_Local = e.EquipoID THEN p.Goles_Visitante
           WHEN p.Equipo_Visitante = e.EquipoID THEN p.Goles_Local
       END) AS Promedio_Goles_Recibidos
FROM Equipos e
JOIN Partidos p 
    ON e.EquipoID = p.Equipo_Local 
    OR e.EquipoID = p.Equipo_Visitante
WHERE p.Goles_Local IS NOT NULL
  AND p.Goles_Visitante IS NOT NULL
GROUP BY e.EquipoID, e.Nombre_Equipo
ORDER BY Promedio_Goles_Anotados DESC;


-- 9. Rendimiento de local por equipo
SELECT e.Nombre_Equipo,
       COUNT(*) AS Partidos_Local,
       SUM(CASE WHEN p.Goles_Local > p.Goles_Visitante THEN 1 ELSE 0 END) AS Victorias_Local,
       ROUND(SUM(CASE WHEN p.Goles_Local > p.Goles_Visitante THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Porcentaje_Victoria_Local
FROM Partidos p
JOIN Equipos e ON p.Equipo_Local = e.EquipoID
WHERE p.Goles_Local IS NOT NULL
  AND p.Goles_Visitante IS NOT NULL
GROUP BY e.EquipoID, e.Nombre_Equipo
ORDER BY Porcentaje_Victoria_Local DESC;


-- 10. Rendimiento de visitante por equipo
SELECT e.Nombre_Equipo,
       COUNT(*) AS Partidos_Visitante,
       SUM(CASE WHEN p.Goles_Visitante > p.Goles_Local THEN 1 ELSE 0 END) AS Victorias_Visitante,
       ROUND(SUM(CASE WHEN p.Goles_Visitante > p.Goles_Local THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS Porcentaje_Victoria_Visitante
FROM Partidos p
JOIN Equipos e ON p.Equipo_Visitante = e.EquipoID
WHERE p.Goles_Local IS NOT NULL
  AND p.Goles_Visitante IS NOT NULL
GROUP BY e.EquipoID, e.Nombre_Equipo
ORDER BY Porcentaje_Victoria_Visitante DESC;


-- 11. Comparación entre dos equipos específicos
SELECT el.Nombre_Equipo AS Equipo_Local,
       ev.Nombre_Equipo AS Equipo_Visitante,
       COUNT(*) AS Partidos_Entre_Ellos,
       SUM(CASE WHEN p.Goles_Local > p.Goles_Visitante THEN 1 ELSE 0 END) AS Victorias_Local,
       SUM(CASE WHEN p.Goles_Visitante > p.Goles_Local THEN 1 ELSE 0 END) AS Victorias_Visitante,
       AVG(p.Goles_Local) AS Promedio_Goles_Local,
       AVG(p.Goles_Visitante) AS Promedio_Goles_Visitante
FROM Partidos p
JOIN Equipos el ON p.Equipo_Local = el.EquipoID
JOIN Equipos ev ON p.Equipo_Visitante = ev.EquipoID
WHERE el.Abreviacion = 'TOR'
  AND ev.Abreviacion = 'BOS'
  AND p.Goles_Local IS NOT NULL
  AND p.Goles_Visitante IS NOT NULL
GROUP BY el.Nombre_Equipo, ev.Nombre_Equipo;


-- 12. Últimos 10 partidos de un equipo
SELECT p.Fecha_Partido,
       el.Nombre_Equipo AS Local,
       ev.Nombre_Equipo AS Visitante,
       p.Goles_Local,
       p.Goles_Visitante,
       CASE
           WHEN p.Equipo_Local = e.EquipoID AND p.Goles_Local > p.Goles_Visitante THEN 'Victoria'
           WHEN p.Equipo_Visitante = e.EquipoID AND p.Goles_Visitante > p.Goles_Local THEN 'Victoria'
           ELSE 'Derrota'
       END AS Resultado
FROM Partidos p
JOIN Equipos el ON p.Equipo_Local = el.EquipoID
JOIN Equipos ev ON p.Equipo_Visitante = ev.EquipoID
JOIN Equipos e ON e.Abreviacion = 'TOR'
WHERE (p.Equipo_Local = e.EquipoID OR p.Equipo_Visitante = e.EquipoID)
  AND p.Goles_Local IS NOT NULL
  AND p.Goles_Visitante IS NOT NULL
ORDER BY p.Fecha_Partido DESC
LIMIT 10;


-- 13. Promedio de tiros a gol por equipo
SELECT e.Nombre_Equipo,
       AVG(ep.Tiros_Gol) AS Promedio_Tiros_Gol,
       AVG(ep.PowerPlay_Goles) AS Promedio_Goles_PowerPlay,
       AVG(ep.Penales_Minutos) AS Promedio_Minutos_Penalizacion
FROM Estadisticas_Equipo_Partido ep
JOIN Equipos e ON ep.EquipoID = e.EquipoID
GROUP BY e.EquipoID, e.Nombre_Equipo
ORDER BY Promedio_Tiros_Gol DESC;


-- 14. Datos base para predicción entre dos equipos
SELECT e.Nombre_Equipo,
       e.Abreviacion,
       AVG(CASE 
           WHEN p.Equipo_Local = e.EquipoID THEN p.Goles_Local
           WHEN p.Equipo_Visitante = e.EquipoID THEN p.Goles_Visitante
       END) AS Promedio_Goles_Favor,
       AVG(CASE 
           WHEN p.Equipo_Local = e.EquipoID THEN p.Goles_Visitante
           WHEN p.Equipo_Visitante = e.EquipoID THEN p.Goles_Local
       END) AS Promedio_Goles_Contra,
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
WHERE e.Abreviacion IN ('TOR', 'BOS')
  AND p.Goles_Local IS NOT NULL
  AND p.Goles_Visitante IS NOT NULL
GROUP BY e.EquipoID, e.Nombre_Equipo, e.Abreviacion;