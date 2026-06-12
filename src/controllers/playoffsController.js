const db = require('../config/db');

const obtenerPlayoffs = async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT *
            FROM Vista_Playoffs
        `);

        res.json(rows);

    } catch (error) {
        console.error(error);
        res.status(500).json({
            mensaje: 'Error al obtener playoffs'
        });
    }
};

module.exports = {
    obtenerPlayoffs
};