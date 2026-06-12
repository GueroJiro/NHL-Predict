const db = require('../config/db');

const obtenerPartidos = async (req, res) => {
    try {
        const pagina = parseInt(req.query.pagina) || 1;
        const limite = parseInt(req.query.limite) || 20;
        const fecha = req.query.fecha || null;
        const proximos = req.query.proximos || null;

        const offset = (pagina - 1) * limite;

        let query = `
            SELECT *
            FROM Vista_Partidos
        `;

        let countQuery = `
            SELECT COUNT(*) AS total
            FROM Vista_Partidos
        `;

        const condiciones = [];
        const params = [];

        if (fecha) {
            condiciones.push(`DATE(Fecha_Partido) = ?`);
            params.push(fecha);
        }

        if (proximos === 'true') {
            condiciones.push(`
                Fecha_Partido >= CURDATE()
                AND Goles_Local IS NULL
                AND Goles_Visitante IS NULL
            `);
        }

        if (condiciones.length > 0) {
            query += ` WHERE ` + condiciones.join(' AND ');
            countQuery += ` WHERE ` + condiciones.join(' AND ');
        }

        query += `
            ORDER BY Fecha_Partido ASC
            LIMIT ? OFFSET ?
        `;

        const [partidos] = await db.query(query, [...params, limite, offset]);
        const [totalResult] = await db.query(countQuery, params);

        const total = totalResult[0].total;
        const totalPaginas = Math.ceil(total / limite);

        res.json({
            pagina,
            limite,
            total,
            totalPaginas,
            partidos
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({
            mensaje: 'Error al obtener partidos'
        });
    }
};

module.exports = {
    obtenerPartidos
};