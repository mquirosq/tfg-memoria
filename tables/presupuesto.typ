#set table(fill: (_, y) => if y == 0 { rgb("#f6e3a8") })
#show table.cell.where(y: 0): set text(weight: "bold")

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center + horizon, center + horizon, right + horizon),

    [Partida], [Cálculo], table.cell(align: center)[Total],

    [Coste de personal], [25,85 €/h x 310 horas], [8013,50 €],

    [Amortización de equipo], [1200 €/72 meses x 6 meses de proyecto], [100 €],

    [Suministro eléctrico], [0,20 €/kWh x 200 W x 310h], [12,40 €],

    [Conexión a Internet], [50 €/mes x 6 meses], [300 €],

    [], [*Total parcial*], [*8425,90 €*],

    [], [*Reserva (10%)*], [*842,59 €*],

    [], [*Total*], [*9268,49 €*],
  ),
  caption: "Costes estimados del proyecto",
)<table:presupuesto>
