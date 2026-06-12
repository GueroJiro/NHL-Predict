const db = require('../config/db');

const obtenerStandings = async (req, res) => {
    try {

        const [rows] = await db.query(`
            SELECT *
            FROM Vista_Standings
        `);

        res.json(rows);

    } catch (error) {

        console.error(error);

        res.status(500).json({
            mensaje: 'Error al obtener standings'
        });
    }
};

module.exports = {
    obtenerStandings
};