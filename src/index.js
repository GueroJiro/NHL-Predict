require('dotenv').config();

const express = require('express');
const cors = require('cors');

const equiposRoutes = require('./routes/equiposRoutes');
const standingsRoutes = require('./routes/standingsRoutes');
const partidosRoutes = require('./routes/partidosRoutes');
const playoffsRoutes = require('./routes/playoffsRoutes');
const prediccionesRoutes = require('./routes/prediccionesRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/equipos', equiposRoutes);
app.use('/api/standings', standingsRoutes);
app.use('/api/partidos', partidosRoutes);
app.use('/api/playoffs', playoffsRoutes);
app.use('/api/predicciones', prediccionesRoutes);

app.get('/', (req, res) => {
    res.status(200).json({
        mensaje: 'API NHL Predict funcionando'
    });
});

const PORT = process.env.PORT || 5001;

app.listen(PORT, () => {
    console.log(`Servidor corriendo en puerto ${PORT}`);
});