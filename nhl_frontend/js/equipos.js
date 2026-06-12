const API_URL = 'http://localhost:5001/api/equipos';

let equiposData = [];

async function cargarEquipos() {
    try {
        const respuesta = await fetch(API_URL);
        equiposData = await respuesta.json();

        mostrarEquipos(equiposData);

        const buscador = document.getElementById('buscarEquipo');

        buscador.addEventListener('input', () => {
            const texto = buscador.value.toLowerCase();

            const equiposFiltrados = equiposData.filter(equipo => {
                return (
                    equipo.Nombre_Equipo.toLowerCase().includes(texto) ||
                    equipo.Abreviacion.toLowerCase().includes(texto) ||
                    equipo.Ciudad.toLowerCase().includes(texto) ||
                    equipo.Nombre_Division.toLowerCase().includes(texto) ||
                    equipo.Nombre_Conferencia.toLowerCase().includes(texto) ||
                    equipo.Nombre_Arena.toLowerCase().includes(texto)
                );
            });

            mostrarEquipos(equiposFiltrados);
        });

    } catch (error) {
        console.error('Error al cargar equipos:', error);
    }
}

function mostrarEquipos(equipos) {
    const cards = document.getElementById('cards-equipos');
    const contador = document.getElementById('contadorEquipos');

    cards.innerHTML = '';

    contador.textContent = `${equipos.length} equipos encontrados`;

    equipos.forEach(equipo => {
        const logo = `img/${equipo.Abreviacion}.png`;

        const card = document.createElement('div');

        card.classList.add('team-card');

        card.innerHTML = `
            <img src="${logo}" alt="${equipo.Nombre_Equipo}" class="team-card-logo">

            <h3>${equipo.Nombre_Equipo}</h3>

            <span>${equipo.Abreviacion}</span>

            <p>
                <i class="fa-solid fa-location-dot"></i>
                ${equipo.Ciudad}
            </p>

            <p>
                <i class="fa-solid fa-layer-group"></i>
                ${equipo.Nombre_Division} / ${equipo.Nombre_Conferencia}
            </p>

            <p>
                <i class="fa-solid fa-building-columns"></i>
                ${equipo.Nombre_Arena}
            </p>
        `;

        cards.appendChild(card);
    });
}

cargarEquipos();