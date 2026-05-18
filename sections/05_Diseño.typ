#import "../utils/todo.typ": todo

= Diseño de la solución
<sec:diseño>

== Introducción
En este capítulo se explica el diseño de la solución propuesta para abordar el problema de la predicción de resistencia a antibióticos a partir de datos genómicos. Se describe la arquitectura del sistema, los módulos que lo componen, los flujos principales de ejecución y las decisiones de diseño, tanto patrones como decisiones técnicas. Además, se presenta un mockup de la interfaz de visualización de resultados de predicción, uno de los aspectos clave del sistema, diseñado para facilitar la interpretación de los resultados por parte de los usuarios.

== Visión general de la arquitectura

=== Diagrama de arquitectura
El sistema se ha diseñado siguiendo una estructura distribuida compuesta por tres bloques principales, @fig:arquitectura: la capa de usuario, el sistema web y el sistema bioinformático. Esta separación permite aislar responsabilidades, mejorar la escalabilidad y facilitar la evolución independiente de cada componente.

#figure(
  placement: auto,
  image("/memoria/figures/arquitectura.svg", height: 60%),
  caption: "Diagrama de arquitectura del sistema a alto nivel",
)<fig:arquitectura>

En la *capa de usuario*, el usuario interactúa con el sistema a través de una interfaz web que actúa como punto de entrada a la funcionalidad del sistema. Esta interfaz permite la ejecución de procesos de análisis genómico y predicciones, la gestión de tareas y la consulta de resultados. Se ha diseñado con el objetivo de abstraer la complejidad técnica, para que sea intuitiva y accesible, facilitando la interacción con el sistema incluso para usuarios sin experiencia técnica.

El *sistema web* es el núcleo de la aplicación, el encargado de gestionar la lógica de negocio. Este bloque incluye un backend que expone una API, encargada de procesar las peticiones del usuario, gestionanando el persistencia de datos y ficheros y coordinando la ejecución de tareas. Para ello, el sistema dispone de:
- Un sistema de persistencia para almacenar datos estructurados (procesos, notificaciones, usuarios, etc.).
- Un sistema de almacenamiento de archivos para gestionar los datos de entrada y salida (FASTA, JSON, entre otros).
- Un mecanismo de ejecución asíncrona que permite delegar procesos de larga duración sin bloquear la interacción del usuario, para así cumplir con los requisitos de rendimiento y eficiencia definidos.
- Un módulo de predicción, encargado de ejecutar modelos de resistencia a antibióticos a partir de las características generadas en el pipeline.

Adicionalmente, el sistema web cuenta con un sistema de notificaciones para informar a los usuarios sobre el estado de sus tareas, así como mecanismos de autenticación y control de acceso para garantizar la seguridad de la información.

El *sistema bioinformático* es el encargado de la ejecución de los procesos de análisis genómico, como el ensamblaje y la anotación. Este sistema se encuentra desacoplado del sistema web, disponiendo de su propia API y mecanismo de gestión de tareas asíncronas. La interacción entre ambos sistemas se realiza mediante el envío de tareas desde el sistema web hacia el sistema bioinformático, que procesa dichas tareas y gestiona su ejecución de forma independiente. Esta separación permite mejorar la escalabilidad y facilita la integración de nuevas herramientas sin afectar al resto del sistema.

El flujo general de ejecución comienza cuando el usuario inicia un proceso desde la interfaz web. El backend registra la tarea y la delega para su procesamiento mediante un mecanismos de workers asíncronos. Estos workers se encargan de coordinar la ejecución del proceso en el sistema bioinformático, que realiza el análisis correspondiente. Una vez finalizado, los resultados son recuperados por el sistema web, que actualiza el estado de la tarea y los pone a disposición del usuario para su consulta o para su uso en etapas posteriores, como la predicción de resistencia a antibióticos.

Este enfoque presenta características propias de una arquitectura distribuida basada en servicios, adoptando principios asociados a arquitecturas de microservicios, como el desacoplamiento entre componentes y la comunicación asíncrona entre subsistemas. No obstante, no se trata de una arquitectura de microservicios en sentido estricto, ya que el sistema web mantiene una estructura unificada. Esta decisión permite equilibrar simplicidad y mantenibilidad dentro del alcance del proyecto. Así, se busca cumplir con requisitos no funcionales como la escalabilidad, la extensibilidad y la trazabilidad del flujo de procesamiento, facilitando la integración de nuevas herramientas bioinformáticas y modelos predictivos.

=== Diagrama de despliegue
Para el despliegue del sistema se ha optado por una arquitectura basada en contenedores, utilizando Docker para la gestión de los mismos. Esta elección permite una mayor flexibilidad y portabilidad, facilitando la implementación en diferentes entornos y la escalabilidad del sistema. El diagrama de despliegue se muestra en la @fig:despliegue.

Para el despliegue del sistema se ha optado por una arquitectura basada en contenedores, utilizando Docker para la gestión de los mismos. Esta elección permite una mayor flexibilidad y portabilidad, facilitando la implementación en diferentes entornos, muy importante para el objetivo del proyecto, y la escalabilidad del sistema. El diagrama de despliegue se muestra en la @fig:despliegue.

#figure(
  placement: auto,
  image("/memoria/figures/despliegue.svg", height: 40%),
  caption: "Diagrama de despliegue del sistema",
)<fig:despliegue>

Se han definido dos subsistemas principales, el *sistema web* y el *sistema bioinformático*, desplegado en entornos independientes. El sistema web gestiona la lógica de negocio, los usuarios, el almacenamiento de datos, la obtención de features y la ejecución de modelos predictivos. Por otro lado, el sistema bioinformático se concentra en la ejecución de los procesos de análisis genómico, ensamblaje y anotación.

Cada subsistema se compone de múltiples servicios desplegados en contenedores, incluyendo bases de datos, volúmenes y componentes de ejecución asíncrona basados en colas de tareas y workers, lo que permite gestionar procesos de larga duración sin bloquear la interacción con el usuario. Esta separación facilita el escalado independiente de los distintos componentes en función de su carga de trabajo.

La comunicación entre ambos sistemas se realiza a través de interfaces bien definidas basadas en APIs, permitiendo un acoplamiento débil entre ellos. Esto facilita la sustitución o evolución independiente de cada subsistema sin afectar al resto del sistema.

El usuario accede al sistema a través de un cliente web, típicamente el navegador de su dispositivo, que se comunica con el sistema web a través de peticiones HTTP. El sistema web puede desplegarse en diferentes entornos (locales o en la nube), mientras que el sistema bioinformático puede ubicarse en infraestructuras optimizadas para el procesamiento intensivo de datos, lo que permite adaptar el despliegue a las necesidades de rendimiento del sistema.

== Descomposición en módulos
Para la comprensión de las responsabilidades y la organización del sistema, se ha realizado una descomposición en módulos de cada uno de los bloques principales. Esta descomposición se ha llevado a cabo siguiendo principios de diseño modular y separación de responsabilidades, con el objetivo de facilitar la mantenibilidad, la escalabilidad y la evolución del sistema. La descomposición en módulos presentada es una organización coceptual del sistema, basada en responsabilidades, no necesariamente una correspondencia directa con la estructura final del código o con las aplicaciones del framework utilizado.


=== Módulos del sistema web <sec:modulos_web>

Los módulos que componen el sistema web, mostrados en la figura @fig:modulos_web, son los siguientes:

#figure(
  image("/memoria/figures/componentes_web.svg", width: 100%),
  caption: "Diagrama de módulos del sistema web",
)<fig:modulos_web>

- *Módulo de autenticación y control de acceso*: responsable de la gestión de usuarios y de garantizar que el acceso a los recursos esté restringido a su propietario.

- *Módulo de gestión de procesos*: encargado de la creación, seguimiento y gestión del ciclo de vida de los procesos de análisis genómico, incluyendo su estado y relaciones entre tareas. Este módulo se encarga de registrar las tareas iniciadas por los usuarios, gestionar su estado a lo largo del tiempo y coordinar la ejecución de las mismas.

- *Módulo de gestión de archivos*: responsable del almacenamiento y organización de los archivos de entrada y salida del sistema, como datos genómicos y resultados intermedios o finales. Adicionalmente, se encarga de la gestión de datos persistentes y datos temporales, incluyendo su eliminación cuando ya no son necesarios para mejorar la eficiencia.

- *Módulo de ejecución asíncrona*: responsable de la gestión de tareas de larga duración mediante mecanismos desacoplados, permitiendo la ejecución no bloqueante de los procesos de análisis genómico.

- *Módulo de integración bioinformática*: encargado de la comunicación con el sistema bioinformático externo, gestionando el envío de tareas, la monitorización de su estado y la recuperación de resultados mediante su API.

- *Módulo de generación de features*: encargado de la extracción y procesamiento de características a partir de los resultados de anotación, generando la información necesaria para alimentar los modelos de predicción de resistencia a antibióticos. Se trata de un módulo extensible que permite incorporar nuevos parsers o transformaciones de forma sencilla, facilitando la evolución y mejora continua del sistema.

- *Módulo de predicción*: responsable de la ejecución de modelos de resistencia a antibióticos a partir de las características generadas. Se trata de un módulo diseñado para ser extensible, permitiendo la incorporación de nuevos modelos mediante mecanismos desacoplados, como los adaptadores.

- *Módulo de notificaciones*: encargado de la generación y gestión de notificaciones asociadas al estado de los procesos y de su entrega a los usuarios. Este módulo se encarga de informar a los usuarios sobre el inicio, fallo o finalización de sus procesos.


=== Módulos del sistema bioinformático

Por otro lado, los módulos que componen el sistema bioinformático, mostrados en la figura @fig:modulos_bio, son los siguientes:

#figure(
  image("/memoria/figures/componentes_bio.svg", width: 100%),
  caption: "Diagrama de módulos del sistema bioinformático",
)<fig:modulos_bio>

- *Módulo de gestión de tareas bioinformáticas*: encargado de recibir y gestionar las tareas de análisis genómico enviadas desde el sistema web, coordinando su ejecución de forma asíncrona.

- *Módulo de ejecución del pipeline*: responsable de la ejecución de las herramientas bioinformáticas necesarias para el ensamblaje y la anotación, gestionando la ejecución de las distintas etapas del proceso.

- *Módulo de gestión de resultados*: encargado de procesar los resultados generados y facilitar su recuperación por parte del sistema web.

== Modelo de datos y clases <sec:modelo_datos>
==== Modelo de clases
El modelo de clases del sistema (@fig:clases) se diseñó siguiendo una estructura orientada a separar claramente los distintos dominios funcionales de la aplicación: gestión de procesos bioinformáticos, persistencia de archivos y genes anotados, y sistema de notificaciones.

#figure(
  placement: auto,
  image("/memoria/figures/modelo_clases.svg", width: 100%),
  caption: "Diagrama de clases del sistema web",
)<fig:clases>

El núcleo del sistema es la entidad `ConversionTask`, que representa los distintos procesos bioinformáticos ejecutados por los usuarios. Esta entidad almacena información relativa al estado del proceso, el tipo de tarea ejecuta, los archivos de entrada y salida asociados y la referencia al identificador generado por el subsistema bioinformático. Además, incorpora una relación recursiva mediante `previous_task`, utilizada para modelar dependencias entre procesos, como tareas de anotación generadas a partir de ensamblajes previos. Esta relación permite mantener la trazabilidad completa de los flujos de procesamiento y reconstruir el pipeline seguido para cada análisis.

La persistencia de archivos genómicos se modela mediante la entidad `FileUpload`, encargada de representar los archivos subidos por los usuarios al sistema. Esta entidad abstrae los distintos tipos de archivos utilizados durante el flujo bioinformático (FASTA, JSON de anotación, etc.) y mantiene la relación con el usuario propietario. El sistema organizará automáticamente los archivos en distintas rutas según su tipo, facilitando su gestión y almacenamiento.

Por otro lado, la entidad `Gene` representa genes identificados durante el proceso de anotación y procesados como features para modelos de predicción. En lugar de almacenar una única referencia, cada gen mantiene una colección de identificadores, permitiendo agrupar distintas nomenclaturas asociadas al mismo gen provenientes de distintas bases de datos biológicas.

Se decidió separar los genes de los archivos, asociándolos mediante una relación many-to-many implementada a través de la entidad intermedia `FileGene`. Esta decisión evita la duplicación innecesaria de genes en la base de datos, ya que un mismo gen puede aparecer en múltiples archivos diferentes. Al mismo tiempo, `FileGene` permite almacenar información específica de cada ocurrencia concreta de un gen dentro de un archivo, incluyendo coordenadas genómicas (`start`, `stop`), secuencias nucleotídicas (`nt`), secuencias aminoacídicas (`aa`) y la herramienta experta asociada a la anotación. De este modo, se separa la información global del gen de los detalles concretos de su aparición en cada muestra.

Finalmente, el sistema de notificaciones se diseñó de forma desacoplada, con la entidad `TaskNotification`. La entidad TaskNotification permite asociar múltiples notificaciones a un mismo proceso, registrando distintos eventos relevantes como inicio, finalización, errores o advertencias. Además, el modelo soporta distintos canales de comunicación (`in_app` y `email`). La configuración de preferencias de notificación de cada usuario se modela mediante la relación `UserNotificationSettings`.

El modelo de clases definido tiene como objetivo establecer una estructura modular y extensible, praparada para dar soporte al pipeline bioinformático, modelos predictivos y distintos mecanismos de notificación si necesidad de rediseñar la arquitectura de persistencia del sistema.


=== Diagrama de estado de los procesos
El ciclo de vida de los procesos bioinformáticos gestionados por el sistema web se modeló según la @fig:estados, permitiendo representar de forma clara la evolución de cada tarea durante su ejecución.

#figure(
  placement: auto,
  image("/memoria/figures/estados.svg", width: 100%),
  caption: "Diagrama de estado de los procesos",
)<fig:estados>

Todos los procesos comienzan en el estado `pending`, indicando que la tarea ha sido registrada en el sistema pero todavía no se ha iniciado su ejecución. Este estado es un estado transitivo en el que se encontraran las atreas durante la fase inicila de creación y envío de tareas al subsistema bioinformático.

Una vez se inicia el procesamiento, la tarea pasa al estado `running`. Finalmente, el proceso puede finalizar en uno de los dos siguientes estados terminales:

- `completed`: indica que el proceso ha finalizado correctamente, con los resultados disponibles para su consulta o uso posterior.
- `failed`: indica que el proceso ha finalizado con un error, lo que puede deberse a distintos motivos, como errores en la ejecución del pipeline bioinformático o problemas de comunicación entre subsistemas.

Además, se permite la trandición de `pending`a `faied`para contemplar errores producidos antes del inicio del procesamiento, como problemas durante el envío inicial de la tarea.

== Flujos principales del sistema
Aunque el sistema permite la ejecución completa del flujo de análisis genómico, desde la carga de datos hasta la predicción de resistencia a antibióticos, los diagramas de secuencia han sido separados para facilitar la comprensión de cada etapa del proceso. A continuación, se presentan los diagramas de secuencia para cada una de las etapas principales del flujo de análisis genómico.

=== Flujo de ensamblaje y anotación
El diagrama de secuencia @fig:secuencia_bio describe el flujo de ejecución de los procesos de ensamblaje y anotación, desde la carga de los datos por parte del usuario hasta la disponibilidad de los resultados en el sistema.

#figure(
  placement: auto,
  image("/memoria/figures/secuencia_bio.svg", width: 100%),
  caption: "Diagrama de secuencia del flujo de ensamblaje o anotación",
)<fig:secuencia_bio>

El proceso se inicia cuando el *usuario* sube los archivos de entrada (datos FASTQ en el caso del ensamblaje o un archivo FASTA en el caso de la anotación) a través de la interfaz web y solicita la eecución de un proceso de ensamblaje o anotación. El *frontend* envía esta información al *backend*, que se encarga almacenar los archivos en el sistema de almacenamiento y registrar un nuevo proceso en la base de datos con estado inicial _pending_.

A continuación, el backend delega la ejecución del proceso a un *worker*, insertando la tarea en la *cola de procesamiento del sistema web*. Cuando se recoge la tarea, el worker se encarga de coordinar la ejecución del procso, actualizando su estado a _running_ y generando una notificación de inicio para el usuario, que se muestra en el frontend.

El worker realiza entonces una llamada a la *API del sistema bioinformático*, solicitando la ejecución del proceso de ensamblaje o anotación. Este sistema se encarga de gestionar la ejecución de forma independiente, encolando la tarea en su propia cola de procesamiento, donde es recogida por un *worker* bioinformático que ejecuta el *pipeline* correspondiente. Dicho pipeline realiza las etapas necesarias (ensamblaje/anotación) y genera los resultados asociados.

Una vez iniciado el proceso en el sistema bioinformático, el worker del sistema web monitoriza su estado mediante un mecanismo de polling, consultando periódicamente a la API bioinformática por el estado del proceso hasta la finalización del mismo. Cuando el proceso finaliza,el sistema bioinformático actualiza du estado y el worker del sistema web recupera los resultados a través de la API. Estos resultados son almacenados en el sistema de archivos del sistema web para su posterior uso o descarga por parte del usuario.

Dependiendo del tipo de proceso ejecutado, se realizan algunas opciones adicionales. En el caso del ensamblaje, se eliminan los archivos FASTQ que proporcionó el usuario como entrada, ya que estos se tratan como datos temporales. En el caso de la anotación, el sistema genera automáticamente las características (features) a partir de los resultados obtenidos y estas son almacenadas en la base de datos para su uso en modelos de predicción.

Finalmente, el backend actualiza el estado del proceso a _completed_ y genera una notificación de finalización, que es presentada al usuario a través de la interfaz web junto con la disponibilidad de los resultados.

Este flujo refleja la naturaleza distribuida y asíncrona del sistema, donde la orquestación se realiza desde el sistema web mientras que la ejecución de los procesos bioinformáticos se delega a un subsistema especializado. Esta separación permite gestionar eficientemente tareas de larga duración y facilita la escalabilidad del sistema.

=== Flujo de predicción de resistencia a antibióticos
El diagrama de la @fig:secuencia_prediccion muestra el *flujo de predicción de resistencia a antibióticos* dentro del sistema web, desde la interacción inicial del usuario hasta la obtención de resultados.

#figure(
  placement: auto,
  image("/memoria/figures/secuencia_predict.svg", width: 100%),
  caption: "Diagrama de secuencia del flujo de predicción de resistencia",
)<fig:secuencia_prediccion>

El flujo comienza cuando el *usuario* inicia un proceso de predicción a través de la interfaz web, el *frontend*. Para esto debe seleccionar la muestra sobre la que quiere hacer la predicción, así como los modelos y antibióticos de interés. Esta información se envía al *backend* mediante una solicitud de predicción, que incluye los datos seleccionados por el usuario.

Una vez recibida la petición, el backend consulta la *base de datos* para recuperar las características asociadas a la muestra seleccionada, que han sido previamente generadas a partir de los resultados de anotación. Estas características constituyen la información de entrada necesaria para alimentar los modelos de predicción.

A continuación, el sistema itera sobre cada combinación de modelo y antibiótico seleccionados, ejecutando el modelo correspondiente con las características de la muestra. Para cada caso, el backend llama a los *adaptadores* necesarios, que actúan como capa de abstracción entre la lógica del sistema y los *modelos de predicción*. Estos se encargan de preparar la entrada en el formato requerido a partir de las características y gestionar la carga de parámetros del modelo, como los pesos asociados a cada antibiótico.

El adaptador invoca entoncences al modelo de predicción correspondiente, que procesa las características de entrada y devuelve la predicción de resistencia. Esra respuesta se devuelve al adaptador que la envía de vuelta al backend, que se encarga de agregar los resultados de las ejecuciones y prepararlos para su visualización.

Finalmente, el backend envía la respuesta al frontend, que se encarga de mostrar los resultados de la predicción al usuario de forma clara e intuitiva, permitiéndole interpretar la información y tomar decisiones informadas sobre el tratamiento a seguir.

Este diseño introduce una clara separación de responsabiliadades entre la orquestación del proceso, realizado por el backend, y la ejecución de los modelos de predicción, facilitando la extensibilidad del sistema. En particular, la incorporación de nuevos modelos o la adaptación a diferentes formatos de entrada se realiza mediante la implementación de nuevos adaptadores, sin necesidad de modificar el flujo principal de la aplicación.

== Decisiones de diseño
En esta sección se explican las decisiones de diseño tomadas durante el desarrollo del sistema, incluyendo los patrones de diseño aplicados y otras decisiones técnicas relevantes. Estas decisiones se han tomado con el objetivo de cumplir con los requisitos definidos para el sistema, especialmente en lo que respecta a la escalabilidad, la extensibilidad y la mantenibilidad.

=== Patrones de diseño
Para el diseño del sistema se han aplicado diversos patrones de diseño de software, algunos derivados de las tecnologías empleadas (framework y sistema de ejecución asíncrona), y otros aplicados de forma consciente para atender a los requisitos específicos definidos para el sistema, especialmente en lo que respecta a la extensibilidad.

==== Patrones derivados del framework y la infrastructura
Estos patrones se han aplicado de forma implícita en el sistema, ya que vienen dados por las herramientas utilizadas.

/ *Modelo-Vista-Template (MVT)*: El sistema web se apoya en el patrón MVT proporcionado por _Django_, que organiza la aplicación entorno a modelos de datos, vistas que gestionan la lógica de negocio y templates para la presentación de la información al usuario. Este patrón facilita la separación de responsabilidades y mejora la mantenibilidad del código.

/ *Command*: El sistema de ejecución asincrona basado en _Celery_ sigue el patrón Command, donde cada tarea se define como un comando que encapsula una acción (por ejemplo, lanzar un ensamblaje o consultar el estado de un proceso) y puede ser ejecutada por los workers de forma desacoplada del resto del sistema.

/ *Singleton*: Componenetes como la configuración de _Django_ y la instancia de _Celery_ actúan como singletons, ya que se inician una sola vez y se reutilizan en todo el sistema.

==== Patrones aplicados en el diseño del sistema

/ *Adapter - Adaptadores para modelos predictivos*: Uno de los principales retos del sistema es la integración de modelos de predicción heterogéneos, con distintos formatos de entrada, configuraciones y salidas. Para abordar esto, se ha adoptado el patrón _Adapter_, creando una capa de adaptadores que actúan como intermediarios entre la lógica del sistema y los modelos de predicción. Cada adaptador se encarga de transformar las características generadas a partir de los resultados de anotación en el formato requerido por el modelo, así como de gestionar la carga de parámetros y la ejecución del modelo. Esto permite:
  - Incoprorar nuevos modelos sin modificar la lógica principal del sistema, mediante la implemetación de nuevos adaptadores.
  - Aislar dependencias externas, ya que los adaptadores pueden gestionar las particularidades de cada modelo sin afectar al resto del sistema.
  - Facilitar la experimentación con distintos enfoques de predicción.

/ *Registry - Registro dinámico de modelos y parsers*: El sistema implementa mecanismos de registro dinámico, basado en decoradores, que permite descubrir automáticamente modelos predictivos y parsers disponibles en el sistema. Este enfoque sigue un patrón de tipo _Registry_, donde nuevas clases de modelos o parsers pueden añadirse al sistema simplemente registrando nuevas clases, sin necesidad de modificar el código existente. Esto facilita:
  - Cumplir los requisitos de extensibilidad.
  - Reducir el acoplamiento.
  - Facilitar la evolución del sistema.

/ *Strategy - Selección dinámica de comportamiento*: De forma complementaria al patrón de registro, los distintos modelos no solo deben estar en el sistema sino que deben poder ser utilizados por el usuario a petición. Usando el patrón _Strategy_, el sistema puede seleccionar de forma dinámica qué modelo de predicción utilizar. Múltiples algoritmos, en este caso modelos de predicción, comparten una interfaz común y pueden intercambiarse en tiempo de ejecución.

/ *Fachada - Encapsulación de complejidad*: La interacción con subsistemas complejos, como el sistema bioinformático o la gestión de procesos, se encapsulan servicios que actúan como fachadas, proporcionando una interfaz sencilla y unificada al resto del sistema. Esto:
  - Oculta la complejidad de la interacción con otros sistemas.
  - Simplifica el uso del sistema.
  - Reduce el acoplamiento entre componentes.
  - Centra la lógica de interacción con otros sistemas en las fachadas.

En conjunto, estos patrones permiten estructurar el sistema como una plataforma extensible y desacoplada, capaz de integrar nuevos modelos de predicción y herramientas bioinformáticas de forma sencilla, cumpliendo con los requisitos definidos y facilitando la evolución continua del sistema.

=== Decisiones técnicas
Por otro lado, en el diseño del sistema se han tomado diversas decisiones técnicas orientadas a satisfacer los requisitos no funcionales definidos, especialmente en términos de rendimiento, escalabilidad, mantenibilidad y extensibilidad. A continuación, se describen las más relevantes.

/ *Ejecución asíncrona de tareas*: se ha optado por el uso de un sistema de workers asíncronos para la ejecución de tareas de larga duración, como los procesos de ensamblaje y anotación. Esta decisión permite evitar el bloqueo de la interfaz de usuario y mejorar la experiencia de uso, permitiendo que el usuario continúe interactuando con el sistema mientras se ejecutan dichas tareas. Además, facilita la ejecución concurrente de múltiples procesos, contribuyendo al cumplimiento de los requisitos de rendimiento y eficiencia.

/ *Arquitectura distribuida basada en servicios*: el sistema se ha diseñado siguiendo una arquitectura distribuida basada en servicios, separando la aplicación web del sistema bioinformático. Esta separación permite desacoplar la evolución independiente de ambos subsistemas, facilitando la integración de nuevas herramientas bioinformáticas sin afectar a la lógica de negocio del sistema web. Además, posibilita escalar cada componente de forma independiente según sus necesidades específicas, mejorando la eficiencia en el uso de recursos.

/ *Despliegue a través de contenedores*: se ha optado por el uso de contenedores para el despliegue del sistema, lo que facilita la portabilidad entre entornos y simplifica la gestión de dependencias. Dado que el sistema está compuesto por dos subsistemas independientes, el uso de contenedores permite aislar de forma eficiente las configuraciones y dependencias específicas de cada uno de ellos.

/ *Diseño de la interfaz de usuario*: para la implementación de la interfaz de usuario se han seguido principios de diseño orientados a la simplicidad, la flexibilidad y la accesibilidad, buscando crear una experiencia de usuario intuitiva y eficiente, evitando complejidad innecesaria.

== Diseño de la interfaz de usuario

=== Principios de diseño
El diseño de la interfaz se ha realizado en coherencia con los objetivos definidos en la @sec:objetivos, buscando crear una experiencia de usuario intuitiva y accesible, que permita a los usuarios interactuar con el sistema de forma eficiente y sin necesidad de conocimientos técnicos avanzados. Para ello, se han seguido los siguientes principios de diseño:

- *Simplificación del flujo de trabajo*: se abstrae la complejidad del pipeline de análisis genómico, permitiendo su ejecución mediante interacciones sencillas como la subida de un archivo o la selección de opciones en la intefaz.

- *Flexibilidad en la ejecución*: se permite ejecutar el flujo completo o por etapas, dando a los usuarios la posibilidad de gestionar sus procesos de forma personalizada según sus necesidades.
- *Minimización de la barrera técnica*: se evita exponer detalles internos del procesamiento, facilitando el uso del sistema por parte de usuarios sin experiencia técnica.
- *Feedback continuo*: se proporciona a los usuarios información clara sobre el estado de cada proceso, especialmente en las tareas de larga duración, mediante indicadores visuales y notificaciones.
- *Consistencia visual*: se mantiene un diseño uniforme y coherente a lo largo de toda la interfaz, mejorando la usabilidad y reduciendo la curva de aprendizaje.
- *Diseño limpio y orientado al dominio*: se prioriza la claridad visual y el orden en la presentación de la información, alineada con el contexto científico del sistema.

=== Estructura general de la interfaz
La interfaz web es ofrecida por completo por el sistema web, que actúa como punto de entrada a toda la funcionalidad del sistema. Su estructura se ha diseñado para facilitar la navegación entre las distintas funcionalidades, permitiendo tanto la ejecución completa del flujo de análisis genómico como su uso por etapas, así como el seguimiento de los procesos en ejecución.

#figure(
  placement: auto,
  image("/memoria/figures/navegacion.svg", width: 100%),
  caption: "Diagrama de navegación de la interfaz",
)<fig:navegacion>

La navegación principal se organiza en torno a un conjunto reducido de secciones que reflejan las distintas etapas del flujo de análisis genómico y las funcionalidades de gestión del sistema, tal y como se muestra en la @fig:navegacion.

Se distinguen dos grandes bloques: los módulos de análisis, que incluyen las funcionalidades de ensamblaje, anotación y predicción, y las secciones de gestión y seguimiento, centradas en la consulta de procesos y notificaciones. Asimismo, el diagrama refleja las relaciones entre estas secciones. Destaca el papel de la gestión de procesos como punto central del seguimiento de las ejecuciones. Adicionalmente, se observa la dependencia entre etapas del flujo, donde la anotación puede partir de resultados de ensamblaje y la predicción utiliza las características generadas durante la anotación.

A continuación, se describe brevemente cada una de las secciones principales de la interfaz:

- *Inicio*: sección de entrada al sistema que proporciona una visión general y acceso a las funcionalidades principales.

- *Ensamblaje*: permite la subida de datos FASTQ y la ejecución del proceso de ensamblaje, ofreciendo además la opción de encadenar automáticamente la anotación.
- *Anotación*: permite seleccionar datos FASTA y ejecutar procesos de anotación, así como generar características a partir de archivos de anotación externos.
- *Predicción*: sección dedicada a la ejecución de modelos de predicción de resistencia a antibióticos, donde los usuarios pueden seleccionar las muestras, modelos y antibióticos de interés para obtener predicciones.
- *Procesos*: sección central para la gestión de los procesos de análisis, incluyendo el seguimiento de su estado y la consulta de resultados.
- *Notificaciones*: permite a los usuarios consultar las notificaciones generadas por el sistema relacionadas con el estado de sus procesos y otras alertas relevantes.

=== Visualización e interpretación de resultados

La visualización de los resultados de predicción de forma sencilla e interpretable es uno de los requisitos fundamentales del sistema. Por este motivo, el diseño de la interfaz se ha orientado a representar de forma clara la información generada durante la ejecución de los modelos predictivos.

En los resultados de predicción (@fig:mock_prediccion) se muestran los antibióticos evaluados frente a los modelos seleciconados, indicando la predicción de resistencia generada para cada combinación, indicando con colores si la muestra presenta resistencia o sensibilidad frente a cada antibiótico. Esta visualización permite a los usuarios interpretar rápidamente los resultados y tomar decisiones informadas sobre el tratamiento a seguir.

Además de las predicciones individuales generadas por cada modelo, el sistema representa una predicción agregada, a tarvés de la media de los resultados. Esta aproximación proporciona una visión global, facilitando la interpretación en escenarios en los que intervienen múltiples modelos.

#figure(
  placement: auto,
  image("../figures/mock_prediccion.svg", width: 80%),
  caption: "Mockup de la interfaz de visualización de predicciones.",
)<fig:mock_prediccion>

La interfaz también incorpora mecanismos de representación del estado de los procesos, permitiendo al usuario identificar de forma sencilla si una tarea se encuentra en ejecución, finalizada correctamente o ha producido algún error. Para ello, se utilizan colores, marcadores de estado e indicadores de progreso. Esto resulta especialmente relevante debido al elevado tiempo de ejecución asociado a determinadas tareas bioinformáticas.

== Conclusiones

En conclusión, el diseño del sistema se ha orientado a cumplir con los requisitos definidos para el proyecto, especialmente en términos de extensibilidad, mantenibilidad y facilidad de uso. La arquitectura distribuida basada en servicios, junto con la aplicación de patrones de diseño como Adapter, Registry y Strategy, permite integrar nuevos modelos de predicción y herramientas bioinformáticas de forma sencilla, sin necesidad de modificar la lógica principal del sistema.
