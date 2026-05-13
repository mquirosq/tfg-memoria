#import "../utils/todo.typ": todo
= Implementación
<sec:implementación>

== Introducción

En este capítulo se aborda el proceso de implementación del sistema desarrollado en este trabajo, organizado de forma incremental mediante distintos sprints. A lo largo de estos sprints se abordaron tanto la definición de la arquitectura y la infraestructura base del sistema como la implementación progresiva de las funcionalidades relacionadas con el análisis genómico y la predicción de resistencia a antibióticos.

Para cada sprint se describen los objetivos planteados, las principales decisiones técnicas adoptadas, los problemas encontrados durante el desarrollo y los resultados obtenidos.

== Tecnologías y herramientas utilizadas

#todo("Maybe añadir un diagrama a modo resumen de las tecnologías?")

En esta subsección se describen las principales tecnologías y herramientas utilizadas en el desarrollo del sistema, explicando las razones detrás de su elección. La selección de las mismas se ha realizado teniendo en cuenta los requisitos definidos para el proyecto, especialmente aquellos relacionados con la mantenibilidad, extensibilidad, interoperabilidad y facilidad de despliegue.

=== Frontend
La interfaz web se ha desarrollado utilizando HTML, CSS y JavaScript, junto con Tailwind CSS y DaisyUI para el diseño visual de la aplicación.

Se ha optado por no utilizar frameworks frontend complejos como React o Angular, ya que la interfaz del sistema se centra principalmente en la gestión de formularios, la visualización de resultados y el seguimiento de procesos asíncronos, sin requerir una lógica de interacción especialmente compleja en el lado del cliente. El uso de este tipo de frameworks habría introducido una complejidad adicional tanto en el desarrollo como en el despliegue del sistema, sin aportar beneficios significativos para los objetivos del proyecto. En su lugar se ha priorizado una arquitectura frontend ligera y sencilla de mantener que permite iterar rápidamente sobre el diseño de la interfaz y adaptarla a las necesidades de los usuarios, sin la sobrecarga que implicaría un framework más pesado.

Para el diseño visual se ha utilizado _DaisyUI_, basada en _Tailwind CSS_. Tailwind permite construir interfaces de forma flexible mediante clases, mientras que DaisyUI proporciona componentes reutilizables que permiten ofrecer una apariencia consistente. Esta decisión permite acelerar el desarrollo de la interfaz, evitando complejidad innecesaria  garantizando al mismo tiempo una apariencia consistente y profesional.

=== Backend web
El backend del sistema web se ha desarrollado utilizando _Django_ como framework principal y _PostgreSQL_ como sistema de gestión de bases de datos.

Debido a la integración con modelos de predicción, se ha decidido utilizar _Python_ como lenguaje principal del proyecto, ya que se trata del lenguaje predominante tanto en el ámbito de la ciencia de datos y el aprendizaje automático. Esto facilita la integración con modelos prodictivos y herramientas externas en el mismo ecosistema tecnológico.

Dentro de los frameworks de desarrollo web disponibles para Python, se ha optado por _Django_ debido a su amplia gama de funcionalidades integradas, como sus sistema de gestión de usuarios y autenticación, el ORM para la persistencia de datos y el panel de administración. Estas características permiten acelerar el desarrollo de funcionalidades comunes y permiten centrarse en la lógica específica del proyecto. Además, gran parte del sistema consiste en la gestión de entidades persistentes relacionadas entre sí como procesos, archivos o notificaciones, lo que se adapta bien al modelo relacional y el ORM de Django.

Como sistema de persistencia se ha utilizado _PostgreSQL_ debido a su fiabilidad, rendimiento y  compatibilidad con Django.

=== Sistema bioinformático
El subsistema bioinformático se ha desarrollado también principalmente en Python, debido a la amplia disponibilidad de herramientas y bibliotecas bioinformáticas, haciendo que sea el lenguaje más adecuado para la integración de las herramientas de ensamblaje y anotación, así como para la gestión de pipelines de procesamiento.

Para la implementación de la API del sistema bioinformático se ha utilizado _FastAPI_. A diferencia del sistema web principal, este subsistema no requiere funcionalidades avanzadas de gestión de usuarios o renderizado de vistas, sino una interfaz ligera y eficiente orientada a la comunicación entre servicios. FastAPI permite implementar esta API de forma sencilla, con buena integración con Python.

El sistema bioinformático integra herramientas especializadas para distintas etapas del pipeline genómico. Por un lado se hace uso de herramientas de ensamblaje como _SPAdes_  _Raven_ or _Flye_, permitiendo adaptar el procesamiento a distintos tipos de datos de secuenciación, incluyendo tecnologías Illumina y ONT.

Por otro lado, para la anotación del genoma se utiliza _Bakta_, una herramienta orientada a la anotación de secuencias de ADN especialmente diseñada para muestras de bacterias. Bakta ofrece una anotación rápida y estandarizada, lo que facilita la generación de resultados consistentes y de alta calidad, además de ser compatible con el formato de salida JSON, lo que permite su integración directa con el sistema web para la generación de características y la ejecución de modelos predictivos.

=== Gestión de tareas asíncronas
Para la gestión de las tareas asíncronas de ensamblaje y anotación se ha utilizado _Celery_ junto con _Redis_ como sistema de cola de mensajes.

Celery permite definir tareas desacopladas que son ejecutadas por workers independientes del servidor web principal. Esto permite delegar la ejecución de procesos de larga duración sin bloquear la interacción del usuario con la aplicación y facilita la ejecución concurrente de múltiples tareas.

Por otro lado, Redis se emplea como intermediario para la gestión de colas gracias a su sencilla intergación con Celery y el hecho de que es un sistema de almacenamiento en memoria que ofrece un alto rendimiento en operaciones de lectura y escritura.

Además, este enfoque simplifica la coordinación entre el sistema web y el sistema bioinformático, permitiendo gestionar el envío de tareas, la monitorización de su estado y la recuperación de resultados de forma desacoplada.

=== Despliegue y contenedorización
Para el despliegue del sistema se ha optado por una arquitectura basada en contenedores utilizando _Docker_. Se ha optado por esta tecnología ya que se trata del sistema más extendido y conocido de contenedorización. Además, cuenta con muy bien soporte y documentación online, lo que facilita su uso tanto durante el desarrollo como en la fase de despliegue y producción.

Para la orquestación de los contenedores se ha decidido usar _Docker Compose_, lo que permite definir y gestionar la infraestructura del sistema de forma sencilla a través de archivos de configuración. Esto simplifica tanto el despliegue como la puesta en producción del sistema.


== Sprint 1 - Estudio previo y definición del sistema
=== Objetivos
Este sprint se desarrolló entre el 25 de noviembre y el 2 de diciembre de 2025, con el objetivo principal de establecer las bases conceptuales y técnicas del sistema. Durante esta fase, se realizó un estudio preliminar del dominio bioinformático para comprender el contexto biológico relacionado con la resistencia a antibióticos, así como las técnicas de análisis genómico y predicción basadas en técnicas de aprendizaje automático. Además, se definieron las funcionalidades principales de la aplicación y se elaboró un plan de trabajo detallado para guiar el desarrollo del proyecto en los siguientes sprints.

Los objetivos principales de este sprint fueron:

- Analizar el flujo de procesamiento necesario para el análisis genómico y la predicción de resistencia a antibióticos.
- Identificar herramientas bioinformáticas relevantes para el proyecto.
- Estudiar modelos de machine learning aplicados a la predicción de resistencia a antibióticos.
- Definir el alcance funcional del sistema.
- Establecer una planificación inicial del desarrollo.

=== Detalles de implementación
Durante este sprint se realizó un análisis técnico y conceptual del dominio bioinformático, incluyendo los distintos pasos necesarios para construir un pipeline completo y útil de análisis genómico. Se estudiaron las etapas de secuenciación, ensamblaje, anotación y transformación de datos genómicos en características utilizables por modelos de predicción. Además, se realizó una investigación de las técnicas de machine learning más relevantes para la predicción de resistencia a antibióticos.

Se realizaron pruebas preliminares con distintas herramientas bioinformáticas para evaluar sus requisitos de entrada, formatos de salida y complejidad de integración dentro del flujo de procesamiento planteado. A partir de este análisis se definió el flujo principal soportado por el sistema, compuesto por las siguientes etapas:

1. *Ensamblaje* de datos genómicos a partir de secuencias crudas utilizando herramientas como _SPAdes_, _Flye_ o _Raven_.
2. *Anotación* de datos genómicos utilizando _Bakta_.
3. *Generación de features* a partir de los datos anotados.
4. *Predicción* de resistencia a antibióticos utilizando modelos de machine learning.

También se identificó la necesidad de desacoplar la ejecución de tareas bioinformáticas del sistema web principal debido al elevado tiempo de ejecución y consumo de recursos de las herramientas de ensamblaje y anotación. Se decidió diseñar en el sprint siguiente un sistema que aislaría las tareas largas y computacionalmente intensivas del backend principal, evitando que las tareas de larga duración afectasen a la capacidad de respuesta del sistema web.

Durante esta fase se definió además una primera aproximación de los requisitos funcionales y no funcionales del sistema, así como una planificación inicial del desarrollo organizada en distintos sprints.

=== Resultados
Durante este sprint se sentaron las bases para el desarrollo del sistema, se adquirió un entendimiento clave del contexto biológico y se definieron los objetivos y el alcance del proyecto. Esto permitió establecer una dirección clara para el desarrollo del sistema en los siguientes sprints.

== Sprint 2 - Diseño de arquitectura y definición del framework
=== Objetivos
Este sprint se desarrolló entre el 2 de diciembre y el 16 de diciembre de 2025 y tuvo como objetivo diseñar la arquitectura general del sistema y seleccionar las tecnologías principales utilizadas durante el desarrollo.

Los objetivos principales fueron:

- Definir la arquitectura general del sistema.
- Diseñar el modelo inicial de datos.
- Seleccionar frameworks y tecnologías base.
- Definir la comunicación entre subsistemas.
- Definir patrones de diseño a utilizar.

=== Detalles de implementación
Durante este sprint se diseñó la arquitectura del sistema, teniendo en cuenta las necesidades y requisitos definidos en el sprint anterior. Debido a la necesidad de aislar las tareas largas y computacionalmente intensivas del backend principal, se optó por una arquitectura distribuida que separa el sistema en dos subsistemas principales:
- Un sistema web encargado de la gestión de usuarios, procesos, almacenamiento y predicciones.
- Un sistema bioinformático encargado de ejecutar las tareas de ensamblaje y anotación.

También se definió un mecanismo de comunicación basado en APIs HTTP y ejecución asíncrona mediante colas de tareas y workers desacoplados, permitiendo separar la gestión de procesos de su ejecución real. Se tomó la decisión de implementar instancias de la cola de tareas y workers específicos para cada subsistema, para así mantener una separación clara entre las tareas relacionadas con el sistema web y las tareas relacionadas con el sistema bioinformático y además poder escalar, desplegar y monitorear cada subsistema de forma independiente según las necesidades del proyecto.

En esta fase se seleccionaron las tecnologías principales utilizadas durante el desarrollo:

- _Django_ para el sistema web.

- _FastAPI_ para el sistema bioinformático.

- _PostgreSQL_ como sistema de persistencia.

- _Celery_ y _Redis_ para la gestión de tareas asíncronas.

- _Docker_ para el despliegue y aislamiento de dependencias.

Adicionalmente, se diseñó el modelo inicial de datos, definiendo entidades relacionadas con usuarios, procesos, archivos y notificaciones, así como las relaciones entre ellas. Finalmente, se evaluaron distintos enfoques de diseño, investigando patrones comunes en sistemas similares, con el objetivo de facilitar la extensibilidad del sistema. Se puso especial énfasis en lo relativo a la integración de nuevos modelos predictivos y mecanismos de generación de características.

=== Resultados
Este sprint fue fundamental para establecer una arquitectura sólida y escalable que permitiera abordar las necesidades específicas del proyecto, especialmente en relación con la ejecución de tareas bioinformáticas. La separación en subsistemas permitió diseñar un sistema más modular y mantenible, facilitando el desarrollo progresivo de funcionalidades en los siguientes sprints.

== Sprint 3 - Desarrollo de la infrastructura base
=== Objetivos
Este sprint se desarrolló entre el 16 de diciembre de 2025 y el 13 de enero de 2026, con el objetivo principal de implementar la infraestructura base del sistema, incluyendo la configuración de la base de datos, la implementación de mecanismos de autenticación y autorización, y la creación de contenedores Docker para facilitar el desarrollo y despliegue del sistema. Los objetivos específicos de este sprint fueron:

- Establecer las bases técnicas para el desarrollo del sistema.
- Configurar la base de datos.
- Implementar mecanismos de autenticación y autorización.
- Configurar contenedores Docker para el desarrollo y despliegue.

=== Detalles de implementación
La principal decisión técnica que ha condicionado el desarrollo de este sprint es la separación entre el sistema web y el sistema bioinformático, definida previamente durante el diseño del sistema. Esta separación condicionó tanto la organización del código como el despliegue de servicios y el mecanismo de ejecución de tareas asíncronas.

==== Organización del proyecto Django

Se inicializó el sistema web utilizando _Django_, organizando la funcionalidad en distintas aplicaciones siguiendo una separación basada en responsabilidades. La división en apps real no coincide exactamente con la descomposición conceptual presentada en la @sec:modulos_web, ya que se ha adaptado a la estructura de _Django_ buscando un equilibrio entre la separación de responsabilidades y la coherencia con el framework utilizado. Las aplicaciones principales definidas fueron:

- `home`: gestión de autenticación, navegación general y página principal.

- `conversion`: gestión de procesos bioinformáticos, comunicación con el sistema bioinformático, almacenamiento de archivos y generación de features.
- `prediction`: ejecución de modelos de predicción y gestión de resultados.
- `notifications`: gestión de notificaciones asociadas al estado de los procesos.

Esta organización permite mantener una separación clara entre las distintas áreas del sistema, encapsulando la lógica específica de cada dominio dentro de su propia aplicación y reduciendo el acoplamiento entre componentes.

==== Configuración de persistencia y almacenamiento
Aunque inicialmente se consideró el uso de _SQLite_ como sistema de persistencia en las primeras fases del desarrollo por su simplicidad, finalmente se optó por hacer uso de _PostgreSQL_ desde el inicio debido a que el acceso a la base de datos de distintos workers podía dar problemas de concurrencia. Así mismo, se optó por esta opción para evitar problemas de migración y compatibilidad que podrían surgir al cambiar de SQLite a PostgreSQL en fases posteriores.

Se definió el modelo de datos inicial utilizando los modelos de _Django_, incluyendo entidades relacionadas con usuarios, procesos, archivos y notificaciones y sus relaciones, especificadas en @sec:modelo_datos.

#todo("Añadir cosas interesantes del modelo de datos tras el cambio")

Por otro lado, debido al gran tamaño de los archivos relacionados con el pipeline genómico (FASTQ, FASTA y JSON) y a las diferencias en su ciclo de vida, se decidió diferenciar entre almacenamiento temporal y persistente, diferenciando:

- *Archivos Temporales*: Los archivos FASTQ utilizados como entrada durante los procesos de ensamblaje se almacenan temporalmente y se eliminan automáticamente tras finalizar el procesamiento para reducir el consumo de espacio. Estos se encuentran almacenados en su propia carpeta temporal `uploads/temp/` durante el procesamiento.

- *Archivos Persistentes*: Archivos FASTA o JSON generados en los procesos de ensamblaje o anotación. Se almacenan en `uploads/persistent/user_{user_id}/{file_type}/`, según el usuario y el tipo de archivo, facilitando búsquedas y gestión.

#todo(
  "Meter una captura ejemplo de la estructura de carpetas de almacenamiento de archivos, diferenciando entre temporales y persistentes",
)

Esta separación permitió optimizar el uso de almacenamiento y simplificar la gestión de resultados a largo plazo.


==== Automatización del entorno de desarrollo
Con el objetivo de simplificar la puesta en marcha del sistema web en desarrollo y reducir la complejidad de la configuración inicial, se desarrolló un script de automatización encargado de instalar dependencias, construir recursos frontend y preparar el entorno de ejecución. Este script, `setup.py`, se encuentra en la raíz del subsistema web y se puede ejecutar con un único comando para configurar el entorno de desarrollo de forma rápida y sencilla.

Este proceso:
- Instala dependencias de Python utilizando `pip` y el archivo `requirements.txt` (@cod:setup.py:10 ).

- Instala dependencias de frontend utilizando `npm` y el archivo `package.json` (@cod:setup.py:16 ).
- Genera los recursos CSS necesarios (@cod:setup.py:22 ).

#figure(
  placement: auto,
  raw(read("/memoria/code/setup.py"), block: true, lang: "python"),
  caption: "Segmento del script de setup.py utilizado para configurar el proyecto",
)<cod:setup.py>

Esto permite realizar la configuración inicial del proyecto de forma rápida con un único comando.

==== Configuración de Docker y despliegue

Por otro lado, para facilitar el despliegue del sistema al completo se utilizó _Docker_ para crear contenedores independientes para cada servicio, permitiendo aislar dependencias y facilitar el despliegue en diferentes entornos. Se definieron entornos independientes para el sistema web y el sistema bioinformático, cada uno con sus propios servicios y dependencias.

- *Sistema Web* (`tfg/docker/docker-compose.yml`):
  - _PostgreSQL_: Base de datos del sistema.
  - _Redis_: Broker de mensajes para Celery.
  - _Web_: Servidor Django.
  - _Celery Worker_: Procesa tareas de conversión y predicción de forma asíncrona.

- *Sistema Bioinformático* (`docker-servicios-bio/docker-compose.yml`): Orquesta los servicios del subsistema bioinformático:
  - _PostgreSQL_: Base de datos de metadatos del servicio.
  - _Redis_: Broker para colas de tareas.
  - _FastAPI_: Servidor API del servicio bioinformático.
  - _Celery Worker Bioinformático_: Procesan tareas de assembly y anotación.
  - _Celery Worker de mantenimiento_: Procesa tareas de limpieza y mantenimiento del servicio.
  - _Celery Beat_: Programador de tareas periódicas.
  - Opcionalmente _Flower_ para monitorización de tareas Celery.

Para la comunicación entre los contenedores, se definieron redes Docker personalizadas, permitiendo que los servicios se comuniquen entre sí utilizando nombres de host definidos en el `docker-compose.yml`.

Por otro lado, se definieron volúmenes Docker para persistir datos importantes, como los archivos de resultados y los datos de la base de datos, asegurando que estos datos no se pierdan al detener o reiniciar los contenedores.

Finalmente, para realizar de forma sencilla el despliegue de ambos sistemas en un entorno de producción, se desarrolló un script de despliegue (`deploy.sh`) que automatiza la construcción de las imágenes Docker y el despliegue de los contenedores.

#todo("Mejorar párrafo final y meter code snippet del script de despliegue cuando esté en Python y no en PowerShell")


==== Ejecución asíncrona

Para coordinar la ejecución de tareas de larga duración se configuró _Celery_ junto con _Redis_. Los workers definidos en cada subsistema permiten ejecutar procesos de forma asíncrona y desacoplada del flujo principal de la aplicación.

En el sistema web los workers monitorizarán el envío de tareas al sistema bioinformático, la monitorización de su estado, la rescuperación de resultados y la ejecución de predicciones.

Por otro lado, en el sistema bioinformático, los workers se encargan de ejecutar las herramientas de ensamblaje y anotación, además de tareas auxiliares de mantenimiento y limpieza.

La separación entre los workers del sistema web y del sistema bioinformático permite escalar ambos subsistemas de forma independiente según la carga de cada uno y permite mantener los dos sistemas totalmente desacoplados.

==== Implementación de autenticación y control de acceso

Aunque la gestión de usuarios no es un punto clave del sistema, se consideró necesario para asociar procesos y reultados a usuarios concretos y permitir un seguimiento individualizado de su progreso. Para ello se decidió utilizar el sistema de autenticación integrado de _Django_, aprovechando sus mecanismos de gestión de usuarios, sesiones y permisos.

Se implementaron funcionalidades de:
- *Registro*: Creación de nuevas cuentas de usuario.
- *Login*: Autenticación de usuarios con email/usuario y contraseña.
- *Logout*: Cierre de sesión.

Esto permitió restringir el acceso a procesos y resultados únicamente a sus propietarios.

=== Resultados

En este sprint se estableció la infraestructura técnica fundamental del sistema, permitiendo el desarrollo de funcionalidades posteriores. La separación en subsistemas independientes mediante Docker y la comunicación HTTP REST proporciona escalabilidad y mantenibilidad. La utilización de Celery con Redis permite procesar tareas largas sin bloquear el sistema web, mientras que la arquitectura modular de Django facilita la extensión futura del sistema con nuevas aplicaciones y funcionalidades.

== Sprint 4 - Servicio de conversión de datos genómicos
=== Objetivos
Este sprint se desarrolló entre el 13 y el 27 de enero de 2026 y tuvo como objetivo implementar el subsistema bioinformático encargado de ejecutar los procesos de ensamblaje y anotación, así como la integración inicial entre dicho subsistema y el sistema web. Los objetivos principales son:

- Implementar el sistema bioinformático desacoplado del sistema web.
- Integrar herramientas externas de ensamblaje y anotación.
- Diseñar la API de comunicación entre subsistemas.
- Implementar la ejecución asíncrona de los procesos bioinformáticos.
- Gestionar el almacenamiento y la recuperación de resultados.

=== Detalles de implementación

==== Implementación del subsistema bioinformático

El sistema bioinformático se desarrolló como un servicio independiente usando _FastAPI_ y _Celery_. Este subsistema actúa como responsable de la ejecución de herramientas bioinformáticas externas, desacoplando las tareas de análisis genómico del backend principal del sistema web.

La separación de ambos subsistemas permitió aislar las dependencias específicas de las herramientas bioinformáticas, los elevados requisitos computacionales y los largos tiempos de ejecución asociados a los procesos de ensamblaje y anotación. Además, este enfoque facilita la escalabilidad del sistema y recude el impacto de posibles errores producidos durante la ejecución de herramientas externas.

Internamente, el sistema bioinformático se estructura en tres componentes principales:

- Una API HTTP encargada de recibir solicitudes de ejecución desde el sistema web (`app.py`).
- Un sistema de workers asíncronos responsable de ejecutar los procesos bioinformáticos, integrados con las herramientas externas (`task.py`).
- Un módulo de utilidades para la gestión de los procesos (`utils.py`).

Las herramientas bioinformáticas se integraron mediante la ejecución de procesos externos desde Python utilizando el módulo `subprocess`. Este enfoque permite encapsular la lógica de invocación de cada herramienta y controlar parámetros de ejecución, directorios de salida y gestión de errores de forma homogénea.

===== Integración de herramientas de ensamblaje
El sistema se disñó para soportar distintos tipos de tecnologías de secuenciación, integrando diferentes herramientas de ensamblaje según el tipo de lecturas utilizadas. Para secuenciación de lecturas cortas (_Illumina_) se integró _SPAdes_, mientras que para secuenciación de lecturas largas (_ONT_) se integraron _Flye_ y _Raven_. En todos los casos, la integración sigue una estructura similar:

1. Asegurar que la herramienta se encuentra instalada.

2. Validar los parámetros de entrada.
3. Generar el comando de ejecución con los parámetros adecuados.
4. Ejecutar el comando utilizando `subprocess` y monitorizar su progreso.
5. Almacenar los resultados generados y los logs de ejecución.

Un ejemplo simplificado de la integración de _SPAdes_ se muestra en @cod:spades.py.

#figure(
  placement: auto,
  raw(read("/memoria/code/spades.py"), block: true, lang: "python"),
  caption: "Segmento del código de integración de la herramienta de ensamblaje SPAdes dentro del sistema bioinformático",
)<cod:spades.py>

De forma similar, se implementó la integración de las herramientas _Flye_ y _Raven_, adaptando los parámetros de ejecución a las características específicas de cada ensamblador. Un ejemplo simplificado de la integración de _Flye_ se muestra en @cod:flye.py, mientras que un ejemplo de la integración de _Raven_ se muestra en @cod:raven.py.

#figure(
  placement: auto,
  raw(read("/memoria/code/flye.py"), block: true, lang: "python"),
  caption: "Segmento del código de integración de la herramienta de ensamblaje Flye dentro del sistema bioinformático",
)<cod:flye.py>

#figure(
  placement: auto,
  raw(read("/memoria/code/raven.py"), block: true, lang: "python"),
  caption: "Segmento del código de integración de la herramienta de ensamblaje Raven dentro del sistema bioinformático",
)<cod:raven.py>

===== Integración de herramientas de anotación
Respecto a la etapa de anotación, se integró la herramienta _Bakta_, especializada en anotación automática de genomas bacterianos. Esta herramienta requiere una base de datos externa de gran tamaño, necesaria para realizar búsquedas y anotaciones genómicas. Para evitar incluir dicha base de datos dentro de la imagen _Docker_ del servicio, se decidió desacoplarla mediante volúmenes montados durante el despliegue. Esta decisión reduce significativamente el tamaño de las imágenes, evita descargas repetidas y facilita tanto la actualización de la base de datos como la utilización de variantes ligeras como _bakta-light_.

Un ejemplo simplificado del comando utilizado para la ejecución de Bakta se muestra en @cod:bakta.py.

#figure(
  placement: auto,
  raw(read("/memoria/code/bakta.py"), block: true, lang: "python"),
  caption: "Segmento del código de integración de la herramienta de anotado Bakta dentro del sistema bioinformático",
)<cod:bakta.py>

===== Gestión de archivos y directorios
Finalmente, se implementó un sistema de gestión de directorios temporales y persistentes para aislar la ejecución de cada proceso bioinformático. Cada tarea dispone de un directorio de trabajo independiente donde se almacenan archivos intermedios, logs y resultados generados durante la ejecución. Esto facilita tanto la recuperación de errores como la limpieza automática de datos temporales una vez finalizado el procesamiento.

==== Diseño de la API de comunicación entre subsistemas

La comunicación entre el sistema web y el sistema bioinformático se implementó mediante una API REST sobre HTTP. Esta API permite desacoplar completamente ambos subsistemas y facilita la evolución independiente de cada uno. El sistema bioinformático expone los endpoints mostrados en la @table:endpoints_bio, que permiten iniciar procesos de ensamblaje y anotación, consultar su estado y recuperar resultados. Cada endpoint se diseñó siguiendo principios RESTful, utilizando métodos HTTP adecuados para cada operación y estructurando las URLs de forma clara y consistente.

#include "../tables/endpoints_bio.typ"

Cada proceso de ensamblaje o anotación se identifica mediante un UUID único que permite sincronizar el estado entre ambos subsistemas. Un ejemplo simplificado de endpoint utilizado para iniciar procesos de ensamblaje se muestra en @cod:bio_endpoint.py.

#figure(
  placement: auto,
  raw(read("/memoria/code/bio_endpoint.py"), block: true, lang: "python"),
  caption: "Ejemplo del código de la API del sistema bioinformático",
)<cod:bio_endpoint.py>

==== Integración con el sistema web

La integración del sistema web con el sistema bioinformático se
implementó mediante una capa de servicios encargada de encapsular las llamadas HTTP. La comunicación con el sistema bioinformático se encapsuló en una capa de servicios implementada en el archivo `bio_api_client.py`, encargada de abstraer las llamadas HTTP y unificar la interacción con la API externa, siguiendo un patrón fachada. Se puede ver un ejemplo en @cod:bioapiclient.

#figure(
  placement: auto,
  raw(read("/memoria/code/bio_api_client.py"), block: true, lang: "python"),
  caption: "Ejemplo del código de la capa de servicios encargada de la comunicación con el sistema bioinformático",
)<cod:bioapiclient>

Las tareas asíncronas del sistema web, definidas en `tasks.py`, utilizan este cliente para inciar procesos de ensamblaje o anotación en el subsistema bioinformático, consultar el estado de los procesos y recuperar resultados.

La ejecución de procesos se realiza mediante tareas _Celery_, permitiendo que el usuario continúe interactuando con la aplicación mientras los procesos bioinformáticos se ejecutan en segundo plano.

==== Monitorización y flujo de procesos

Uno de los principales retos de la integración es la sincronización del estado de procesos de larga duración entre ambos subsistemas. Debido a que las tareas de ensamblaje y anotación pueden prolongarse varios minutos o incluso horas, no es adecuado mantener conexiones HTTP persistentes entre ambos sistemas. Para abordar este problema se implementó un mecanismo de monitorización basado en polling periódico desde los workers del sistema web.

Una vez dada la orden de iniciar una tarea bioinformática, se almacena el identificador del proceso remoto en la base datos del sistema web. A partir de ese momento, un worker consulta periódicamente el estado del proceso mediante llamadas HTTP a la API bioinformática. Un ejemplo simplificado del mecanismo de polling implementado se muestra en @cod:polling.py.

#figure(
  placement: auto,
  raw(read("/memoria/code/polling.py"), block: true, lang: "python"),
  caption: "Mecanismo de polling implementado para monitorizar el estado de los procesos bioinformáticos desde el sistema web",
)<cod:polling.py>

Cuando el estado del proceso cambia, el worker actualiza la información asociada en la base de datos del sistema web y coordina la recuperación de resultados, la generación de notificaciones y la gestión del ciclo de vida de los archivos temporales y persistentes. Este enfoque permite mantener sincronizados ambos subsistemas sin bloquear la aplicación web ni depender de conexiones persistentes de larga duración.

=== Resultados
Durante este sprint se implementó la funcionalidad clave del pipeline bioinformático del sistema, incluyendo tanto el sistema bioinformático como su integración con el sistema web. La independencia de ambos subsistemas permitió ejecutar procesos de ensamblaje y anotación de forma desacoplada y asíncrona, sentando las bases para la integración posterior de generación de features y la integración de modelos de predicción.

== Sprint 5 - Integración y generación de features

=== Objetivos
Este sprint se desarrolló entre el 27 de enero y el 10 de febrero de 2026, con el objetivo principal de implementar el procesamiento de los resultados de anotación y su transformación en características estructuradas utilizables por el sistema de predicción. Adicionalmente, se buscaba implementar el diseño de la arquitectura desacoplada orientada a facilitar la incorporación futura de nuevos formatos y herramientas bioinformáticas. Los objetivos específicos de este sprint fueron:

- Procesar los resultados generados durante la anotación genómica.
- Diseñar un sistema de generación de features reutilizable y extensible.
- Persistir la información genómica relevante en la base de datos.
- Integrar la generación de features dentro del flujo asíncrono del sistema.
- Facilitar la incorporación futura de nuevos parsers y formatos de anotación.

=== Detalles de implementación
==== Procesamiento y persistencia de resultados anotados
Una vez finalizado el proceso de anotación, el sistema bioinformático genera distintos archivos que contienen información sobre genes, proteínas y otros elementos genómicos identificados durante el análisis. Para que esta información pudiera ser utilizada posteriormente por el sistema de predicción, se decidió transformarla en información estructurada persistible dentro de la base de datos del sistema web.

Inicialmente, se optó por trabajar con las salidas JSON generadas por _Bakta_, debido a su estructura jerárquica y facilidad de procesamiento desde Python. Un ejemplo simplificado del parser implementado se muestra en @cod:parser.py.

#figure(
  placement: auto,
  [
    #set text(size: 12pt)
    #raw(read("/memoria/code/parser.py"), block: true, lang: "python")
  ],
  caption: "Ejemplo simplificado de parser de JSON generado por Bakta",
)<cod:parser.py>

A partir de los resultados se decidió extraer las siguientes características relevantes para la posterior generación de features y predicción de resistencia. Entre ellas destacan:

- *Identificadores asociados al gen* (`identifiers`),incluyendo:
  - El nombre asociado al gen (`gene`, @cod:parser.py:5).
  - Referencias externas (`db_xrefs`, @cod:parser.py:6).
  - El nombre del producto asociado (`product`, @cod:parser.py:7).

- *Información del sistema experto de anotación*: incluyendo:
  - El campo del experto (`expert_field`, @cod:parser.py:25).
  - El tipo del experto (`expert_type`, @cod:parser.py:26).

Además, el sistema permite opcionalmente realizar una extracción más exhaustiva de las *características de la secuencia genética*:
- Posición inicial (`start`, @cod:parser.py:31).
- Posición final (`end`, @cod:parser.py:32).
- Secuencia nucleotídica (`nt`, @cod:parser.py:33).
- Secuencia aminoacídica (`aa`, @cod:parser.py:34).

Dichas características, se almacenan asociadas al proceso de anotación correspondiente a través de los modelos `Gene` y `FileGene`. El modelo `Gene` representa la información global asociada a un gen identificado, mientras que `FileGene` modela la relación entre un gen concreto y un archivo o proceso de anotación específico.

Adicionalmente, para el modelo `Gene` se implementó un queryset personalizado que permite recuperar genes de forma sencilla utilizando cualquiera de sus identificadores asociados. Esto facilita la búsqueda de información relacionada con un gen independientemente del nombre concreto utilizado por distintas herramientas bioinformáticas o modelos de predicción. Un extracto de código de dicho queryset se encuentra en @cod:gene_queryset.py.

#figure(
  placement: auto,
  [
    #set text(size: 12pt)
    #raw(read("/memoria/code/gene_queryset.py"), block: true, lang: "python")
  ],
  caption: "Queryset personalizado para el modelo Gene",
)<cod:gene_queryset.py>

==== Arquitectura modular de parsers
Como punto de extensión adicional del sistema y con el objetivo de facilitar la incorporación futura de nuevas herramientas bioinformáticas y formatos de salida, se decidió desacoplar la lógica de extracción de features mediante un mecanismo basado en parsers. Este enfoque permite definir un parser para cada tipo de salida bioinformática, evitando acoplar el pipeline de generación de features a una herramienta bioinformática concreta y permitiendo extender el sistema sin modificar la lógica principal de procesamiento.

Se definió la clase base `BaseParser` que establece la interfaz común para todos los parsers (@cod:base_parser.py). Esta clase define el método `parse`, que debe ser implementado por cada parser concreto para transformar los resultados de la anotación en estructuras procesables por el sistema.

#figure(
  placement: auto,
  [
    #set text(size: 12pt)
    #raw(read("/memoria/code/base_parser.py"), block: true, lang: "python")
  ],
  caption: "Clase base para los parsers",
)<cod:base_parser.py>

para facilitar la extensibilidad del sistema, se implementó un mecanismo de registro automático basado en el patrón _Registry_ (@cod:parser_registry.py). Este mecanismo permite registrar automáticamente nuevos parsers mediante decoradores, evitando configuraciones manuales.

#figure(
  placement: auto,
  [
    #set text(size: 12pt)
    #raw(read("/memoria/code/parser_registry.py"), block: true, lang: "python")
  ],
  caption: "Registro de parsers",
)<cod:parser_registry.py>

Cada parser se registra utilizando un identificador único que posteriormente permite su resolución dinámica dentro del flujo de generación de features. Un ejemplo simplificado de implementación de parser se muestra en @cod:parser_decorator.py.

#figure(
  placement: auto,
  [
    #set text(size: 12pt)
    #raw(read("/memoria/code/parser_decorator.py"), block: true, lang: "python")
  ],
  caption: "Ejemplo de implementación de un parser concreto utilizando el sistema de registro mediante decoradores",
)<cod:parser_decorator.py>

El sistema de parsers combina el mecanismo de registro automático con un enfoque inspirado en el patrón _Strategy_ (@cod:parser_strategy.py). Cada parser implementa una interfaz común de procesamiento (`parse_file`), permitiendo intercambiar dinámicamente distintos algoritmos de extracción de features (parsers) según el tipo de resultado bioinformático recibido. La selección del parser concreto se realiza mediante resolución dinámica basada en identificadores registrados, desacoplando completamente la lógica de selección de la implementación concreta del parser.

#figure(
  placement: auto,
  [
    #set text(size: 12pt)
    #raw(read("/memoria/code/parser_strategy.py"), block: true, lang: "python")
  ],
  caption: "Interfaz Strategy para los parsers",
)<cod:parser_strategy.py>

==== Integración con el flujo de procesamiento
Finalmente, la generación de features se integró dentro del flujo asíncrono de anotado del sistema web. Una vez finalizado el proceso de anotación en el sistema bioinformático, el worker encargado de monitorizar el estado del proceso detecta la finalización de la tarea y recupera automáticamente los resultados generados. A continuación, se inicia el proceso de generación de features utilizando el sistema de parsers definido previamente. Esto permite automatizar completamente la transición entre la etapa de anotación y la posterior fase de predicción.

Adicionalmente, se incorporó la posibilidad de realizar una extracción de las características desde archivos externos de anotación previamente generados. De este modo, el usuario puede cargar un archivo JSON generado por _Bakta_ y reutilizar resultados de anotación existentes sin necesidad de ejecutar nuevamente el pipeline bioinformático completo.

=== Resultados
A lo largo de este sprint se implementó la generación automática de features a partir de los resultados de anotación genómica, así como una arquitectura modular y extensible de parsers. La integración de esta funcionalidad dentro del flujo de procesamiento del sistema web permitió automatizar completamente la transición entre la etapa de anotación y la posterior fase de predicción. Además, el soporte para archivos externos de anotación permite al usuario final reutilizar resultados previamente generados sin necesidad de ejecutar nuevamente las herramientas bioinformáticas, aumentando la flexibilidad del sistema.

== Sprint 6 - Módulo de predicción de resistencia
=== Objetivos
Este sprint se desarrolló entre el 10 de febrero y el 3 de marzo de 2026 y tuvo como objetivo implementar el módulo encargado de realizar predicciones de resistencia a antibióticos a partir de las características almacenadas en base de datos durante las etapas anteriores del pipeline. Los objetivos principales de este sprint fueron:

- Implementar el pipeline de predicción de resistencia a antibióticos.
- Integrar modelos de machine learning dentro del sistema web.
- Ofrecer utilidades para la transformación de features al formato de entrada de los modelos.

=== Detalles de implementación

==== Implementación de modelos de predicción
Para la versión propia del sistema y a modo de ejemplo, se decidió implementar el flujo básico de predicción para dos modelos proporcionados por el equipo de investigación, el modelo `base_bakta_50` y el modelo `base_bakta_90`. Se trata de dos modelos similares por lo que comentaremos la implementación del primero, definido en el archivo `model_classes.py` (@cod:base_bakta_50.py).

#figure(
  placement: auto,
  raw(read("/memoria/code/base_bakta_50.py"), block: true, lang: "python"),
  caption: "Modelo de predicción base_bakta_50",
)<cod:base_bakta_50.py>

El modelo `base_bakta_50` es un modelo de machine learning específico, diseñado para realizar predicciones de resistencia a antibióticos a partir de una lista de presencia/ausencia de genes relevantes para la resistencia.

Para obtener las features se definió el método `features()` (@cod:bakta_50_features.py). El modelo `bakta_50` se entrenó para receibir como inputs genes específicos que vienen dados en un archivo de pickle. Por lo tanto, sacamos los nombres de los genes del archivo y los procesamos para añadir los identificadores de la base de datos corresponsiente para poder identificarlos correctamente en nuestro sistema (@cod:bakta_50_features.py:10).

#figure(
  placement: auto,
  raw(read("/memoria/code/bakta_50_features.py"), block: true, lang: "python"),
  caption: "Definición de las features utilizadas por el modelo base_bakta_50",
)<cod:bakta_50_features.py>

Por otro lado, para la carga del modelo se definió el método `load()` (@cod:bakta_50_load.py), encargado de cargar los pesos del modelo para el antibiótico específico desde los archivos de pesos y cambiar el modelo a modo evaluación. En este método se llama al método features para cargar los nombres de los genes en las variables internas del modelo.

#figure(
  placement: auto,
  raw(read("/memoria/code/bakta_50_load.py"), block: true, lang: "python"),
  caption: "Definición del método de carga para el modelo base_bakta_50",
)<cod:bakta_50_load.py>

Finalmente, se definió un método `predict()` (@cod:bakta_50_predict.py) encargado de realizar la predicción a partir de las características obtenidas, devolviendo un valor numérico que representa la probabilidad de resistencia a un antibiótico específico. Dentro de este método se calculan las features de presencia y ausencia haciendo uso de las funciones auxilares explicadas en la próxima sección.

#figure(
  placement: auto,
  raw(read("/memoria/code/bakta_50_predict.py"), block: true, lang: "python"),
  caption: "Definición del método de predicción para el modelo base_bakta_50",
)<cod:bakta_50_predict.py>

==== Utilidades de transformación de features

Para facilitar la transformación de las características almacenadas en la base de datos al formato requerido por los distintos modelos de predicción, se implementó un conjunto de utilidades de transformación en el archivo `input_utils.py`.

El objetivo es que en la definición de cada modelo se puedan utilizar las utilidades de transformación de forma automática, ocultando la complejidad de algunas de las funciones más comunes.

Para la transformación, muchos de los modelos estudiados requiere como input la ausencia o presencia de ciertos genes en la muestra. Por esto se definió la función `presence_from_list(model_feature, file_upload)` (@cod:model_utils_presence.py), encargada de calcular la presencia o ausencia de genes a partir de los resultados almacenados en la base de datos, devolviendo un vector binario que indica la presencia o ausencia de cada gen relevante para el modelo normalizado. El método devuelve una lista de valores binarios con un elemento por cada gen en `model_features`, indicando el 1 presencia y el 0 ausencia del mismo en la muestra.

#figure(
  placement: auto,
  raw(read("/memoria/code/model_utils_presence.py"), block: true, lang: "python"),
  caption: "Función de cálculo de presencia o ausencia de genes a partir de los resultados almacenados en la base de datos",
)<cod:model_utils_presence.py>

Por otro lado, se definió la función `get_columns_from_pickle`

"""
Load column names from a pickle file for a given model.
Args:
model_name: name of the model (used to locate the correct directory)
column_file_name: name of the pickle file containing the columns (e.g. 'columns.pkl')
Returns:
A list of column names loaded from the pickle file.
"""

#figure(
  placement: auto,
  raw(read("/memoria/code/model_utils_pickle.py"), block: true, lang: "python"),
  caption: "Función de carga de archivos de pickle con información relevante para la generación de features",
)<cod:model_utils_pickle.py>





==== Integración con el flujo de procesamiento

La predicción de resistencia se integró dentro del flujo asíncrono del sistema. Una vez finalizada la generación de features, el usuario puede enviar el proceso para predicción, lo que inicia una tarea Celery que:

1. Obtiene las características asociadas al proceso de anotación desde la base de datos.
2. Carga dinámicamente el modelo de predicción solicitado mediante el mecanismo de registro.
3. Transforma las características al formato requerido por el modelo.
4. Ejecuta la predicción y almacena los resultados.
5. Genera notificaciones informando al usuario sobre la finalización del proceso.

Este enfoque permite desacoplar completamente el pipeline de predicción de los modelos específicos utilizados, facilitando la extensión del sistema con nuevos modelos en el futuro.

=== Resultados
- Pipleine de predicción de resistencia
- Integración de modelo


== Sprint 7 - Arquitectura modular para modelos de predicción
=== Objetivos
Este sprint se desarrolló entre el 3 y el 17 de marzo de 2026 y tuvo como objetivo refinar la arquitectura de modelos de predicción, optimizar el rendimiento del sistema y preparar la integración con la interfaz de usuario. Los objetivos principales fueron:

- Implementar un mecanismo de registro automático de modelos mediante decoradores.
- Definición de adaptadores para los modelos.
- Validar la integridad de los adaptadores de modelos durante el registro.
- Validar la compatibilidad de los modelos con los distintos antibióticos.

=== Detalles de implementación

==== Arquitectura modular de modelos de predicción
Con el objetivo de cumplir con los requisitos de extensibilidad y facilitar la incorporación futura de nuevos modelos de predicción, se implementó la arquitectura modular definida para los modelos de predicción, siguiendo un enfoque basado en los patrones _Registry_ y _Strategy_. El mecanismo final es similar al implementado para los parsers, permitiendo registrar nuevos modelos de forma automática mediante decoradores y seleccionar dinámicamente el modelo concreto a utilizar en función de la configuración del proceso de predicción.

Primero, se definió una clase base `ModelInterface`que establece la interfaz común para loas adaptadores de todos los modelos de predicción, definiendo los métodos que deben ser implementados por cada modelo concreto para realizar predicciones a partir de las características almacenadas en la base de datos (@cod:model_interface.py). Patrón _Adapter_ (decir algo más).

#figure(
  placement: auto,
  raw(read("/memoria/code/model_interface.py"), block: true, lang: "python"),
  caption: "Clase base para los modelos de predicción",
)<cod:model_interface.py>

En la interfaz se definen tres métodos:

- `features(file_upload)` - (@cod:model_interface.py:3): Dado un archivo de subida persistido en base de datos (`FileUpload`), devuelve las características necesarias para realizar la predicción (por ejemplo, una lista de genes presentes o ausentes).

- `load()` - (@cod:model_interface.py:6): Carga los pesos del modelo y realiza cualquier preparación necesaria para la ejecución de predicciones.
- `predict(file_upload)` - (@cod:model_interface.py:9): Realiza la predicción de resistencia a antibióticos a partir de las características asociadas al archivo de subida proporcionado, devolviendo un valor numérico que representa la probabilidad de resistencia.

A continuación, se implementó un mecanismo de registro automático para los modelos de predicción, siguiendo el patrón _Registry_ de forma similar al utilizado para los parsers. Este mecanismo permite registrar nuevos modelos mediante decoradores, evitando configuraciones manuales y facilitando la extensión del sistema con nuevos modelos de forma sencilla (@cod:model_registry.py).

#figure(
  placement: auto,
  raw(read("/memoria/code/model_registry.py"), block: true, lang: "python"),
  caption: "Registro de modelos de predicción",
)<cod:model_registry.py>

Se definieron dos diccionarios con los modelos y sus clases y los antibioticos a los que dan soporte, que se populan al iniciar la aplicación de froma automátcia gracias al decorador definido en @cod:model_registry.py:22. Al decorador se le puede pasar un identificador que mostrará a los usuarios en el sistema final así como se usará de forma interna patra identificar al modelo. Adicionalmente, en el resgistro se computan los antibióticos que están disponibles para cada modelo a partir de los archivos de pesos asociados a cada modelo, lo que permite mostrar esta información de forma dinámica en la interfaz de usuario y evitar errores de configuración.

Además, para asegurar la integridad de las clases y los métodos de los adaptadores se definió un validador que se ejecuta durante el registro de cada modelo, verificando que la clase implementa correctamente la interfaz definida en `ModelInterface`, que los métodos necesarios están presentes y proporciona el nombre de la clase como identificador para el modelo si no se ha definido uno en el decorador (@cod:model_registry.py:9).


#figure(
  placement: auto,
  raw(read("/memoria/code/model_registry_utils.py"), block: true, lang: "python"),
  caption: "Registro de modelos de predicción",
)<cod:model_registry_utils.py>


Por otro lado, inspirado en el patrón _Strategy_ se definió un mecanismo de selección dinámica del modelo concreto a utilizar en función de la configuración del proceso de predicción. Esto permite intercambiar distintos modelos de predicción simplemente llamando a una función con distintos parámetros. El código se puede ver en @cod:model_predict.py, donde se define la función `get_prediction` que recibe como parámetro el nombre del modelo a utilizar, el antibiótico y el archivo de subida asociado al proceso de predicción, resolviendo dinámicamente la clase del modelo a utilizar a través del mecanismo de registro y ejecutando las funciones de carga (`load()`) y predicción (`predict()`) de forma transparente para el usuario.

#figure(
  placement: auto,
  raw(read("/memoria/code/model_predict.py"), block: true, lang: "python"),
  caption: "Llamada única de predicción",
)<cod:model_predict.py>


==== Instrucciones de integración de nuevos modelos

Se definió el módulo `ai_models`.

gracias a todos los mecanismos definidos, la integración de nuevos modelos de predicción se reduce a implementar una clase que herede de `ModelInterface`, implementando los métodos necesarios para la transformación de características, carga de pesos y ejecución de predicciones, y decorarla con el decorador de registro definido en @cod:model_registry.py.

En este sprint se formalizó completamente la arquitectura modular de modelos de predicción, consolidando el mecanismo de registro automático y validación de adaptadores. Se desarrolló el módulo `ai_models` para la administración centralizada de los modelos de aprendizaje automático, incluyendo:

- Una estructura de directorios estandarizada para cada modelo, con carpetas `pesos/` conteniendo archivos `.pt` con los pesos por antibiótico.
- Un sistema de validación que verifica la correctitud de cada adaptador durante el registro, incluyendo la verificación de la firma de métodos y la implementación de la interfaz `ModelInterface`.
- Un mecanismo de descubrimiento dinámico de antibióticos soportados por cada modelo, leyendo automáticamente los archivos de pesos disponibles.
- Utilidades para la transformación de características genómicas al formato específico requerido por cada modelo.

La estructura estándar definida para cada modelo simplifica significativamente la incorporación de nuevos modelos:

```
ai_models/<model_name>/
    pesos/
        <antibiotic>.pt
    model_classes.py
```

Donde `model_classes.py` debe exponer la arquitectura del modelo y la clase adaptadora que implementa la interfaz de predicción, registrada mediante el decorador `@register_model("alias")`.

==== Adaptación de los modelos existentes

Para aplicar este modelo se definió un adaptador encargado de transformar las características almacenadas en la base de datos al formato de entrada requerido por el modelo. Este adaptador se implementó como una clase concreta que hereda de una interfaz común definida para los adaptadores de modelos, siguiendo un enfoque inspirado en el patrón _Adapter_. Un ejemplo simplificado del adaptador implementado se muestra en PATATA.

=== Resultados

En este sprint se consolidó la arquitectura modular de modelos de predicción, estableciendo:

- Un sistema robusto de registro automático de modelos con validación de integridad.
- Una estructura estándar para la incorporación de nuevos modelos que minimiza la configuración manual.
- Un mecanismo de descubrimiento dinámico de funcionalidades (antibióticos soportados) que facilita la exposición en la interfaz de usuario.
- Dos modelos de predicción completamente funcionales (`base_bakta_50` y `base_bakta_90`) listos para uso en producción.


== Sprint 8 - Interfaz de usuario y notificaciones

=== Objetivos

=== Detalles de implementación

=== Resultados

== Sprint 9 - Integración del sistema, pruebas y validación

=== Objetivos

=== Detalles de implementación

=== Resultados

== Sprint 10 - Memoria, ajustes finales y puesta en producción

=== Objetivos

=== Detalles de implementación

=== Resultados


== Conclusiones

