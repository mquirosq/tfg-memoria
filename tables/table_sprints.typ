#set table(fill: (_, y) => if y == 0 { rgb("#f6e3a8") })
#show table.cell.where(y: 0): set text(weight: "bold")

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center + horizon, center + horizon, left + horizon),

    [Sprint], [Fechas], [Objetivo principal],

    [1], [25/11-02/12 2025], [Estudio previo del contexto biológico y definición del sistema],

    [2], [02/12-16/12 2025], [Diseño de arquitectura del sistema y definición del framework],

    [3], [16/12-13/01 2026], [Desarrollo de la infrastructura base (autenticación, base de datos, Docker, etc.)],

    [4], [13/01-27/01 2026], [Desarrollo del servicio de conversión de datos genómicos],

    [5], [27/01-10/02 2026], [Procesamiento y parseo de datos anotados y almacenamiento en base de datos],

    [6], [10/02-03/03 2026], [Desarrollo del módulo de predicción de resistencia mediante ML],

    [7], [03/03-17/03 2026], [Diseño e implementación de arquitectura modular para modelos de predicción],

    [8], [17/03-14/04 2026], [Desarrollo de la interfaz de usuario y sistema de notificaciones],

    [9], [14/04-21/04 2026], [Integración del sistema, pruebas y validación],

    [10], [21/04-12/05 2026], [Redacción de la memoria, ajustes finales y puesta en producción],
  ),
  caption: "Sprints del proyecto",
)<table:sprints>
