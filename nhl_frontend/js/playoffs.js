const API_URL = 'http://localhost:5001/api/playoffs';

let playoffsGlobal = [];

const nombresRonda = {
    "1st Round": "Primera Ronda",
    "2nd Round": "Segunda Ronda",
    "Conference Finals": "Final de Conferencia",
    "Stanley Cup Final": "Final Stanley Cup"
};

async function cargarPlayoffs() {
    try {
        const respuesta = await fetch(API_URL);
        playoffsGlobal = await respuesta.json();

        llenarRondas();
        mostrarPlayoffs();

        document
            .getElementById('filtro-temporada')
            .addEventListener('change', mostrarPlayoffs);

        document
            .getElementById('filtro-ronda')
            .addEventListener('change', mostrarPlayoffs);

    } catch (error) {
        console.error('Error al cargar playoffs:', error);
    }
}

function llenarRondas() {
    const select = document.getElementById('filtro-ronda');

    select.innerHTML = '<option value="">Todas</option>';

    const rondas = [
        ...new Set(
            playoffsGlobal.map(playoff => playoff.Ronda)
        )
    ];

    rondas.forEach(ronda => {
        const rondaTraducida = nombresRonda[ronda] || ronda;

        select.innerHTML += `
            <option value="${ronda}">
                ${rondaTraducida}
            </option>
        `;
    });
}

function obtenerPrediccion(playoff) {
    /*
        Como todavía no hay resultado real,
        mostramos una predicción simulada para diferenciarla.
        Por defecto gana Equipo_1 la serie 4-2.
    */

    return {
        ganador: playoff.Equipo_1,
        juegosEquipo1: 4,
        juegosEquipo2: 2
    };
}

function mostrarPlayoffs() {
    const temporada = document.getElementById('filtro-temporada').value;
    const ronda = document.getElementById('filtro-ronda').value;
    const tabla = document.getElementById('tabla-playoffs');

    tabla.innerHTML = '';

    const resultados = playoffsGlobal.filter(playoff => {
        return (
            playoff.Nombre_Temporada === temporada &&
            (ronda === '' || playoff.Ronda === ronda)
        );
    });

    document.getElementById('contador-playoffs').textContent =
        `Series encontradas: ${resultados.length}`;

    resultados.forEach(playoff => {
        const fila = document.createElement('tr');

        const rondaTraducida = nombresRonda[playoff.Ronda] || playoff.Ronda;

        const seriePendiente =
            playoff.Ganador === null ||
            playoff.Ganador === 'null' ||
            playoff.Ganador === '' ||
            playoff.Juegos_Local === null ||
            playoff.Juegos_Visitante === null ||
            playoff.Juegos_Local === 'null' ||
            playoff.Juegos_Visitante === 'null';

        if (seriePendiente) {
            const prediccion = obtenerPrediccion(playoff);

            fila.classList.add('fila-prediction');

            fila.innerHTML = `
                <td>
                    <span class="round-badge">
                        ${rondaTraducida}
                    </span>
                </td>

                <td>${playoff.Equipo_1}</td>

                <td>${playoff.Equipo_2}</td>

                <td>
                    <span class="prediction-badge">
                        <i class="fa-solid fa-wand-magic-sparkles"></i>
                        Prediction
                    </span>
                    <br>
                    <small class="prediction-text">
                        Ganador predicho: ${prediccion.ganador}
                    </small>
                </td>

                <td>
                    <span class="prediction-score">
                        ${prediccion.juegosEquipo1}
                    </span>
                </td>

                <td>
                    <span class="prediction-score">
                        ${prediccion.juegosEquipo2}
                    </span>
                </td>
            `;
        } else {
            fila.innerHTML = `
                <td>
                    <span class="round-badge">
                        ${rondaTraducida}
                    </span>
                </td>

                <td>${playoff.Equipo_1}</td>

                <td>${playoff.Equipo_2}</td>

                <td>
                    <span class="winner-badge">
                        <i class="fa-solid fa-trophy"></i>
                        ${playoff.Ganador}
                    </span>
                </td>

                <td>${playoff.Juegos_Local}</td>

                <td>${playoff.Juegos_Visitante}</td>
            `;
        }

        tabla.appendChild(fila);
    });
}

cargarPlayoffs();