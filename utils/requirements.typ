// TODO: No está super bonito pero me vale por ahora
#let zero-pad(n, width) = {
  let s = str(n)
  while s.len() < width { s = "0" + s }
  s
}

#let historia_usuario(rol, objetivo, beneficio) = context {
  let id = zero-pad(counter("historia").get().at(0) + 1, 3)
  let color = rgb("#e8f7fa")
  block(
    inset: 10pt,
    stroke: color.darken(30%).saturate(20%) + 1.25pt,
    fill: color,
    width: 100%,
    radius: 10pt,
    breakable: false,
  )[
    *HU-#id:*
    #v(-0.5em)
    #line(length: 100%, stroke: (paint: color.darken(30%).saturate(20%), dash: "dotted"))
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

#let caso_de_uso(nombre, precond, desc, flujo, postcond, exc) = context {
  let id = zero-pad(counter("caso_de_uso").get().at(0) + 1, 3)
  let color = rgb("#f9f2ff")
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
  counter("caso_de_uso").step()
}

#let requisito_informacion(name, descripcion, puntos) = context {
  let id = zero-pad(counter("requisito_informacion").get().at(0) + 1, 3)
  let color = rgb("#e6eeff")
  block(
    radius: 10pt,
    clip: true,
    inset: 10pt,
    stroke: color.darken(30%).saturate(20%) + 1.25pt,
    fill: color,
    width: 100%,
  )[
    *RI-#id:* *#name*
    #v(-0.5em)
    #line(length: 100%, stroke: (paint: color.darken(30%).saturate(20%), dash: "dotted"))
    #descripcion
    #list_from_array(puntos)
  ]
  counter("requisito_informacion").step()
}

#let requisito_funcional(descripcion) = context {
  let id = zero-pad(counter("requisito_funcional").get().at(0) + 1, 3)
  let color = rgb("#fff4e6")
  block(
    radius: 10pt,
    clip: true,
    inset: 10pt,
    stroke: color.darken(30%).saturate(20%) + 1.25pt,
    fill: color,
    width: 100%,
  )[
    *RF-#id:*
    #v(-0.5em)
    #line(length: 100%, stroke: (paint: color.darken(30%).saturate(20%), dash: "dotted"))
    #descripcion.
  ]
  counter("requisito_funcional").step()
}

#let requisito_no_funcional(descripcion) = context {
  let id = zero-pad(counter("requisito_no_funcional").get().at(0) + 1, 3)
  let color = rgb("#fff2e6")
  block(
    radius: 10pt,
    clip: true,
    inset: 10pt,
    stroke: color.darken(30%).saturate(20%) + 1.25pt,
    fill: color,
    width: 100%,
  )[
    *RNF-#id:*
    #v(-0.5em)
    #line(length: 100%, stroke: (paint: color.darken(30%).saturate(20%), dash: "dotted"))
    #descripcion.
  ]
  counter("requisito_no_funcional").step()
}
