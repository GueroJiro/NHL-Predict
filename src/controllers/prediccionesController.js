const db = require('../config/db');

const calcularPrediccion = (local, visitante) => {
    const ataqueLocal = Number(local.Promedio_Goles_Favor);
    const defensaLocal = Number(local.Promedio_Goles_Contra);
    const ataqueVisitante = Number(visitante.Promedio_Goles_Favor);
    const defensaVisitante = Number(visitante.Promedio_Goles_Contra);

    const tirosLocal = Number(local.Promedio_Tiros);
    const tirosVisitante = Number(visitante.Promedio_Tiros);

    const puntosLocal = Number(local.Puntos || 0);
    const puntosVisitante = Number(visitante.Puntos || 0);

    const victoriasLocal = Number(local.Victorias || 0);
    const victoriasVisitante = Number(visitante.Victorias || 0);

    const diferenciaGolesLocal = Number(local.Diferencia_Goles || 0);
    const diferenciaGolesVisitante = Number(visitante.Diferencia_Goles || 0);

    const ventajaLocal = 0.25;

    let golesEsperadosLocal =
        ((ataqueLocal + defensaVisitante) / 2) + ventajaLocal;

    let golesEsperadosVisitante =
        (ataqueVisitante + defensaLocal) / 2;

    if (tirosLocal > tirosVisitante) {
        golesEsperadosLocal += 0.15;
    } else if (tirosVisitante > tirosLocal) {
        golesEsperadosVisitante += 0.15;
    }

    golesEsperadosLocal = Math.max(1, golesEsperadosLocal);
    golesEsperadosVisitante = Math.max(1, golesEsperadosVisitante);

    let fuerzaLocal =
        (golesEsperadosLocal * 10) +
        (puntosLocal * 0.35) +
        (victoriasLocal * 0.6) +
        (diferenciaGolesLocal * 0.15) +
        3;

    let fuerzaVisitante =
        (golesEsperadosVisitante * 10) +
        (puntosVisitante * 0.35) +
        (victoriasVisitante * 0.6) +
        (diferenciaGolesVisitante * 0.15);

    fuerzaLocal = Math.max(1, fuerzaLocal);
    fuerzaVisitante = Math.max(1, fuerzaVisitante);

    let probLocal =
        (fuerzaLocal / (fuerzaLocal + fuerzaVisitante)) * 100;

    let probVisitante = 100 - probLocal;

    probLocal = Math.min(95, Math.max(5, probLocal));
    probVisitante = 100 - probLocal;

    let marcadorLocal = Math.round(golesEsperadosLocal);
    let marcadorVisitante = Math.round(golesEsperadosVisitante);

    marcadorLocal = Math.max(1, marcadorLocal);
    marcadorVisitante = Math.max(1, marcadorVisitante);

    const diferenciaProb = Math.abs(probLocal - probVisitante);

    let diferenciaMarcador = 1;

    if (diferenciaProb >= 25) {
        diferenciaMarcador = 3;
    } else if (diferenciaProb >= 15) {
        diferenciaMarcador = 2;
    }

    if (probLocal > probVisitante && marcadorLocal <= marcadorVisitante) {
        marcadorLocal = marcadorVisitante + diferenciaMarcador;
    }

    if (probVisitante > probLocal && marcadorVisitante <= marcadorLocal) {
        marcadorVisitante = marcadorLocal + diferenciaMarcador;
    }

    if (probLocal > probVisitante && diferenciaProb >= 20) {
        marcadorVisitante = Math.max(1, marcadorVisitante - 1);
    }

    if (probVisitante > probLocal && diferenciaProb >= 20) {
        marcadorLocal = Math.max(1, marcadorLocal - 1);
    }

    const ganador =
        probLocal >= probVisitante
            ? local.Nombre_Equipo
            : visitante.Nombre_Equipo;

    const equipoGanadorID =
        probLocal >= probVisitante
            ? local.EquipoID
            : visitante.EquipoID;

    const totalTirosEsperados = tirosLocal + tirosVisitante;

    return {
        probLocal,
        probVisitante,
        golesEsperadosLocal,
        golesEsperadosVisitante,
        marcadorLocal,
        marcadorVisitante,
        diferenciaProb,
        ganador,
        equipoGanadorID,
        tirosLocal,
        tirosVisitante,
        totalTirosEsperados,
        puntosLocal,
        puntosVisitante,
        victoriasLocal,
        victoriasVisitante,
        diferenciaGolesLocal,
        diferenciaGolesVisitante
    };
};

const predecirPartido = async (req, res) => {
    try {
        const { equipoLocal, equipoVisitante } = req.body;

        if (!equipoLocal || !equipoVisitante) {
            return res.status(400).json({
                mensaje: 'Debes enviar equipoLocal y equipoVisitante'
            });
        }

        if (equipoLocal === equipoVisitante) {
            return res.status(400).json({
                mensaje: 'El equipo local y visitante no pueden ser el mismo'
            });
        }

        const [equipos] = await db.query(`
            SELECT *
            FROM Vista_Resumen_Equipos
            WHERE Abreviacion IN (?, ?)
        `, [equipoLocal, equipoVisitante]);

        if (equipos.length !== 2) {
            return res.status(404).json({
                mensaje: 'Equipos no encontrados'
            });
        }

        const local = equipos.find(equipo => equipo.Abreviacion === equipoLocal);
        const visitante = equipos.find(equipo => equipo.Abreviacion === equipoVisitante);

        const resultado = calcularPrediccion(local, visitante);

        const [partidos] = await db.query(`
            SELECT PartidoID
            FROM Partidos
            WHERE Equipo_Local = ?
              AND Equipo_Visitante = ?
            ORDER BY Fecha_Partido DESC
            LIMIT 1
        `, [local.EquipoID, visitante.EquipoID]);

        if (partidos.length === 0) {
            return res.status(404).json({
                mensaje: 'No se encontró un partido registrado entre esos equipos con ese local y visitante'
            });
        }

        const partidoID = partidos[0].PartidoID;

        const [resultadoInsert] = await db.query(`
            INSERT INTO Predicciones
            (
                PartidoID,
                Probabilidad_Local,
                Probabilidad_Visitante,
                Equipo_Predicho_Ganador,
                Fecha_Prediccion
            )
            VALUES (?, ?, ?, ?, CURDATE())
        `, [
            partidoID,
            resultado.probLocal.toFixed(2),
            resultado.probVisitante.toFixed(2),
            resultado.equipoGanadorID
        ]);

        res.json({
            prediccion_id: resultadoInsert.insertId,
            partido_id: partidoID,

            equipo_local: local.Nombre_Equipo,
            equipo_visitante: visitante.Nombre_Equipo,

            probabilidad_local: resultado.probLocal.toFixed(2),
            probabilidad_visitante: resultado.probVisitante.toFixed(2),

            goles_esperados_local: resultado.golesEsperadosLocal.toFixed(2),
            goles_esperados_visitante: resultado.golesEsperadosVisitante.toFixed(2),

            marcador_probable: `${local.Nombre_Equipo} ${resultado.marcadorLocal} - ${resultado.marcadorVisitante} ${visitante.Nombre_Equipo}`,

            tiros_esperados_local: resultado.tirosLocal.toFixed(2),
            tiros_esperados_visitante: resultado.tirosVisitante.toFixed(2),
            total_tiros_esperados: resultado.totalTirosEsperados.toFixed(2),

            puntos_local: resultado.puntosLocal,
            puntos_visitante: resultado.puntosVisitante,
            victorias_local: resultado.victoriasLocal,
            victorias_visitante: resultado.victoriasVisitante,
            diferencia_goles_local: resultado.diferenciaGolesLocal,
            diferencia_goles_visitante: resultado.diferenciaGolesVisitante,
            diferencia_probabilidad: resultado.diferenciaProb.toFixed(2),

            ganador_predicho: resultado.ganador,
            mensaje: 'Predicción guardada correctamente'
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            mensaje: 'Error al generar predicción'
        });
    }
};

const obtenerPrediccionDestacada = async (req, res) => {
    try {
        const [partidos] = await db.query(`
            SELECT
                p.PartidoID,
                p.Fecha_Partido,
                el.EquipoID AS LocalID,
                el.Abreviacion AS AbreviacionLocal,
                el.Nombre_Equipo AS NombreLocal,
                ev.EquipoID AS VisitanteID,
                ev.Abreviacion AS AbreviacionVisitante,
                ev.Nombre_Equipo AS NombreVisitante
            FROM Partidos p
            INNER JOIN Equipos el ON p.Equipo_Local = el.EquipoID
            INNER JOIN Equipos ev ON p.Equipo_Visitante = ev.EquipoID
            ORDER BY p.Fecha_Partido DESC
            LIMIT 1
        `);

        if (partidos.length === 0) {
            return res.status(404).json({
                mensaje: 'No hay partidos disponibles'
            });
        }

        const partido = partidos[0];

        const [equipos] = await db.query(`
            SELECT *
            FROM Vista_Resumen_Equipos
            WHERE EquipoID IN (?, ?)
        `, [partido.LocalID, partido.VisitanteID]);

        if (equipos.length !== 2) {
            return res.status(404).json({
                mensaje: 'No se encontraron los equipos del partido destacado'
            });
        }

        const local = equipos.find(equipo => equipo.EquipoID === partido.LocalID);
        const visitante = equipos.find(equipo => equipo.EquipoID === partido.VisitanteID);

        const resultado = calcularPrediccion(local, visitante);

        res.json({
            partido_id: partido.PartidoID,
            fecha_partido: partido.Fecha_Partido,

            abreviacion_local: partido.AbreviacionLocal,
            abreviacion_visitante: partido.AbreviacionVisitante,

            equipo_local: partido.NombreLocal,
            equipo_visitante: partido.NombreVisitante,

            probabilidad_local: resultado.probLocal.toFixed(0),
            probabilidad_visitante: resultado.probVisitante.toFixed(0),

            marcador_probable: `${partido.NombreLocal} ${resultado.marcadorLocal} - ${resultado.marcadorVisitante} ${partido.NombreVisitante}`,
            ganador_predicho: resultado.ganador
        });

    } catch (error) {
        console.error(error);

        res.status(500).json({
            mensaje: 'Error al obtener partido destacado'
        });
    }
};

module.exports = {
    predecirPartido,
    obtenerPrediccionDestacada
};