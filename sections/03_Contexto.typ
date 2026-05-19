#import "../utils/todo.typ": todo

= Contexto
<sec:contexto>
== Introducción

En este capítulo se realiza una introducción al contexto biológico del proyecto, centrado en el procesamiento de datos genómicos y el uso de modelos predictivos para la predicción de resistencia a antibióticos. Este contexto es fundamental para comprender la relevancia del problema abordado y el vocabulario específico utilizado a lo largo de esta memoria.

== Procesamiento de datos genómicos

El proyecto se apoya en dos pilares fundamentales: el procesamiento y conversión de datos genómicos, y la aplicación de modelos predictivos. Esta sección se centra en el primero de ellos, proporcionando una visión general del flujo de análisis genómico.

Los microorganismos, como bacterias y virus, poseen material genético que contiene información sobre su biología y comportamiento. La secuenciación del ADN y su posterior análisis permiten identificar genes y mutaciones que pueden estar asociados a la resistencia a antibióticos.

Para llevar a este análisis, es necesario seguir un flujo de trabajo compuesto por varias etapas: secuenciación, ensamblaje y anotación (@fig:workflow). Este proceso transforma el ADN en datos crudos que posteriormente se convierten en información estructurada y biológicamente interpretable, que se puede utilizar en análisis más avanzados, como la predicción de resistencia a antibióticos.

#figure(
  image("/memoria/figures/workflow.svg", width: 100%),
  caption: "Flujo de trabajo típico en el análisis genómico",
)<fig:workflow>

Estos procesos son complejos y requieren herramientas especializadas, así como un elevado coste computacional. En las siguientes secciones se describen las etapas principales del análisis genómico: secuenciación, ensamblaje y anotación del genoma.

=== Secuenciación
La secuenciación del ADN es el proceso que consiste en determinar el orden de los nucleótidos (A, T, C y G) en una molécula de ADN, @fig:sequencing. En el caso de los microorganismos, esto implica la fragmentación del material genético en pequeñas secuencias denominadas _lecturas_, que representan observaciones parciales del genoma original.

La secuenciación se realiza introduciendo una muestra del microorganismo en máquinas especializadas que generan las lecturas. Existen distintas tecnologías de secuenciación, como Illumina u Oxford Nanopore Technologies (ONT), que se diferencian principalmente en la longitud de sus lecturas, la precisión y el coste. La elección de la tecnología depende de los objetivos del estudio, el presupuesto disponible y las características del microorganismo a analizar.

El framework aborado en este proyecto ha sido diseñado para ser compatible con dos de las tecnologías de secuenciado más extendidas, así como para la posible inclusión futura de forma sencilla de nuevas herramientas. Las principales características de las dos tecnologías abordadas en este proyecto son:
- *Illumina*: genera lecturas cortas con alta precisión. Habitualmente produce lecturas pareadas (paired-end), lo que mejora la calidad del ensamblaje.
- *ONT*: produce lecturas largas que facilitan la reconstrucción de regiones complejas del genoma, pero con una mayor tasa de error.

Los datos generados se almacenan habitualmente en formato FASTQ, el cual incluye tanto la secuencia de nucleótidos como una puntuación de calidad para cada base, que indica la confianza en la precisión de la lectura.

#figure(
  image("/memoria/figures/secuenciacion.svg", width: 100%),
  caption: "Resumen de flujo de secuenciación",
)<fig:sequencing>

=== Ensamblaje

El ensamblaje genómico, assembly en inglés, es el proceso mediante el cual se reconstruye la secuencia completa del genoma a partir de las lecturas obtenidas en la secuenciación (@fig:assembly). Este proceso es especialmente complejo debido a la naturaleza fragmentada de los datos y la presencia de errores en las lecturas.

Para llevar a cabo el ensamblaje, se utilizan algoritmos que buscan solapamientos entre las lecturas para construir secuencias más largas llamadas _contigs_. Los contigs representan fragmentos continuos del genoma y, en condiciones ideales, permiten reconstruirlo de forma completa.

Dependiendo de la tecnología de secuenciación utilizada, se emplean distintas herramientas de ensamblaje:
- Para lecturas cortas (como las generadas por Illumina), se emplean herramientas como _SPAdes_, optimizadas para manejar múltiples lecturas de alta precisión.
- Para lecturas largas (como las de ONT), se utilizan herramientas como _Raven_ o _Flye_, diseñadas para manejar secuencias más largas con mayores tasas de error.

Los resultados de este proceso se almacenan en formato FASTA, que contiene las secuencias ensambladas del genoma.

#figure(
  image("/memoria/figures/assembly.svg", width: 100%),
  caption: "Resumen de flujo de ensamblaje",
)<fig:assembly>

=== Anotación
Una vez obtenido el genoma ensamblado, se inicia el proceso de anotación, o annotation en inglés, cuyo objetivo es identificar elementos biológicos relevantes como genes, regiones codificantes y proteínas asociadas, @fig:annotation.

En este trabajo se utiliza la herramienta _Bakta_, ampliamente empleada en el ámbito de la genómica bacteriana. Bakta realiza la identificación de genes a partir de secuencias genómicas y asigna funciones biológicas mediante la comparación con bases de datos de referencia y modelos de anotación.

El resultado de este proceso es un conjunto de anotaciones estructuradas que describen la localización y función de los genes identificados dentro del genoma ensamblado.

En este proyecto, dicha información se exporta en formato JSON, lo que permite su procesamiento automatizado e integración con el sistema desarrollado, facilitando su uso en modelos predictivos.

#figure(
  image("/memoria/figures/annotation.svg", width: 100%),
  caption: "Resumen de flujo de anotación",
)<fig:annotation>

== Predicción de resistencia a antibióticos

El segundo pilar del proyecto es la aplicación de modelos de predicción en el ámbito de la resistencia a antibióticos. Este es un problema de gran relevancia en la
bioinformática, donde se busca inferir el fenotipo de resistencia a partir de características derivadas del genoma.

Estos modelos operan sobre representaciones obtenidas del análisis genómico, como la presencia de genes de resistencia, anotaciones funcionales u otras características derivadas del ensamblaje.

Sin embargo, el flujo completo de análisis genómico es largo y complejo. y los datos generados requieren un preprocesamiento y estructuración adecuados para ser utilizados como entrada en modelos predictivos. Esto dificulta su uso por parte de usuarios sin experiencia en bioinformática o programación, lo que limita su aplicabilidad en entornos clínicos o de investigación.

== Retos y necesidades
Actualmente, no existe una solución única que integre de forma unificada el flujo completo de procesamiento de datos genómicos, desde el ensamblaje hasta la anotación, de forma accesible para el usuario sin necesidad de utilizar la terminal o escribir código. Esto hace que el análisis genómico sea un proceso complejo y tedioso para usuarios sin experiencia en bioinformática.

Este proyecto aborda esta necesidad mediante el desarrollo de una herramienta que integra todo el flujo de análisis genómico, permitiendo a los usuarios realizar estas tareas de manera sencilla a través de una interfaz intuitiva.

Por otro lado, aunque existen modelos para la predicción de resistencia a antibióticos, no existe una forma sencilla de ofrecerlos a los usuarios ni integrarlos con el flujo de análisis genómico, limitando su aplicabilidad.

Este proyecto, propone una solución que integra el proceso completo de ensamblaje, anotación, preparación de datos y predicción de resistencia a antibióticos, proporcionando una única herramienta unificada y extensible. Esto se logra a través de un mecanismo sencillo para integrar modelos de predicción y una interfaz intuitiva que facilita su uso por parte de usuarios sin experiencia en programación, permitiendo así su aplicación en entornos clínicos o de investigación.

== Conclusiones

En este capítulo se ha presentado el contexto biológico necesario para comprender el problema abordado en este proyecto, describiendo el flujo de procesamiento de datos genómicos y las bases de los modelos de predicción aplicados al ámbito de la resistencia a antibióticos. Este contexto sirve como fundamento para el desarrollo del sistema propuesto, descrito en los siguiente capítulos.





