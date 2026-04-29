#set table(fill: (_, y) => if y == 0 { rgb("#f6e3a8") })
#show table.cell.where(y: 0): set text(weight: "bold")

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center + horizon, center + horizon, center + horizon),

    [Partida], [Cálculo], [Total],

    [Coste de personal], [25,85 €/h x 329 horas], [8504,65 €],

    [Amortización de equipo], [1200 €/72 meses x 6 meses de proyecto], [100 €],

    [Suministro eléctrico], [0,20 €/kWh x 200 W x 329h], [13,16 €],

    [Conexión a Internet], [50 €/mes x 6 meses], [300 €],

    [], [*Gastos finales*], [*8917,81 €*],

    [], [*Total previsto (con reserva)*], [*9268,49 €*],

    [], [*Superávit en costes*], [*350,68 €*],
  ),
  caption: "Costes reales del proyecto",
)<table:costes_reales>
