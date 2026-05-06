#import "@preview/fancy-tiling:1.0.0": *

#let to-string(it) = {
  if type(it) == str {
    it
  } else if type(it) != content {
    str(it)
  } else if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(to-string).join()
  } else if it.has("body") {
    to-string(it.body)
  } else if it == [ ] {
    " "
  }
}

// Función similar al TODO de latex
#let todo(inline: false, body) = {
  counter("todo").step()
  let tiling-stroke = diagonal-stripes(
    mirror: true,
    angle: 45deg,
    thickness-ratio: 50%,
    background-color: black,
    stripe-color: yellow,
    size: 0.5cm,
  )
  let background = yellow.lighten(75%)
  let before = ""
  if body != none and body != [] {
    before = ": "
  }
  body = to-string(body)
  let capt = body.slice(0, calc.min(20, body.len()))
  show figure.where(kind: "todo"): it => {}
  box(width: 0pt, height: 0pt, figure(kind: "todo", supplement: none, gap: 0pt, caption: capt, none))
  if inline {
    box(scale(80%, [⚠️]))
    highlight(
      fill: background,
      stroke: 1pt + tiling-stroke,
      radius: 3pt,
      // Quitado negrita porque ahora mismo lo pone muh feo (aún más)
      [ TODO: #body],
    )
  } else {
    block(
      fill: background,
      stroke: 2pt + tiling-stroke,
      inset: 8pt,
      radius: 4pt,
      width: 100%,
      [⚠️ *TODO#before* #body],
    )
  }
}
