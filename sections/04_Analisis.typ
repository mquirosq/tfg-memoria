#import "../utils/requirements.typ": caso_de_uso, historia_usuario, requisito_funcional, requisito_no_funcional

= Análisis del problema
<sec:análisis>

== Introducción

En este capítulo se realiza un análisis detallado del problema a abordar, identificando las limitaciones del enfoque actual en el análisis genómico y la predicción de resistencia a antibióticos, así como las necesidades de los usuarios finales. A partir de este análisis, se extraen los requisitos generales del sistema y se presentan las historias de usuario que guiarán el diseño y desarrollo de la solución propuesta. Tras esto, se presenta un diseño conceptual de la solución que responde a las necesidades identificadas y se establece un catálogo de requisitos que servirá como base para la implementación del sistema.

== Situación actual

=== Flujo actual de análisis genómico
En la práctica, el análisis genómico sigue un flujo de trabajo secuencial que transforma los datos obtenidos mediante secuenciación en información biológica interpretable. Desde una perspectiva aplicada, podemos entender este flujo como una pipeline de procesamiento de datos compuesto por herramientas independientes, cada una encargada de una etapa del análisis, que se encadenan para realizar el flujo completo.

Este proceso consta de tres etapas principales: ensamblaje del genoma, anotación y análisis de los resultados. Dependiendo del caso de uso, pueden incluirse etapas adicionales como el control de calidad de las lecturas o el alineamiento contra un genoma de referencia.

En la práctica, los usuarios parten de archivos de lecturas en formato FASTQ, aplican herramientas de ensamblaje para generar contigs en formato FASTA y, posteriormente, utilizan herramientas de anotación para identificar genes y asignar funciones biológicas. Cada fase opera sobre formatos de datos específicos, lo que requiere una gestión de los datos intermedios y la correcta aplicación de cada herramienta en el orden adecuado.

Estas herramientas se utilizan habitualmente en entornos Linux mediante línea de comandos, lo que proporciona flexibilidad pero introduce una barrera para usuarios sin experiencia en informática, como es el caso en muchos contextos clínicos. Algunos ejemplos de herramientas comunmente utilizadas son:
- Para el ensamblaje: _SPAdes_, _Velvet_, _Raven_ o _Flye_.
- Para la anotación: _Bakta_, _Prokka_ o _RAST_.

Aunque estas herramientas son ampliamente utilizadas en la comunidad científica, su uso requiere conocimientos técnicos tanto para su instalación y configuración como para su ejecución. Además, la gestión manual de los datos intermedios y la necesiadad de asegurar la compatibilidad entre las herramientas utilizadas incrementan el riesgo de errores y llevan a frustración, dificultando su adopción generalizada.

//```shell
//bakta nosequé sdasd
//```

// TODO: Maybe incluir un ejemplo de comando para cada etapa, o una captura de pantalla de la terminal con el proceso

// TODO: incluir una pipeline de ejemplo con las herramientas más comunes, aunque sea a modo de ejemplo o algo así

Con el objetivo de reducir esta barrera de entrada, han surgido plataformas que  ofrecen interfaces gráficas más accesibles para la ejecución de estos flujos de trabajo. Entre ellas destacan _Galaxy_ y _Geneious_.

_Galaxy_ es una plataforma de código abierto basada en un entorno webque permite ejecutar herramientas de análisis bioinformático, gestionar datos y construir flujos de trabajo reproducibles. Su principal ventaja es la centralización de herramientas heterogéneas bajo una única interfaz, ofreciendo gran variedad de herramientas con usos distintos para cada fase. Sin embargo, el usuarios debe seleccionar manualmente cada herramienta, su orden de ejecución y configurar sus parámetros, lo que puede resultar complejo para usuarios sin experiencia técnica. Además, la amplia variedad de herramientas disponibles dificulta la selección de las más adecuadas para cada uso y la búsqueda de herramientas específicas puede resultar complicada.

Por otro lado, Geneious es una plataforma comercial de pago con interfaz gráfica que integra diversas herramientas de análisis de secuencias en entorno unificado. Su principal ventaja es la simplificación el flujo de trabajo, eliminando la necesidad de gestionar herramientas indepdendientes y sus datos intermedios. Esto reduce la curva de aprendizaje, no obatante, implica limitaciones en términos de flexibilidad y personalización, ya que los usuarios no pueden elegir libremente las herramientas a utilizar ni configurar sus parámetros de forma detallada. Adicionalmente, su enfoque más orientado al diseño molecular y análisis de secuencias limita su aplicabilidad en análisis genómico completo, lo que puede ser una barrera para usuarios con necesidades más específicas o avanzadas.

En conclusión, las soluciones actuales proporcionan distintos niveles de abstracción sobre el flujo del análisis genómico. Mientras que plataformas como Galaxy ofrecen una amplia variedad de herramientas con gran flexibilidad, su complejidad técnica puede dificultar su adopción por parte de usuarios sin experiencia. Por otro lado, soluciones como Geneious simplifican el proceso pero a costa de limitar la personalización y la aplicabilidad en análisis genómico completo. Estas limitaciones resaltan que la brecha entre las herramientas de análisis genómico y los usuarios finales, especialmente en contextos clínicos, sigue siendo un desafío importante a abordar.

// TODO: Anañdir capturas

=== Predicción de resistencia a antibióticos
Existen diversos enfoques computacionales para la predicción de resistencia a antibióticos a partir de datos genómicos, que incluyen tanto modelos basados en aprendizaje automático o métodos basados en alineamiento contra bases de datos de genes de resistencia, como muchos otros enfoques. Entre los primeros se encuentran herramientas como _DeepARG_, basadas en redes neuronales, mientras que otras herramientas como _ResFinder_ se apoyan en estrategias de búqueda por homología frente a bases de datos curadas de datos de resistencia.

// TODO: modelo de bicho concreto

Estos enfoques han demostrado ser efectivos para inferir la resistencia a antibióticos a partir de representaciones derivadas del análisis genómico, como la presencia o ausencia de genes específicos o funciones biológicas obtenidas tras la anotación de la secuencia. En este sentido, podemos considerarlas como parte del análisis final dentro del flujo de análisis genómico, que utiliza los resultados generados en las etapas anteriores para producir predicciones.

Sin embargo, a pesar de su potencial utilidad, en la práctica su uso es limitado. Una de las principales causas es su falta de integración con los flujos de trabajo estándar de análisis genómico, así como la falta ausencia de interfaces unificadas y accesibles para usuarios sin experiencia técnica.

La ejecución de estos modelos suele requerir pasos adicionales de preprocesamiento y transformación de los datos de entrada, que no son parte de los pipelines estándar.
Además, la preparación de los datos de entrada suele implicar conversión entre distintos formatos, así como la selección de características relevantes, lo que frecuentemente requiere un esfuerzo manual significativo o el desarrollo de scripts personalizados. A esto se suma la complejidad asociada a la instalación y configuración de los modelos, incluyendo la gestión de dependencias, la configuración de entornos de ejecución y la comprensión de los parámetros de entrada.

Como resultado, estos enfoques se utilizan principalmente en entornos de investigación especialmente en equipos con experiencia en bioinformática o aprendizaje automático. En cambio, su adopción en entornos generales es todavía limitada. Este escenario resalta la necesidad de soluciones que permitan una integración más directa y fluida de modelos predictivos en el flujo de análisis genómico, reduciendo la fricción entre el procesamiento de datos y su análisis y explotación, facilitando así su adopción.

=== Limitaciones del enfoque actual
Como se ha expuesto, el enfoque actual tanto del flujo de análisis genómico como de los modelos de predicción de resistencia a antibióticos presenta diversas limitaciones que afectan a la eficiencia, la escalabilidad y la adopción de estas herramientas en entornos reales.

En primer lugar, en el caso del análisis genómico, se identifican las siguientes limitaciones principales:

/ *DES-001* - *Fragmentación de herramientas*: Actualmente, el flujo de análisis genómico está compuesto por múltiples herramientas independientes que deben ejecutarse de forma secuencial, sin una integración unificada. Esta fragmentación obliga a gestionar manualmente la transferencia de datos entre etapas y dificulta la automatización del proceso.

/ *DES-002* - *Complejidad técnica y barrera de entrada*: La mayoría de herramientas se ejecutan en entornos Linux mediante línea de comandos, lo que requiere conocimientos técnicos en sistemas operativos, gestión de dependencias y configuración. Esto supone una barrera de entrada para usuarios no especializados, como los profesionales sanitarios, limitando su adopción.
/ *DES-003* - *Dependencia de configuración manual y baja automatización*: La construcción de pipelines de análisis genómico requiere la configuración manual de cada herramienta, la gestión de los datos intermedios y la verificación de compatibilidad entre ellas. Aunque existen plataformas que ofrecen interfaces gráficas, estas no eliminan completamente la complejidad ni la necesidad de tomar decisiones técnicas por parte del usuario.

En segundo lugar, en el caso de los modelos de predicción de resistencia a antibióticos, se identifican las siguientes limitaciones principales:

/ *DES-004* - *Falta de integración con flujo de análisis genómico*: Los modelos de predicción de resistencia a antibióticos suelen desarrollarse como herramientas independientes, especialmente para su uso en entornos de investigación, sin una integración directa con los flujos de análisis genómico estándar. Esto obliga a realizar pasos adicionales de preprocesamiento y adaptación de datos.

/ *DES-005* - *Complejidad  de configuración y ejecución*: Muchos modelos requieren la instalación de entornos específicos, la gestión de dependencias, la descargas de bases de datos adicionales y la configuración de parámetros. Esto incrementa la complejidad operativa, especialmente para usuarios no especializados.
/ *DES-006* - *Requisitos de preprocesamiento y transformación de datos*: La ejecución de estos modelos requiere la transformación de datos genómicos a representaciones específicas, como matrices de presencia/ausencia de genes. Este proceso no está automatizado para la mayoría de flujos estándar, lo que implica el desarrollo de scripts personalizados desde los resultados de etapas previas.
/ *DES-007* - *Limitaciones de usabilidad e interfaces de usuario*: La mayoría de modelos no disponen de interfaces gráficas accesibles ni de una documentación orientada a usuarios sin experiencia técnica. Esto limita su uso a perfiles con conocimientos de bioinformática o aprendizaje automático, dificultando su adopción en entornos clínicos o por parte de profesionales sanitarios.

En conjunto, estas limitaciones reflejan una brecha entre la complejidad técnia bioinformática y la necesidad de los usuarios finales, donde la accesibilidad y la integración de herramientas y modelos son aspectos clave a abordar para facilitar su adopción y uso efectivo.

== Usuarios y necesidades

=== Usuarios
Los principales usuarios a los que está destinado este proyecto son:

/ *Investigadores y profesionales de la salud*: Usuarios finales de la aplicación, realizan análisis genómicos para obtener información biológica a partir de datos de secuenciación, así como para predecir la resistencia a antibióticos. Su objetivo es obtener resultados de forma eficiente y accesible, sin necesidad de conocimientos técnicos avanzados en bioinformática o aprendizaje automático.

/ *Desarrolladores / Investigadores de modelos predictivos*: Usuarios especializados en el desarrollo de modelos predictivos para la resistencia a antibióticos. Su interés principal es poder integrar sus modelos en el sistema de forma sencilla, utilizándola como una plataforma o marco de trabajo que facilite su validación y aplicación en entornos reales. Para ello, requieren un mecanismo que permita incorporar nuevos modelos sin necesidad de modificar significativamente la infrastructura del sistema, favoreciendo su utilización y adopción.

=== Requisitos generales
A partir de las limitaciones del enfoque actual y las necesidades de los distintos perfiles de usuario, se extraen los siguientes requisitos generales del sistema:

/ *RG-001*: El sistema deberá proporcionar mecanismos para automatizar el flujo de análisis genómico, incluyendo ensamblaje y anotación en un único proceso integrado y abstrayendo la complejidad asociada a la ejecución de múltiples herramientas independientes.

/ *RG-002*: El sistema deberá permitir el acceso al flujo de análisis tanto de forma completa como a cada una de sus etapas. Se debe poder ejecutar cada etapa de forma independiente si así lo desea el usuario.
/ *RG-003*: El sistema deberá facilitar la integración de modelos de predicción de resistencia a antibióticos en el flujo de análisis genómico, permitiendo su ejecución directa a partir de los resultados generados durante las etapas previas.
/ *RG-004*: El sistema deberá proporcionar una interfaz gráfica accesible para usuarios sin experiencia técnica, que permita la ejecución de flujos de análisis genómico y modelos de predicción de resistencia a antibióticos de forma sencilla.
/ *RG-005*: El sistema deberá minimizar la complejidad asociada a la gestión de herramientas, entornos de ejecución y dependencias, reduciendo la carga cognitiva del usuario.
/ *RG-006*: El sistema deberá proporcionar mecanismos que permitan realizar un seguimiento de los procesos de análisis genómico, permitiendo a los usuarios monitorizar el progreso, revisar resultados intermedios y gestionar los datos generados durante el proceso.

=== Historias de usuario

A continuación, se exponen las historias de usuario derivadas de los requisitos generales, que describen las necesidades y objetivos de los distintos perfiles de usuario:

#historia_usuario(
  "001",
  "investigador o profesional de la salud",
  "ejecutar el ensamblaje y anotación de datos genómicos en un único proceso a partir de archivos de secuenciación (FASTQ)",
  "analizar muestras genómicas de forma eficiente",
)

#historia_usuario(
  "002",
  "investigador o profesional de la salud",
  "ejecutar etapas individuales del análisis genómico",
  "adaptar el flujo a mis necesidades específicas",
)

#historia_usuario(
  "003",
  "investigador o profesional de la salud",
  "utilizar los resultados de una etapa previa del análisis como entrada de etapas posteriores",
  "evitar repetir procesamientos innecesarios",
)

#historia_usuario(
  "004",
  "investigador o profesional de la salud",
  "ejecutar modelos de predicción de resistencia a antibióticos a partir de los resultados generados en la anotación de datos genómicos",
  "obtener predicciones de resistencia que apoyen la interpretación de la muestra",
)

#historia_usuario(
  "005",
  "investigador o profesional de la salud",
  "visualizar las predicciones de resistencia de forma clara e interpretable",
  "utilizarlas como apoyo en la toma de decisiones clínicas o en investigación",
)

#historia_usuario(
  "006",
  "investigador o profesional de la salud",
  "conocer el estado de los procesos de análisis genómico ejecutados",
  "monitorizar su progreso y acceder a los resultados",
)

#historia_usuario(
  "007",
  "investigador o profesional de la salud",
  "revisar y descargar los resultados de los procesos de análisis genómico",
  "almacenarlos, compartirlos o analizarlos posteriormente",
)

#historia_usuario(
  "008",
  "investigador o profesional de la salud",
  "descargar los resultados de las predicciones de resistencia a antibióticos",
  "almacenarlos, compartirlos o analizarlos posteriormente",
)

#historia_usuario(
  "009",
  "investigador o profesional de la salud",
  "recibir una notificación cuando se completen los procesos de análisis genómico que he ejecutado",
  "evitar comprobaciones manuales y acceder a los resultados en cuanto estén disponibles",
)

#historia_usuario(
  "010",
  "desarrollador o investigador de modelos predictivos",
  "integrar modelos de predicción en el sistema de forma sencilla",
  "facilitar su aplicación en análisis genómicos reales",
)

#historia_usuario(
  "011",
  "desarrollador o investigador de modelos predictivos",
  "usar los resultados generados durante etapas previas del análisis genómico como entrada para modelos de predicción",
  "evitar transformaciones manuales de los datos",
)

// TODO: A lo mejor añadir un mockup de la parte de visualización de resultados de predicciones? es un punto importante del sistema

== Diseño conceptual de la solución

=== Enfoque del sistema

Dado el análisis de necesidades realizado, se propone el desarrollo de una plataforma orientada a la integración del flujo de análisis genómico y la predicción de resistencia a antibióticos, como una solución única incorporandolo todo en un único proceso. Se busca un enfoque dual: por un lado, una interfaz gráfica accesible e intuitiva que permite ir desde la secuenciación a la predicción de forma sencilla; y por otro, un framework extensible que facilita la incorporación de nuevos modelos y componentes por parte de los desarrolladores.

Se identifican tres principios clave:

+ *Abstracción del flujo de análisis genómico*: El sistema incluye la ejecución de todas las etapas del proceso, desde la secuenciación hasta la obtención de los resultados de la predicción, proporcionando una experiencia de uso unificada que elimina la necesidad de gestionar herramientas independientes.
+ *Accesibilidad mediante interfaz gráfica intuitiva*: Se ofrece una interfaz gráfica orientada a usuarios sin experiencia en bioinformática, especialmente profesionales sanitarios o personal investigador, que permite ejecutar el flujo compleyo de resistencia sin poseer conocimientos técnicos.
+ *Extensibilidad mediante un enfoque de framework*: El sistema está diseñado como una plataforma extensible que permite a desarrollador e investigadores integrar uevos modelos predictivos de forma sencilla, favoreciendo su uso en entornos reales.

Con estos principios, se busca dar soporte a los perfiles definidos en la sección de análisis de usuarios, proporcionando una solución para las necesidades de ambos.

=== Flujo de análisis genómico integrado
El sistema implementa un flujo de procesamiento de datos genómicos en el que cada etapa transforma la información de entrada, generando resultados que pueden ser utilizados en etapas posteriores. Este flujo parte de los datos de secuenciación en formato FASTQ y finaliza con la generación de predicciones de resistencia a antibióticos. Se sigue un flujo modulas y flexible, que permite la ejecución completa del pipeline o la ejecución de sus distintas etapas de forma independiente, según las necesidades del usuario. El flujo general se muestra en la @fig:flujo_general.

#figure(
  placement: auto,
  image("/memoria/figures/flujo_general.svg", height: 90%),
  caption: "Flujo de análisis genómico integrado del sistema",
)<fig:flujo_general>

El proceso puede iniciarse desde distintos puntos del sistema. En el caso del flujo completo, los datos de secuenciación en formato FASTQ se utilizan como entrada para iniciar el proceso de ensamblaje del genoma, obteniéndose como resultado un conjunto de contigs en formato FASTA.

A partir de estos resultados, el sistema permite la ejecución de la etapa de anotación. Esta puede activarse de forma automática al finalizar el ensamblaje, si así se indica al iniciar el proceso, o manual. El sistema toma como entrada los contigs generados en la etapa anterior o el archivo FASTA proporcionado por el usuario, produciendo una representación funcional del genoma.

Posteriormente, esta representación es transformada de forma automática en un conjunto de características (features) compatibles con los modelos de predicción.  Este proceso de adaptación de datos se realiza de forma automática dentro del sistema, permitiendo la interoperabilidad entre las etapas del análisi genómico y los modelos predictivos sin intervención manual.

A partir de estas características, el usuario puede ejecutar el proceso de predicción de resistencia a antibióticos. En caso de activación, el sistema genera resultados interpretables que muestra de forma visual.

Además, el sistema permite la descarga de resultados en cada una de las etapas principales del flujo (ensamblaje, anotación y predicción). Esto permite adaptar el sistema a distintos usos y necesidades de los usuarios.

En conclusión, el flujo desacopla las distintas etapas del análisis genómico mediante un diseño modular, permitiendo su ejecución de forma encadenada o independiente, proporcionando así flexibilidad para su aplicación.

=== Alcance del sistema

El sistema propuesto se centra en la integración y orquestación del flujo de análisis genómico y de modelos predictivos ya existentes, actuando como una capa de abstracción sobre las herramientas consolidadas en la bioinformática.

En este sentido, el sistema no pretende reemplazar las herramientas existentes ni desarrollar nuevos modelos de predicción, sino facilitar su uso mediante una plataforma unificada que mejore su usabilidad, accesibilidad e integración.

El alcance del sistema incluye la integración de herramientas en un flujo unificado, la automatización de las etapas del flujo de análisis genómico, la gestión de datos intermedios, la integración de modelos predictivos y la presentación de resultados de forma clara e interpretable para el usuario. Adicionalmente, se incluye la implemenatción de un mecanismo que permita la incorporación de nuevos modelos y procesamiento de datos desde el anotado de forma sencilla.

Por el contrario, quedan fuera del alcance aspectos como el desarrollo de nuevas herramientas de ensamblaje o anotación, la mejora de herramientas ya existentes o la investigación de nuevos modelos de predicción.

En conjunto, el sistema se orienta a reducir la barrera técnica existente en el proceso de análisis genómico y el uso de modelos de predicción de resistencia a antibióticos, proporcionando una interfaz unificada que abstrae dicha complejidad.

// TODO: Mencionar algo del servicio de conversiones????


== Catálogo de requisitos
Se presenta a continuación un catálogo de requisitos que se deriva del análisis realizado en las secciones anteriores, estructurado en casos de uso, requisitos de información, requisitos funcionales y requisitos no funcionales, que servirán como base para el diseño detallado e implementación del sistema.

=== Casos de uso
En esta sección se presentan los casos de uso derivados de las historias de usuario. Cada caso de uso incluye una descripción detallada del flujo principal, los resultados esperados y las posibles excepciones o errores que pueden ocurrir durante su ejecución.

==== Actores
Los actores principales que interactúan en los casos de uso son:

/ *ACT-001 - Usuario investigador o profesional de la salud*: realiza análisis genómicos y utiliza modelos de predicción de resistencia a antibióticos para obtener información biológica a partir de datos de secuenciación.

/ *ACT-002* - *Sistema de análisis genómico y predicción de resistencia a antibióticos*: Sistema propuesto que integra el flujo de análisis genómico y la predicción de resistencia a antibióticos, proporcionando una interfaz gráfica accesible para usuarios sin experiencia técnica.

=== Diagramas y definición de casos de uso

Se asumen las siguientes precondiciones para todos los casos de uso del sistema:
- El usuario (ACT-001), investigador o profesional de la salud, deberá estar autenticado en el sistema mediante una cuenta de usuario válida.

Se asumen las siguientes excepciones comunes para todos los casos de uso del sistema:
- El sistema debe tener un sistema de control de propiedad, donde solo se podrán visualizar o realizar transformaciones sobre entidades pertenecientes al usuario autenticado (como procesos, sus resultados o notificaciones).


// TODO: añdir más cosas generales

// TODO: añadir el nombre final del sistema?

==== Pipleline de análisis genómico


#figure(
  image("/memoria/figures/uso_pipeline.svg", width: 90%),
  caption: "Diagrama de casos de uso para el flujo de análisis genómico integrado",
)<fig:uso_pipeline>


#caso_de_uso(
  "001",
  "Ejecutar flujo de ensamblaje y anotación",
  "El usuario (ACT-001) dispone de datos lecturas en formato FASTQ",
  "Permite ejecutar el flujo de análisis genómico desde el ensamblaje al anotado, incluyendo la transformación automática de resultados a características compatibles con modelos de predicción (features)",

  (
    "El usuario (ACT-001) entra en la sección Ensamblaje del sistema",
    "El usuario (ACT-001) selecciona el tipo de datos de entrada",
    "El actor (ACT-001) proporciona los datos de secuenciación en formato FASTQ",
    "El actor (ACT-001) selecciona la opción de ejecutar el flujo completo de análisis genómico",
    "El sistema (ACT-002) inicia el proceso de ensamblaje utilizando los datos proporcionados",
    "El sistema (ACT-002) genera contigs en formato FASTA como resultado del ensamblaje",
    "El sistema (ACT-002) inicia el proceso de anotación utilizando los contigs generados en la etapa anterior",
    "El sistema (ACT-002) genera una representación funcional del genoma como resultado de la anotación",
    "El sistema (ACT-002) transforma automáticamente la representación funcional en un conjunto de características compatibles con modelos de predicción",
  ),

  "Se generan resultados del ensamblaje, anotación y transformación de datos, que pueden ser descargados o utilizados para predicciones. Las features se encuentran calculadas y almacenadas en el sistema, listas para su uso en modelos de predicción",

  (
    "Datos inválidos: se muestra un mensaje explicativo al usuario",
    "Error en el proceso de ensamblaje o anotación: se marca el proceso como fallido y se informa al usuario",
  ),
)

#caso_de_uso(
  "002",
  "Ejecutar flujo de ensamblaje",
  "El usuario (ACT-001) dispone de datos lecturas en formato FASTQ",
  "Permite ejecutar la etapa de ensamblaje",

  (
    "El usuario (ACT-001) entra en la sección Ensamblaje del sistema",
    "El usuario (ACT-001) selecciona el tipo de datos de entrada",
    "El actor (ACT-001) proporciona los datos de secuenciación en formato FASTQ",
    "El sistema (ACT-002) inicia el proceso de ensamblaje utilizando los datos proporcionados",
    "El sistema (ACT-002) genera contigs en formato FASTA como resultado del ensamblaje",
  ),

  "Se genera un archivo FASTA con los contigs ensamblados, que puede ser descargado o utilizado para etapas posteriores",

  (
    "Datos inválidos: se muestra un mensaje explicativo al usuario",
    "Error en el proceso de ensamblaje: se marca el proceso como fallido y se informa al usuario",
  ),
)

#caso_de_uso(
  "003",
  "Ejecutar flujo de anotación",
  "El usuario (ACT-001) dispone de datos lecturas en formato FASTA o un proceso de ensamblaje anterior sin anotación asociada",
  "Permite ejecutar la etapa de anotación",

  (
    "El usuario (ACT-001) entra en la sección Anotación del sistema",
    "El usuario (ACT-001) selecciona el archivo de entrada para la anotación, que puede ser un archivo FASTA con contigs ensamblados o un proceso de ensamblaje previo sin anotación asociada",
    "El sistema (ACT-002) inicia el proceso de anotación utilizando los datos proporcionados",
    "El sistema (ACT-002) genera una representación funcional del genoma como resultado de la anotación",
    "El sistema (ACT-002) transforma automáticamente la representación funcional en un conjunto de características compatibles con modelos de predicción",
  ),

  "Se permite al usuario acceder a los datos de la anotación, que puede ser descargado o utilizado para etapas posteriores y las features se encuentran calculadas y almacenadas en el sistema, disponibles para su uso en modelos de predicción",

  (
    "Datos inválidos: se muestra un mensaje explicativo al usuario",
    "Error en el proceso de anotación: se marca el proceso como fallido y se informa al usuario",
  ),
)

#caso_de_uso(
  "004",
  "Generar features para predicción",
  "El usuario (ACT-001) dispone de resultados de anotación válidos",
  "Permite cargar resultados de anotación externos y generar características para predicción",

  (
    "El usuario (ACT-001) entra en la sección Anotación del sistema",
    "El usuario (ACT-001) selecciona el archivo de entrada",
    "El sistema (ACT-002) inicia el proceso de generación de features con los datos proporcionados",
    "El sistema (ACT-002) transforma automáticamente la representación funcional en un conjunto de características compatibles con modelos de predicción",
  ),

  "Las features se encuentran calculadas y almacenadas en el sistema, disponibles para su uso en modelos de predicción",

  (
    "Datos inválidos: se muestra un mensaje explicativo al usuario",
    "Error en el proceso de generación de features: se marca el proceso como fallido y se informa al usuario",
  ),
)


#caso_de_uso(
  "005",
  "Ejecutar predicción de resistencia a antibióticos",
  "El usuario (ACT-001) cuenta con características generadas",
  "Permite ejecutar la predicción de resistencia a antibióticos",

  (
    "El usuario (ACT-001) entra en la sección Predicción del sistema",
    "El usuario (ACT-001) selecciona los modelos de predicción a ejecutar, los antibióticos y las características a utilizar como entrada",
    "El sistema (ACT-002) ejecuta los modelos de predicción para los antibióticos y las características seleccionadas",
    "El sistema (ACT-002) genera resultados de predicción de resistencia a antibióticos",
    "El sistema (ACT-002) muestra los resultados de forma visual e interpretable",
  ),

  "Se generan resultados de predicción y se muestran al usuario de forma visual e interpretable",

  (
    "Combinación de modelos y antibióticos inválida: se muestra un mensaje explicativo al usuario",
    "Error en el modelo: se muestra un mensaje explicativo",
  ),
)

#caso_de_uso(
  "006",
  "Descargar resultados de predicción de resistencia a antibióticos",
  "El usuario (ACT-001) cuenta con procesos de anotación o generación de features finalizados con éxito",
  "Permite descargar los resultados de predicción de resistencia a antibióticos",

  (
    "El usuario (ACT-001) entra en la sección Predicción del sistema",
    "El usuario (ACT-001) selecciona los modelos de predicción a ejecutar, los antibióticos y las características a utilizar como entrada",
    "Si no se ha generado ya la predicción, el sistema (ACT-002) ejecuta los modelos de predicción para los antibióticos",
    "El sistema (ACT-002) descarga los resultados de predicción de resistencia a antibióticos",
  ),

  "El archivo es descargado por el usuario",

  (
    "Combinación de modelos y antibióticos inválida: se muestra un mensaje explicativo al usuario",
    "Error en el modelo: se muestra un mensaje explicativo",
    "Error en la descarga: se muestra un mensaje explicativo al usuario",
  ),
)

==== Notificaciones

#figure(
  image("/memoria/figures/uso_notificaciones.svg", width: 85%),
  caption: "Diagrama de casos de uso para el flujo de notificaciones del sistema",
)<fig:uso_notificaciones>

#caso_de_uso(
  "007",
  "Recibir notificaciones",
  "El usuario (ACT-001) ha iniciado procesos de análisis genómico",
  "Permite recibir notificaciones sobre el estado de los procesos (inicio, finalización correcta y error en la ejecución)",

  (
    "El sistema (ACT-002) detecta un evento (inicio, finalización correcta o error) en un proceso de análisis genómico iniciado por el usuario (ACT-001)",
    "El sistema (ACT-002) envía una notificación al usuario (ACT-001) informando sobre el evento ocurrido",
  ),

  "Se ha enviado una notificación al usuario (ACT-001) informando sobre el evento ocurrido",

  (
    "-",
  ),
)

#caso_de_uso(
  "008",
  "Ver notificaciones",
  "El usuario (ACT-001) ha recibido alguna notificación",
  "Permite visualizar el histórico de notificaciones generadas por el sistema para el usuario (ACT-001)",

  (
    "El usuario (ACT-001) accede al panel de notificaciones",
    "El sistema (ACT-002) muestra el histórico de notificaciones para el usuario (ACT-001)",
  ),

  "El usuario (ACT-001) visualiza el histórico de notificaciones generadas por el sistema",

  (
    "No existen notificaciones: se informa al usuario",
  ),
)

#caso_de_uso(
  "009",
  "Marcar notificaciones como leídas",
  "El usuario (ACT-001) cuenta con notificaciones no leídas",
  "Permite marcar una o todas las notificaciones como leídas para gestionar el histórico de notificaciones",

  (
    "El usuario (ACT-001) accede al panel de notificaciones",
    "El usuario (ACT-001) selecciona la opción de marcar como leída una notificación o todas",
    "El sistema (ACT-002) actualiza el estado de las notificaciones seleccionadas a leídas",
  ),

  "Las notificaciones quedan registradas como leídas",

  (
    "No existen las notificaciones seleccionadas: se informa al usuario",
  ),
)

==== Gestión de procesos

#figure(
  image("/memoria/figures/uso_procesos.svg", width: 85%),
  caption: "Diagrama de casos de uso para el flujo de gestión de procesos",
)<fig:uso_procesos>

#caso_de_uso(
  "010",
  "Listar procesos",
  "El usuario (ACT-001) ha ejecutado algún proceso de ensamblaje o anotación",
  "Permite visualizar la lista de procesos ejecutados por el usuario (ACT-001) con su estado (en ejecución, finalizado correctamente o error)",

  (
    "El usuario (ACT-001) accede a la sección Procesos del sistema",
    "El sistema (ACT-002) muestra la lista de procesos ejecutados por el usuario (ACT-001) con su estado",
  ),

  "El usuario (ACT-001) visualiza la lista de procesos ejecutados con su estado",

  (
    "No existen procesos para el usuario: se informa al usuario",
  ),
)

#caso_de_uso(
  "011",
  "Renombrar un proceso",
  "El usuario (ACT-001) ha ejecutado algún proceso de ensamblaje o anotación",
  "Permite cambiar el nombre de un proceso ejecutado por el usuario (ACT-001) para facilitar su identificación",

  (
    "El usuario (ACT-001) accede a la sección Procesos del sistema",
    "El sistema (ACT-002) muestra la lista de procesos ejecutados por el usuario (ACT-001) con su estado",
    "El usuario (ACT-001) selecciona un proceso de la lista",
    "El usuario (ACT-001) selecciona la opción de renombrar el proceso",
    "El usuario (ACT-001) introduce el nuevo nombre para el proceso",
    "El sistema (ACT-002) actualiza el nombre del proceso seleccionado",
  ),

  "El proceso queda actualizado con el nuevo nombre",

  (
    "Nombre inválido: se muestra un mensaje explicativo al usuario",
    "No existe el proceso seleccionado: se muestra un mensaje explicativo al usuario",
  ),
)

#caso_de_uso(
  "012",
  "Descargar resultados de ensamblaje o anotación",
  "El usuario (ACT-001) cuenta con procesos de ensamblaje o anotación finalizados con éxito",
  "Permite descargar los resultados de ensamblaje o anotación",

  (
    "El usuario (ACT-001) entra en la sección Procesos del sistema",
    "El usuario (ACT-001) selecciona un proceso de ensamblaje o anotación finalizado",
    "El usuario (ACT-001) selecciona la opción de descargar los resultados",
    "El sistema (ACT-002) inicia la descarga de los resultados",
  ),

  "El archivo es descargado por el usuario",

  (
    "Los resultados no están disponibles para descarga: se muestra un mensaje explicativo al usuario",
  ),
)

=== Requisitos de información
// TODO: había una plantilla de requisitos?

Los requisitos de información son...

=== Requisitos funcionales

Los requisitos funcionales son...

=== Requisitos no funcionales

Los requisitos no funcionales son...

== Conclusiones

En este capítulo concluimos que...
