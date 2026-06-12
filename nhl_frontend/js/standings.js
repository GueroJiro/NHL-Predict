const API_URL = 'http://localhost:5001/api/standings';

let standingsGlobal = [];

async function cargarStandings() {
    try {
        const respuesta = await fetch(API_URL);
        standingsGlobal = await respuesta.json();

        mostrarStandings('2025-2026');

        const filtro = document.getElementById('filtro-temporada');

        filtro.addEventListener('change', () => {
            mostrarStandings(filtro.value);
        });

    } catch (error) {
        console.error('Error al cargar standings:', error);
    }
}

function mostrarStandings(temporadaSeleccionada) {
    const tabla = document.getElementById('tabla-standings');
    const contador = document.getElementById('contadorStandings');

    tabla.innerHTML = '';

    const standingsFiltrados = standingsGlobal
        .filter(equipo => equipo.Nombre_Temporada === temporadaSeleccionada)
        .sort((a, b) => b.Puntos - a.Puntos);

    contador.textContent = `${standingsFiltrados.length} equipos en standings`;

    standingsFiltrados.forEach((equipo, index) => {
        const fila = document.createElement('tr');
        const logo = `img/${equipo.Abreviacion}.png`;

        let posicionClase = '';

        if (index === 0) {
            posicionClase = 'rank-gold';
        } else if (index === 1) {
            posicionClase = 'rank-silver';
        } else if (index === 2) {
            posicionClase = 'rank-bronze';
        }

        fila.innerHTML = `
            <td>
                <span class="rank-badge ${posicionClase}">${index + 1}</span>
            </td>

            <td>
                <img src="${logo}" alt="${equipo.Nombre_Equipo}" class="team-table-logo">
            </td>

            <td>
                <strong>${equipo.Nombre_Equipo}</strong>
            </td>

            <td>${equipo.Partidos_Jugados}</td>
            <td>${equipo.Victorias}</td>
            <td>${equipo.Derrotas}</td>
            <td>${equipo.Derrotas_Overtime}</td>
            <td><span class="points-badge">${equipo.Puntos}</span></td>
            <td>${equipo.Goles_Favor}</td>
            <td>${equipo.Goles_Contra}</td>
            <td>${equipo.Diferencia_Goles}</td>
        `;

        tabla.appendChild(fila);
    });
}

cargarStandings();