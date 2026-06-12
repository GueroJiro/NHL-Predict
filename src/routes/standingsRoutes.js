const express = require('express');

const router = express.Router();

const {
    obtenerStandings
} = require('../controllers/standingsController');

router.get('/', obtenerStandings);

module.exports = router;