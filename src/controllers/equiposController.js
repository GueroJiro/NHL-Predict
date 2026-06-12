const db = require('../config/db');

const obtenerEquipos = async (req, res) => {
    try {

        const [rows] = await db.query(`
            SELECT *
            FROM Vista_Equipos_Completa
            ORDER BY Nombre_Equipo ASC
        `);

        res.json(rows);

    } catch (error) {

        console.error(error);

        res.status(500).json({
            mensaje: 'Error al obtener equipos'
        });
    }
};

module.exports = {
    obtenerEquipos
};