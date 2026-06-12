const express = require('express');

const router = express.Router();

const {
    obtenerPlayoffs
} = require('../controllers/playoffsController');

router.get('/', obtenerPlayoffs);

module.exports = router;