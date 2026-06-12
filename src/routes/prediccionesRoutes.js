const express = require('express');
const router = express.Router();

const {
    predecirPartido,
    obtenerPrediccionDestacada
} = require('../controllers/prediccionesController');

router.post('/generar', predecirPartido);

router.get('/destacado', obtenerPrediccionDestacada);

module.exports = router;