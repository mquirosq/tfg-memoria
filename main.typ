#import "@preview/deal-us-tfc-template:1.1.1": *

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

#include "sections/01_introduccion.typ"
#include "sections/02_Gestion.typ"
#include "sections/03_Contexto.typ"
#include "sections/04_Analisis.typ"
#include "sections/05_Diseño.typ"
#include "sections/06_Implementacion.typ"
#include "sections/07_Pruebas.typ"
#include "sections/XX_Conclusiones.typ"

// TODO: en colaboración con el hospital? o incluir alguna mención o algo
// Realizado en colaboración con el grupo de investigacion.... (Dani me va a mandar algo para esto)
//
// TODO: cambiar cabeceras de los estilos de las tablas (tan amarillos feos)
// TODO: Riesgos y análisis de mercado??? (riegos sí, manda dani, análisis de mercado va en la situación actual)
