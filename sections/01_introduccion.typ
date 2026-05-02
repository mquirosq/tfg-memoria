= Introducción
<sec:introduccion>

La resistencia bacteriana a los antibióticos constituye uno de los mayores retos actuales para la salud pública a nivel mundial. Este fenómeno amenaza con revertir décadas de avances médicos, haciendo que infecciones y enfermedades comunes, hoy en día tratables de forma sencilla, vuelvan a ser potencialmente mortales. En la actualidad, se estima que causa más de 1,14 millones de muertes anuales, y se espera que esta cifra supere los 8 millones en 2050, situándose entre las principales causas de mortalidad, por delante de enfermedades como el cáncer.

La resistencia a los antibióticos surge cuando las bacterias evolucionan en respuesta a la presión ejercida por el uso, en muchos casos indebido, de estos fármacos. Este proceso favorece la aparición y propagación de microorganismos con mecanismos de resistencia, lo que reduce la eficacia de los tratamientos disponibles y da lugar a infecciones más difíciles de tratar. A pesar de la magnitud de este problema, el desarrollo de nuevos antibióticos se ha ralentizado significativamente en las últimas décadas, debido tanto a los elevados costes como a la complejidad asociada a su investigación. Como consecuencia, las bacterias resistentes continúan aumentando rápidamente, mientras que el número de nuevos antibióticos disponibles para combatirlas ha permanecido estancado.

En este contexto, las pruebas de sensibilidad antimicrobiana (antimicrobial susceptibility testing, AST) desempeñan un papel fundamental. Estas técnicas permiten determinar si un microorganismo es sensible o resistente a distintos antibióticos, orientando así la elección del tratamiento más adecuado. Tradicionalmente, los métodos de AST se basan en el aislamiento del microorganismo, su cultivo en laboratorio y su exposición a diferentes agentes antimicrobianos para evaluar su crecimiento o inhibición. Sin embargo, estos procedimientos presentan una limitación crucial: la necesidad de cultivo implica tiempos prolongados, oscilando entre varios días o incluso semanas. Este retraso en la obtención de resultados condiciona la toma de decisiones clínicas y puede demorar el inicio del tratamiento adecuado para el paciente, lo cual resulta especialmente crítico en casos de infecciones graves.

Ante estas limitaciones, la secuenciación del genoma completo, combinada con técnicas de predicción, ha emergido como una alternativa complementaria prometedora. Este enfoque permite analizar directamente la información genética del microorganismo para identificar patrones asociados a resistencia, reduciendo significativamente los tiempos de diagnóstico y facilitando una aproximación más rápida y eficaz al tratamiento.

No obstante, el desarrollo e implementación de este tipo de sistemas plantea desafíos significativos. En primer lugar, requiere la integración de múltiples disciplinas, como la biología molecular, la informática y el aprendizaje automático. Además, es necesario abordar la transformación de datos genómicos complejos en representaciones adecuadas para su procesamiento y análisis computacional. A esto se suma la necesidad de diseñar, entrenar y validar modelos de predicción robustos, capaces de generalizar correctamente ante nuevos datos y ofrecer resultados fiables y relevantes.

Por otro lado, la utilidad real de estos modelos y herramientas predictivas depende en gran medida de su integración efectiva en el entorno clínico. Esto implica no solo ofrecer predicciones precisas, sino también desarrollar interfaces accesibles e intuitivas que facilitan su uso por parte de los profesionales sanitarios, quienes no necesariamente cuentan con formación técnica en informática o análisis de datos.

En este proyecto, se aborda este reto mediante el desarrollo de una herramienta de apoyo a la toma de decisiones clínicas, que permite predecir la resistencia a los antibióticos de un microorganismo a partir de su secuencia genómica. Concretamente, se propone el desarrollo de un framework flexible y extensible que integra tanto el procesamiento de datos genómicos como la aplicación de modelos predictivos.

Por un lado, el sistema proporciona funcionalidades orientadas a la gestión y transformación de datos biológicos, permitiendo la conversión entre distintos formatos de archivos ampliamente utilizados en genómica, como FASTQ, FASTA y anotaciones generadas mediante la herramienta Bakta. Estas utilidades facilitan etapas fundamentales del flujo de trabajo, como son el ensamblaje y la anotación del genoma, simplificando procesos que habitual requieren el uso de múltiples herramientas independientes y conocimientos técnicos especializados.

Por otro lado, el framework ofrece una infraestructura flexible diseñada para la integración y despliegue de modelos predictivos orientados a la resistencia a antibióticos. En particular, se busca reducir la complejidad asociada a la incorporación de nuevos modelos, permitiendo que estos puedan añadirse de forma sencilla al sistema mediante una interfaz. Asimismo, se ofrece una interfaz de predicción que permite a los usuarios del ámbito de la salud acceder a las predicciones de resistencia de forma sencilla e incorpora los nuevos modelos automáticamente, de modo que estos quedan disponibles para su uso dentro de la plataforma sin necesidad de desarrollar componentes adicionales.

En definitiva, este proyecto no se limita al desarrollo de una solución específica, sino que propone una herramienta reutilizable y extensible que facilita la integración de nuevos modelos predictivos en el flujo de trabajo clínico. De este modo, contribuye a reducir la brecha existente entre el desarrollo de modelos de predicción y su aplicación efectiva en la práctica clínica.

Este documento se compone de siete capítulos, en los cuales se profundiza en distintos aspectos del proyecto llevado a cabo durante el desarrollo de este trabajo de fin de grado.

En primer lugar, @sec:planificación se centra en el estudio previo al proyecto, en el que se exponen aspectos como los objetivos del proyecto, la metodología seguida y la planificación temporal y presupuestaria del mismo.

La @sec:contexto describe el contexto en el que se enmarca este proyecto, incluyendo una descripción del proceso de análisis genómico y la predicción de resistencia a antibióticos, así como una revisión de los retos y necesidades actuales en este ámbito.

La @sec:análisis se dedica al análisis del problema y el contexto del mismo, así como a la descripción de los requisitos funcionales y no funcionales que se han identificado para el proyecto.

La @sec:diseño se centra en el diseño de la solución propuesta, incluyendo la arquitectura del sistema, los diagramas de clases, prototipos de interfaz y otros aspectos relevantes del diseño.

La @sec:implementación se dedica a la descripción de la implementación de la solución propuesta, describiendo las tecnologías utilizadas, la estructura del código y los aspectos más relevantes de la implementación.

La @sec:pruebas se centra en la descripción de las pruebas realizadas para validar la solución propuesta.

Finalmente, la @sec:conclusiones recoge las conclusiones obtenidas a lo largo del desarrollo del proyecto, así como las posibles líneas de trabajo futuro que se podrían seguir a partir de este trabajo de fin de grado.
