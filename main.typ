#import "@preview/deal-us-tfc-template:1.2.1": *
#import "utils/todo.typ": todo

#show: TFC.with(
  titulo: "Trabajo fin de grado",
  alumno: "María Quirós Quiroga",
  titulacion: "Grado en Ingeniería Informática - Ingeniería del Software",
  director: [Director 1 \ Director 2],
  departamento: "Lenguajes y Sistemas Informáticos",
  convocatoria: "Convocatoria de junio/julio/diciembre, curso 20XX/YY",
  dedicatoria: "Aquí la dedicatoria del trabajo",
  agradecimientos: [
    Quiero agradecer a X por...

    También quiero agradecer a Y por...
  ],
  resumen: [
    Incluya aquí un resumen de los aspectos generales de su trabajo, en español
  ],
  palabras-clave: (
    "palabra clave 1",
    "palabra clave 2",
    "...",
    "palabra clave N",
  ),
  abstract: [
    This section should contain an English version of the Spanish abstract.
  ],
  keywords: (
    "keyword 1",
    "keyword 2",
    "...",
    "keyword N",
  ),
  bibliografia: bibliography("/memoria/bibliografia.bib"),
)
#outline(target: figure.where(kind: "todo"))

#show ref: it => {
  let el = it.element
  if (el != none and el.func() == heading) {
    if (el.level == 1) {
      let num = counter(heading).at(el.location()).at(0)
      link(el.location(), [Capítulo #num])
    } else {
      it
    }
  } else {
    it
  }
}

#show heading.where(level: 3): set heading(outlined: false)
#show heading.where(level: 3, outlined: true): it => {
  set text(size: 14pt)
  block(above: 2em, below: 1em)[
    #counter(heading).display();
    #h(0.5em)
    #it.body
  ]
}

#include "sections/01_introduccion.typ"
#include "sections/02_Gestion.typ"
#include "sections/03_Contexto.typ"
#include "sections/04_Analisis.typ"
#include "sections/05_Diseño.typ"
#include "sections/06_Implementacion.typ"
#include "sections/XX_Conclusiones.typ"
