#import "@preview/deal-us-tfc-template:1.2.1": *
#import "utils/todo.typ": todo

#show: TFC.with(
  titulo: text(size: 18pt)[
    #par(justify: false)[
      COCOS: un framework para la democratización de modelos de predicción de resistencia bacteriana
    ]
  ],
  alumno: "María Quirós Quiroga",
  titulacion: "Grado en Ingeniería Informática - Ingeniería del Software",
  director: [Daniel Ayala Hernández \ Fernando Luis Sola Espinosa],
  departamento: "Lenguajes y Sistemas Informáticos",
  convocatoria: "Convocatoria de junio, curso 2025/26",
  dedicatoria: "A mí, por haber llegado hasta aquí y por todo lo que queda por venir.",
  agradecimientos: [
    Quiero agradecer a mi familia por estar ahí siempre y apoyarme en cada paso de este camino, por su paciencia y por escucharme incluso cuando probablemente no entendían demasiado de lo que estaba hablando. Y especialmente a mi hermano, por aportar su creatividad diseñando el logo del proyecto.

    A mis amigos, por acompañarme durante esta etapa, por entender mis momentos de estrés y bloqueo, y por recordarme la importancia de descansar y desconectar de vez en cuando. Gracias por estar presentes tanto en los días buenos como en los complicados, y por hacer este camino mucho más llevadero de lo que habría sido sin vosotros.

    También quiero agradecer a mis tutores, Dani y Fernando, por estar siempre dispuestos a ayudar y empujarme a dar lo mejor de mí, y al grupo DEAL por hacerme sentir parte del equipo desde el primer momento y por el ambiente de aprendizaje y apoyo durante estos años. Especialmente, por haberme brindado la oportunidad de trabajar en un proyecto de investigación real y aprender de profesionales de ámbitos tan distintos como la ingeniería del software y la microbiología.

    Este trabajo representa el final de una etapa, pero también el comienzo de todo lo que está por venir.
  ],
  resumen: [
    La resistencia a los antibióticos constituye uno de los principales desafíos actuales para la salud pública mundial, impulsando la búsqueda de nuevas estrategias que permitan acelerar y mejorar los procesos de diagnóstico y facilitar la toma de decisiones clínicas. En este contexto, la secuenciación genómica y los modelos de predicción basados en aprendizaje automático han emergido como herramientas prometedoras para inferir la resistencia antimicrobiana a partir de datos genéticos.

    Sin embargo, existe una barrera entre el desarrollo de estas herramientas y su aplicación práctica, debido a la complejidad técnica de los pipelines bioinformáticos, la integración con herramientas heterogéneas y la falta de interfaces accesibles para usuarios no técnicos.

    Este Trabajo de Fin de Grado presenta COCOS, un framework extensible diseñado para democratizar el acceso a modelos de predicción de resistencia a antibióticos y simplificar tanto la ejecución del pipeline de análisis genómico como la integración de nuevos modelos predictivos. COCOS permite ejecutar procesos de ensamblaje y anotación genómica, gestionar resultados y aplicar modelos predictivos sobre las características extraídas, todo ello a través de una interfaz intuitiva y con soporte para la incorporación de nuevos modelos mediante una arquitectura modular.

    La solución propuesta se compone de dos subsistemas desacoplados: un sistema web encargado de la gestión de usuarios, procesos y predicciones; y un subsistema bioinformático responsable de la ejecución de herramientas especializadas para el análisis genómico. Además, se incorpora ejecución asíncrona y soporte para notificaciones. El sistema fue validado mediante pruebas funcionales y automatizadas sobre los distintos módulos implementados.

    El resultado es una plataforma flexible y extensible que contribuye a reducir la complejidad técnica asociada al uso de modelos predictivos en bioinformática y facilita su integración dentro de flujos de análisis genómico completos, reduciendo la barrera existente entre investigación y aplicación práctica.
  ],
  palabras-clave: (
    "bioinformática",
    "análisis genómico",
    "resistencia antimicrobiana",
    "aprendizaje automático",
    "modelos predictivos",
    "framework extensible",
  ),
  abstract: [
    Antibiotic resistance constitutes one of the major current challenges in global public health, driving the search for new strategies to accelerate and improve diagnostic processes and support clinical decision-making. In this context, genomic sequencing and machine learning-based predictive models have emerged as promising tools for inferring antimicrobial resistance from genetic data.

    However, there is still a significant gap between the development of these tools and their practical application, mainly due to the technical complexity of bioinformatics pipelines, the integration of heterogeneous tools, and the lack of accessible interfaces for non-technical users.

    This Bachelor's Thesis presents COCOS, an extensible framework designed to democratize access to antibiotic resistance prediction models and simplify both the execution of genomic analysis pipelines and the integration of new predictive models. COCOS enables the execution of genome assembly and annotation processes, the management of biological results, and the application of predictive models over extracted features, all through an intuitive interface and with support for the incorporation of new models through a modular architecture.

    The proposed solution is composed of two decoupled subsystems: a web system responsible for user, process, and prediction management; and a bioinformatics subsystem responsible for executing specialized genomic analysis tools. In addition, the system incorporates asynchronous task execution and notification support. The platform was validated through both functional and automated testing of the implemented modules.

    The result is a flexible and extensible platform that helps reduce the technical complexity associated with the use of predictive models in bioinformatics and facilitates their integration into complete genomic analysis workflows, reducing the gap between research and practical application.
  ],
  keywords: (
    "bioinformatics",
    "genomic analysis",
    "antimicrobial resistance",
    "machine learning",
    "predictive models",
    "extensible framework",
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

#show heading.where(level: 3): set heading(outlined: false)
#show heading.where(level: 3, outlined: true): it => {
  set text(size: 14pt)
  block(above: 2em, below: 1em)[
    #counter(heading).display();
    #h(0.5em)
    #it.body
  ]
}

#show raw.where(block: false): it => {
  highlight(it, fill: gray.lighten(80%), top-edge: 1em, bottom-edge: -0.3em, radius: 1mm, extent: 0.25mm)
}


#include "sections/01_introduccion.typ"
#include "sections/02_Gestion.typ"
#include "sections/03_Contexto.typ"
#include "sections/04_Analisis.typ"
#include "sections/05_Diseño.typ"
#include "sections/06_Implementacion.typ"
#include "sections/07_Conclusiones.typ"
