const API_URL = 'http://localhost:5001/api/partidos';
const API_PREDICCIONES = 'http://localhost:5001/api/predicciones/generar';

let paginaActual = 1;
const limite = 20;
let fechaSeleccionada = '';

function obtenerAbreviacionEquipo(nombreEquipo) {
    const abreviaciones = {
        "Anaheim Ducks": "ANA",
        "Arizona Coyotes": "ARI",
        "Boston Bruins": "BOS",
        "Buffalo Sabres": "BUF",
        "Calgary Flames": "CGY",
        "Carolina Hurricanes": "CAR",
        "Chicago Blackhawks": "CHI",
        "Colorado Avalanche": "COL",
        "Columbus Blue Jackets": "CBJ",
        "Dallas Stars": "DAL",
        "Detroit Red Wings": "DET",
        "Edmonton Oilers": "EDM",
        "Florida Panthers": "FLA",
        "Los Angeles Kings": "LAK",
        "Minnesota Wild": "MIN",
        "Montreal Canadiens": "MTL",
        "Montréal Canadiens": "MTL",
        "Nashville Predators": "NSH",
        "New Jersey Devils": "NJD",
        "New York Islanders": "NYI",
        "New York Rangers": "NYR",
        "Ottawa Senators": "OTT",
        "Philadelphia Flyers": "PHI",
        "Pittsburgh Penguins": "PIT",
        "San Jose Sharks": "SJS",
        "Seattle Kraken": "SEA",
        "St. Louis Blues": "STL",
        "Tampa Bay Lightning": "TBL",
        "Toronto Maple Leafs": "TOR",
        "Utah Hockey Club": "UTA",
        "Vancouver Canucks": "VAN",
        "Vegas Golden Knights": "VGK",
        "Washington Capitals": "WSH",
        "Winnipeg Jets": "WPG"
    };

    return abreviaciones[nombreEquipo] || nombreEquipo;
}

function obtenerLogoEquipo(nombreEquipo) {
    const abreviacion = obtenerAbreviacionEquipo(nombreEquipo);
    return `https://assets.nhle.com/logos/nhl/svg/${abreviacion}_light.svg`;
}

async function cargarPartidos() {
    try {
        let url = `${API_URL}?pagina=${paginaActual}&limite=${limite}`;

        if (fechaSeleccionada !== '') {
            url += `&fecha=${fechaSeleccionada}`;
        }

        const respuesta = await fetch(url);
        const data = await respuesta.json();

        mostrarPartidos(data);

    } catch (error) {
        console.error('Error al cargar partidos:', error);
    }
}

async function cargarProximosPartidos() {
    try {
        const respuesta = await fetch(`${API_URL}?proximos=true&limite=6`);
        const data = await respuesta.json();

        mostrarProximosPartidos(data.partidos || []);

    } catch (error) {
        console.error('Error al cargar próximos partidos:', error);
    }
}

async function obtenerPrediccionPartido(partido) {
    try {
        const respuesta = await fetch(API_PREDICCIONES, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                equipoLocal: obtenerAbreviacionEquipo(partido.Equipo_Local),
                equipoVisitante: obtenerAbreviacionEquipo(partido.Equipo_Visitante)
            })
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            return {
                ganador: 'No disponible',
                golesLocal: '-',
                golesVisitante: '-',
                marcador: '-'
            };
        }

        return {
            ganador: data.ganador_predicho,
            golesLocal: data.goles_esperados_local,
            golesVisitante: data.goles_esperados_visitante,
            marcador: data.marcador_probable
        };

    } catch (error) {
        console.error('Error al generar predicción:', error);

        return {
            ganador: 'No disponible',
            golesLocal: '-',
            golesVisitante: '-',
            marcador: '-'
        };
    }
}

async function mostrarProximosPartidos(partidos) {
    const contenedor = document.getElementById('cards-proximos-partidos');
    contenedor.innerHTML = '';

    if (partidos.length === 0) {
        contenedor.innerHTML = `
            <p class="sin-proximos">
                No hay próximos partidos registrados.
            </p>
        `;
        return;
    }

    for (const partido of partidos) {
        const prediccion = await obtenerPrediccionPartido(partido);
        const fecha = new Date(partido.Fecha_Partido).toLocaleDateString('es-MX');

        const logoLocal = obtenerLogoEquipo(partido.Equipo_Local);
        const logoVisitante = obtenerLogoEquipo(partido.Equipo_Visitante);

        const card = document.createElement('div');
        card.classList.add('card-proximo-partido');

        card.innerHTML = `
            <div class="card-proximo-header">
                <span class="prediction-badge">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                    Prediction
                </span>

                <span class="fecha-proximo">
                    ${fecha}
                </span>
            </div>

            <div class="matchup-proximo">
                <div class="equipo-proximo">
                    <img src="${logoLocal}" alt="${partido.Equipo_Local}" class="logo-equipo-card">
                    <span>${partido.Equipo_Local}</span>
                    <strong>${prediccion.golesLocal}</strong>
                </div>

                <span class="vs-proximo">VS</span>

                <div class="equipo-proximo">
                    <img src="${logoVisitante}" alt="${partido.Equipo_Visitante}" class="logo-equipo-card">
                    <span>${partido.Equipo_Visitante}</span>
                    <strong>${prediccion.golesVisitante}</strong>
                </div>
            </div>

            <div class="ganador-proximo">
                <i class="fa-solid fa-trophy"></i>
                Ganador predicho: <strong>${prediccion.ganador}</strong>
            </div>

            <div class="marcador-proximo">
                Marcador probable: <strong>${prediccion.marcador}</strong>
            </div>
        `;

        contenedor.appendChild(card);
    }
}

function mostrarPartidos(data) {
    const tabla = document.getElementById('tabla-partidos');
    tabla.innerHTML = '';

    const partidos = data.partidos || [];

    document.getElementById('contador-resultados').textContent =
        `Resultados encontrados: ${data.total} partidos`;

    if (partidos.length === 0) {
        tabla.innerHTML = `
            <tr>
                <td colspan="5">No hay partidos para mostrar</td>
            </tr>
        `;
        return;
    }

    partidos.forEach(partido => {
        const fecha = new Date(partido.Fecha_Partido).toLocaleDateString('es-MX');

        const fila = document.createElement('tr');

        fila.innerHTML = `
            <td>${fecha}</td>

            <td>
                <span class="team-badge">
                    ${partido.Equipo_Local}
                </span>
            </td>

            <td>
                <strong style="color:#60a5fa;">
                    ${partido.Goles_Local ?? '-'}
                </strong>
            </td>

            <td>
                <strong style="color:#a855f7;">
                    ${partido.Goles_Visitante ?? '-'}
                </strong>
            </td>

            <td>
                <span class="team-badge">
                    ${partido.Equipo_Visitante}
                </span>
            </td>
        `;

        tabla.appendChild(fila);
    });

    document.getElementById('info-pagina').textContent =
        `Página ${data.pagina} de ${data.totalPaginas}`;

    document.getElementById('btn-anterior').disabled = data.pagina <= 1;
    document.getElementById('btn-siguiente').disabled = data.pagina >= data.totalPaginas;
}

document.getElementById('btn-buscar-fecha').addEventListener('click', () => {
    fechaSeleccionada = document.getElementById('filtro-fecha').value;
    paginaActual = 1;
    cargarPartidos();
});

document.getElementById('btn-limpiar-fecha').addEventListener('click', () => {
    document.getElementById('filtro-fecha').value = '';
    fechaSeleccionada = '';
    paginaActual = 1;
    cargarPartidos();
});

document.getElementById('btn-anterior').addEventListener('click', () => {
    if (paginaActual > 1) {
        paginaActual--;
        cargarPartidos();
    }
});

document.getElementById('btn-siguiente').addEventListener('click', () => {
    paginaActual++;
    cargarPartidos();
});

cargarProximosPartidos();
cargarPartidos();