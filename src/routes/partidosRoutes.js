const express = require('express');

const router = express.Router();

const {
    obtenerPartidos
} = require('../controllers/partidosController');

router.get('/', obtenerPartidos);

module.exports = router;