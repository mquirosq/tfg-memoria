// TODO: No está super bonito pero me vale por ahora

#let historia_usuario(id, rol, objetivo, beneficio) = context {
  let id = counter("historia").get().at(0) + 1
  block(
    inset: 10pt,
    stroke: gray + 1.25pt,
    fill: rgb("f2f2f2"),
    width: 100%,
    radius: 10pt,
    breakable: false,
  )[
    *HU-#id:*
    #v(-0.5em)
    #line(length: 100%, stroke: (paint: gray, dash: "dotted"))
    *Como* #rol \
    *Quiero* #objetivo \
    *Para* #beneficio.
  ]
  counter("historia").step()
}

#let enum_from_array(items) = {
  enum(..items.map(item => [#item.]))
}

#let list_from_array(items) = {
  list(..items.map(item => [#item.]))
}

#let caso_de_uso(id, nombre, precond, desc, flujo, postcond, exc) = {
  let color = rgb("f9f2ff")
  block(
    radius: 10pt,
    clip: true,
    stroke: color.darken(30%).saturate(20%) + 1.25pt,
    table(
      columns: (1fr, 3fr),
      inset: 6pt,
      stroke: color.darken(15%).saturate(10%) + 1pt,
      fill: color,
      table.header([*CU-#id*], [*#nombre*]),
      [*Precondición*], [#precond.],
      [*Descripción*], [#desc.],
      [*Flujo principal*], enum_from_array(flujo),
      [*Postcondición*], [#postcond.],
      [*Excepciones*], list_from_array(exc),
    ),
  )
}

#let requisito_funcional(id, descripcion) = {
  block(
    inset: 10pt,
    stroke: black,
    fill: rgb("e6f7ff"),
    width: 100%,
  )[
    *RF-#id:* #descripcion
  ]
}

#let requisito_no_funcional(id, descripcion) = {
  block(
    inset: 10pt,
    stroke: black,
    fill: rgb("fff2e6"),
    width: 100%,
  )[
    *RNF-#id:* #descripcion
  ]
}
