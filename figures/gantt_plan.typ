#import "@preview/timeliney:0.4.0"

// ── Color palette ──────────────────────────────────────────────────────────────
#let c-general = rgb("#6c757d")  // grey
#let c-backend = rgb("#2979ff") // blue
#let c-bio = rgb("#43a047") // green
#let c-ml = rgb("#ab47bc") // purple
#let c-ui = rgb("#ff7043") // orange

// Estilos
#let bar(color) = (
  stroke: stroke(paint: color, thickness: 6pt, cap: "butt"),
)
#let group-bar(color) = (
  stroke: stroke(paint: color.darken(40%), thickness: 8pt, cap: "butt"),
)

// Milestones
#let ms-style = (
  stroke: stroke(paint: rgb("#e53935"), thickness: 1.5pt, dash: "dashed"),
)

// Legend
#let legend = {
  let dot(color, label) = {
    box(width: 10pt, height: 10pt, fill: color, radius: 2pt)
    h(4pt)
    text(size: 8pt, label)
    h(12pt)
  }
  align(right, box(
    stroke: 0.5pt + luma(180),
    radius: 4pt,
    inset: 6pt,
    {
      dot(c-general, "General")
      dot(c-backend, "Backend")
      dot(c-bio, "Bioinformática")
      dot(c-ml, "Modelos predictivos")
      dot(c-ui, "UI")
    },
  ))
}

// Gráfico
// 1 unit = 1 day; 168 days total (25 Nov 2025 → 12 May 2026)
#figure(
  {
    legend
    timeliney.timeline(
      spacing: 4pt,
      show-grid: false,
      {
        import timeliney: *

        headerline(
          group(([], 6)),
          group(([*Dic*], 31)),
          group(([*Ene*], 31)),
          group(([*Feb*], 28)),
          group(([*Mar*], 31)),
          group(([*Abr*], 30)),
          group(([*May*], 20)),
        )

        // S1 – Estudio previo
        taskgroup(
          title: [*S1 – Estudio previo*],
          style: group-bar(c-general),
          {
            task("Contexto", (from: 0, to: 4), style: bar(c-general))
            task("Planificación", (from: 4, to: 7), style: bar(c-general))
          },
        )

        // S2 – Diseño
        taskgroup(
          title: [*S2 – Diseño*],
          style: group-bar(c-backend),
          {
            task("Diseño de arquitectura", (from: 7, to: 15), style: bar(c-backend))
            task("Modelo de datos", (from: 15, to: 21), style: bar(c-backend))
          },
        )

        // S3 – Infraestructura
        taskgroup(
          title: [*S3 – Infraestructura*],
          style: group-bar(c-backend),
          {
            task("Docker y despliegue", (from: 21, to: 41), style: bar(c-backend))
            task("Autenticación", (from: 41, to: 49), style: bar(c-backend))
          },
        )

        // S4 – Conversión
        taskgroup(
          title: [*S4 – Pipeline genómico*],
          style: group-bar(c-bio),
          {
            task("Integración ensamblaje", (from: 49, to: 56), style: bar(c-bio))
            task("Integración de anotación", (from: 56, to: 63), style: bar(c-bio))
          },
        )

        // S5 – Parseo y persistencia
        taskgroup(
          title: [*S5 – Parseo y persistencia*],
          style: group-bar(c-bio),
          {
            task("Parseo de resultados", (from: 63, to: 70), style: bar(c-bio))
            task("Persistencia en BD", (from: 70, to: 77), style: bar(c-bio))
          },
        )

        // S6 – Predicción
        taskgroup(
          title: [*S6 – Predicción*],
          style: group-bar(c-ml),
          {
            task("Pipeline de predicción", (from: 77, to: 91), style: bar(c-ml))
            task("Integración modelo", (from: 91, to: 98), style: bar(c-ml))
          },
        )

        // S7 – Modelos y framework
        taskgroup(
          title: [*S7 – Modelos y framework*],
          style: group-bar(c-ml),
          {
            task("Arquitectura de modelos", (from: 98, to: 105), style: bar(c-ml))
            task("Registro automático de modelos", (from: 105, to: 112), style: bar(c-ml))
          },
        )

        // S8 – Interfaz
        taskgroup(
          title: [*S8 – Interfaz*],
          style: group-bar(c-ui),
          {
            task("Pantallas de conversión", (from: 112, to: 126), style: bar(c-ui))
            task("Notificaciones y seguimiento", (from: 126, to: 133), style: bar(c-ui))
            task("Pantalla de predicción", (from: 133, to: 140), style: bar(c-ui))
          },
        )

        // S9 – Integración
        taskgroup(
          title: [*S9 – Integración*],
          style: group-bar(c-general),
          {
            task("Integración del sistema", (from: 140, to: 143), style: bar(c-general))
            task("Testing y validación", (from: 143, to: 147), style: bar(c-general))
          },
        )

        // S10 – Cierre
        taskgroup(
          title: [*S10 – Cierre*],
          style: group-bar(c-general),
          {
            task("Redacción memoria", (from: 147, to: 164), style: bar(c-general))
            task("Despliegue final", (from: 164, to: 168), style: bar(c-general))
          },
        )

        // Milestones
        milestone(at: 49, style: ms-style, [Sistema\ base])
        milestone(at: 77, style: ms-style, [Pipeline genómico])
        milestone(at: 112, style: ms-style, [Predicción])
        milestone(at: 140, style: ms-style, [UI])
        milestone(at: 168, style: ms-style, [Fin])
      },
    )
  },
  caption: "Diagrama de Gantt del proyecto",
) <fig:gantt_plan>
