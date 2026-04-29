#set table(fill: (_, y) => if y == 0 { rgb("#f6e3a8") })
#show table.cell.where(y: 0): set text(weight: "bold")

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center + horizon, center + horizon, center + horizon),

    [Sprint], [Dedicación estimada (Hrs.)], [Dedicación real (Hrs.)],

    [1], [15h], [14h],

    [2], [25h], [20h],

    [3], [35h], [42h],

    [4], [45h], [48h],

    [5], [30h], [28h],

    [6], [30h], [35h],

    [7], [25h], [21h],

    [8], [50h], [62h],

    [9], [15h], [14h],

    [10], [40h], [45h],

    [*Total*], [*310h*], [*329h*],
  ),
  caption: "Tiempo estimado y real de los Sprints del proyecto",
)<table:time>
