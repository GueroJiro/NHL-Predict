const API_PREDICCIONES = 'http://localhost:5001/api/predicciones/generar';
const API_EQUIPOS = 'http://localhost:5001/api/equipos';

document.addEventListener('DOMContentLoaded', cargarEquipos);

document
    .getElementById('btnPredecir')
    .addEventListener('click', generarPrediccion);

async function cargarEquipos() {
    try {
        const respuesta = await fetch(API_EQUIPOS);
        const equipos = await respuesta.json();

        const selectLocal = document.getElementById('equipoLocal');
        const selectVisitante = document.getElementById('equipoVisitante');

        selectLocal.innerHTML = '';
        selectVisitante.innerHTML = '';

        equipos.forEach(equipo => {
            const opcionLocal = document.createElement('option');
            opcionLocal.value = equipo.Abreviacion;
            opcionLocal.textContent = equipo.Nombre_Equipo;

            const opcionVisitante = document.createElement('option');
            opcionVisitante.value = equipo.Abreviacion;
            opcionVisitante.textContent = equipo.Nombre_Equipo;

            selectLocal.appendChild(opcionLocal);
            selectVisitante.appendChild(opcionVisitante);
        });

        if (selectVisitante.options.length > 1) {
            selectVisitante.selectedIndex = 1;
        }

    } catch (error) {
        console.error('Error al cargar equipos:', error);
    }
}

async function generarPrediccion() {
    const equipoLocal = document.getElementById('equipoLocal').value;
    const equipoVisitante = document.getElementById('equipoVisitante').value;

    if (equipoLocal === equipoVisitante) {
        alert('Selecciona equipos diferentes');
        return;
    }

    try {
        const respuesta = await fetch(API_PREDICCIONES, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                equipoLocal,
                equipoVisitante
            })
        });

        const data = await respuesta.json();

        if (!respuesta.ok) {
            alert(data.mensaje || 'Error al generar predicción');
            return;
        }

        const logoGanador =
            data.ganador_predicho === data.equipo_local
                ? equipoLocal
                : equipoVisitante;

        const probLocal = Number(data.probabilidad_local);
        const probVisitante = Number(data.probabilidad_visitante);

        document.getElementById('resultado-prediccion').innerHTML = `
            <div class="resultado-prediccion">

                <div class="prediccion-header">
                    <h2>Resultado de la Predicción</h2>
                    <p>
                        🏒 ${data.equipo_local}
                        <strong>vs</strong>
                        ${data.equipo_visitante} 🏒
                    </p>
                </div>

                <div class="ganador-card">
    <div class="ganador-content">

        <img
            src="img/${logoGanador}.png"
            alt="${data.ganador_predicho}"
            class="logo-ganador"
        >

        <span class="ganador-label">
            <i class="fa-solid fa-trophy"></i>
            Ganador Predicho
        </span>

        <h1>${data.ganador_predicho}</h1>
        <p>${data.mensaje}</p>

    </div>
</div>

                <div class="prediction-prob-card">

                    <div class="prob-team">
                        <span>${data.equipo_local}</span>
                        <strong>${data.probabilidad_local}%</strong>
                    </div>

                    <div class="prediction-bar">
                        <div class="prediction-bar-local" style="width:${probLocal}%"></div>
                        <div class="prediction-bar-visitante" style="width:${probVisitante}%"></div>
                    </div>

                    <div class="prob-team">
                        <span>${data.equipo_visitante}</span>
                        <strong>${data.probabilidad_visitante}%</strong>
                    </div>

                </div>

                <div class="prediccion-grid">

                    <div class="prediction-stat-card">
                        <span>Goles Esperados Local</span>
                        <h3>${data.goles_esperados_local}</h3>
                        <p>${data.equipo_local}</p>
                    </div>

                    <div class="prediction-stat-card">
                        <span>Goles Esperados Visitante</span>
                        <h3>${data.goles_esperados_visitante}</h3>
                        <p>${data.equipo_visitante}</p>
                    </div>

                    <div class="prediction-stat-card">
                        <span>Tiros Esperados Local</span>
                        <h3>${data.tiros_esperados_local}</h3>
                        <p>${data.equipo_local}</p>
                    </div>

                    <div class="prediction-stat-card">
                        <span>Tiros Esperados Visitante</span>
                        <h3>${data.tiros_esperados_visitante}</h3>
                        <p>${data.equipo_visitante}</p>
                    </div>

                    <div class="prediction-stat-card">
                        <span>Diferencia de Probabilidad</span>
                        <h3>${data.diferencia_probabilidad}%</h3>
                        <p>Ventaja estimada</p>
                    </div>

                    <div class="prediction-stat-card">
                        <span>Total de Tiros Esperados</span>
                        <h3>${data.total_tiros_esperados}</h3>
                        <p>Ambos equipos</p>
                    </div>

                </div>

                <div class="marcador-card">
                    <span>
                        <i class="fa-solid fa-chart-line"></i>
                        Marcador Probable
                    </span>

                    <h2>${data.marcador_probable}</h2>

                    <p>
                        Predicción generada con estadísticas históricas,
                        puntos, victorias, goles y rendimiento ofensivo.
                    </p>
                </div>

            </div>
        `;

    } catch (error) {
        console.error(error);
        alert('Error al generar predicción');
    }
}