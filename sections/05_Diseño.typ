= Diseño de la solución
<sec:diseño>

== Introducción

En este capítulo explicaremos...

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


=== Módulos del sistema web

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

== Modelo de datos y clases
// TODO: Quiero cambiar una cosa del modelo de datos así que no quiero trabajaer en esto todavía, me lo voy a saltar por ahora. Pero aquí se explicaría el modelo de datos, las clases principales, sus responsabilidades, etc. También se podrían incluir algunos diagramas de clases para ilustrar la estructura del sistema y la relación entre los distintos componentes.
Quiero cambiar una cosa del modelo de datos así que no quiero hacerlo todavía pero irían:
- Diagrama de clases
- Diagrama de estado para los procesos!

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
  caption: "Diagrama de secuencia del flujo de predicción de resistencia a antibióticos",
)<fig:secuencia_prediccion>

El flujo comienza cuando el *usuario* inicia un proceso de predicción a través de la interfaz web, el *frontend*. Para esto debe seleccionar la muestra sobre la que quiere hacer la predicción, así como los modelos y antibióticos de interés. Esta información se envía al *backend* mediante una solicitud de predicción, que incluye los datos seleccionados por el usuario.

Una vez recibida la petición, el backend consulta la *base de datos* para recuperar las características asociadas a la muestra seleccionada, que han sido previamente generadas a partir de los resultados de anotación. Estas características constituyen la información de entrada necesaria para alimentar los modelos de predicción.

A continuación, el sistema itera sobre cada combinación de modelo y antibiótico seleccionados, ejecutando el modelo correspondiente con las características de la muestra. Para cada caso, el backend llama a los *adaptadores* necesarios, que actúan como capa de abstracción entre la lógica del sistema y los *modelos de predicción*. Estos se encargan de preparar la entrada en el formato requerido a partir de las características y gestionar la carga de parámetros del modelo, como los pesos asociados a cada antibiótico.

El adaptador invoca entoncences al modelo de predicción correspondiente, que procesa las características de entrada y devuelve la predicción de resistencia. Esra respuesta se devuelve al adaptador que la envía de vuelta al backend, que se encarga de agregar los resultados de las ejecuciones y prepararlos para su visualización.

Finalmente, el backend envía la respuesta al frontend, que se encarga de mostrar los resultados de la predicción al usuario de forma clara e intuitiva, permitiéndole interpretar la información y tomar decisiones informadas sobre el tratamiento a seguir.

Este diseño introduce una clara separación de responsabiliadades entre la orquestación del proceso, realizado por el backend, y la ejecución de los modelos de predicción, facilitando la extensibilidad del sistema. En particular, la incorporación de nuevos modelos o la adaptación a diferentes formatos de entrada se realiza mediante la implementación de nuevos adaptadores, sin necesidad de modificar el flujo principal de la aplicación.

== Decisiones de diseño
// TODO
=== Patrones de diseño
[EN CONSTRUCCIÓN]
- Patrón decorador para la el registro de modelos y parsers.
- Model View Template pq lo pone Django.
- Patrón singletom para la configuración y los recursos compartidos. EL objeto config de django y la instancia de celery se inician una sola vez y se reutilizan en todo el sistema.
- Patrón fachada. Módulos como services.py (para la lógica de negocio) y bio_api_client.py (para usar el bioservice) encapsulan la complehidad de la interacción con sistemas externos, proporcionando una interfaz sencilla y simple al resto del sistema.
- Patrón observador en el sistema de notificaciones. Cuando cambian los estados de las tareas se genera una notificación (pero no es observer puro pq no hay subscripción dinámica ni nada, es más una generación de eventos que un patrón observer puro, pero se podría considerar una aproximación al patrón observer).
- Patrón command: cada tarea de celery se define como un comando que puede ser ejecutada de forma asincrona por los workers.
- ^Patrón strategy: el resgistro de modelos permite seleccionar dinamicamente la clase de modelo a usar, lo que permite aplicar distintos modelos de predicción???? (
  overreach??
)
- Patrón repositorio para la gestión de la persistencia de datos, encapsulando el acceso a la base de datos y proporcionando una interfaz coherente para la gestión de entidades como procesos, usuarios, etc. (no se yo, es por tener un queryset)

Separar por lo que he decidido implementar y los que vienen dados por el framework.

- Uso de adaptadores para la integración de modelos de predicción
- Uso de parsers modulares para la generación de características a partir de los resultados de anotación, facilitando la incorporación de nuevas herramientas bioinformáticas y la evolución del sistema

=== Decisiones técnicas
[EN CONSTRUCCIÓN]
- Uso de workers asíncronos para la ejecución de tareas de larga duración
- Uso de una arquitectura basada en servicios para mejorar la escalabilidad y facilitar la evolución independiente de los componentes
- Uso de Docker para el despliegue del sistema, facilitando la portabilidad y la implementación en diferentes entornos
- Uso de una base de datos relacional para la gestión de datos estructurados, garantizando la integridad y facilitando las consultas complejas necesarias para la gestión de procesos y usuarios
- Uso de un sistema de almacenamiento de archivos para gestionar los datos de entrada y salida, optimizando el rendimiento y la eficiencia en la gestión de grandes volúmenes de datos genómicos
- Separación en dos servicios principales (sistema web y sistema bioinformático) para mejorar la escalabilidad y facilitar la integración de nuevas herramientas sin afectar al resto del sistema

== Diseño de la interfaz de usuario

=== Principios de diseño
El diseño de la interfaz se ha realizado en coherencia con los objetivos definidos en la <sec:objetivos>, buscando crear una experiencia de usuario intuitiva y accesible, que permita a los usuarios interactuar con el sistema de forma eficiente y sin necesidad de conocimientos técnicos avanzados. Para ello, se han seguido los siguientes principios de diseño:

- *Simplificación del flujo de trabajo*: se abstrae la complejidad del pipeline de análisis genómico, permitiendo su ejecución mediante interacciones sencillas como la subida de un archivo o la selección de opciones en la intefaz.
- *Flexibilidad en la ejecución*: se permite ejecutar el flujo completo o por etapas, dando a los usuarios la posibilidad de gestioanr sus procesos de forma personalizada según sus necesidades.
- *Minimización de la barrera técnica*: se evita exponer detalles internos del procesamiento, facilitando el uso del sistema por parte de usuarios sin experiencia técnica.
- *Feedback continuo*: se proporciona a los usuarios información clara sobre el estado de cada proceso, especialmente en las tareas de larga duración, mediante indicadores visuales y notificaciones.
- *Consistencia visual*: se mantiene un diseño uniforme y coherente a lo largo de toda la interfaz, mejorando la usabilidad y reduciendo la curva de aprendizaje.
- *Diseño lipio y orientado al dominio*: se prioriza la claridad visual y el orden en la presentación de la información, alineada con el contexto científico del sistema.

=== Estructura general de la interfaz
[EN CONSTRUCCIÓN]
- Navegación principal
- Secciones - a lo mejor con un diagrama de navegación???

// TODO
=== Interacción y experiencia de usuario
[EN CONSTRUCCIÓN]

==== Ejecución del pipeline de análisis genómico
- Explicar como se hace:
- Pipeline completo
- Ejecución por etapas
- Predicción

==== Gestión de procesos y estados
- Gestión de procesos

==== Notificaciones
- Sistema de notificaciones (?)

=== Visualización de los resultados
[EN CONSTRUCCIÓN]
- Visualización de resultados (este con mockup)

=== Decisiones de diseño
[EN CONSTRUCCIÓN]
- uso de tailwind / DaisyUI

A lo mejor mandar directamente a tecnologías???



== Tecnologías y herramientas utilizadas
// TODO: explicar las tecnologías elegidas,por qué se han elegido, qué ventajas aportan, etc.

== Conclusiones

En esta capítulo concluimos que...
