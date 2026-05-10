#import "../utils/todo.typ": todo
= Implementación
<sec:implementación>

== Introducción

En este capítulo se aborda el proceso de implementación del sistema desarrollado en este trabajo, organizado de forma incremental mediante distintos sprints. A lo largo de estos sprints se abordaron tanto la definición de la arquitectura y la infraestructura base del sistema como la implementación progresiva de las funcionalidades relacionadas con el análisis genómico y la predicción de resistencia a antibióticos.

Para cada sprint se describen los objetivos planteados, las principales decisiones técnicas adoptadas, los problemas encontrados durante el desarrollo y los resultados obtenidos.


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

También se identificó la necesidad de desacoplar la ejecución de tareas bioinformáticas del sistema web principal debido al elevado tiempo de ejecución y consumo de recursos de las herramientas de ensamblaje y anotación. Esto llevó a definir dos subsistemas separados dentro del proyecto: el sistema web principal y el sistema bioinformático encargado de ejecutar las tareas de procesamiento genómico.

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
Durante este sprint se diseñó la arquitectura del sistema, teniendo en cuenta las necesidades y requisitos definidos en el sprint anterior. Debido a la naturaleza computacionalmente intensiva de las tareas de procesamiento genómico, se optó por una arquitectura distribuida que separa el sistema en dos subsistemas principales:
- Un sistema web encargado de la gestión de usuarios, procesos, almacenamiento y predicciones.
- Un sistema bioinformático encargado de ejecutar las tareas de ensamblaje y anotación.

Esta separación surgió como respuesta a la necesidad de aislar las tareas largas y computacionalmente intensivas del backend principal, evitando que las tareas de larga duración afectasen a la capacidad de respuesta del sistema web.

También se definió un mecanismo de comunicación basado en APIs HTTP y ejecución asíncrona mediante colas de tareas y workers desacoplados, permitiendo separar la gestión de procesos de su ejecución real. Se tomó la decisión de implementar instancias de la cola de tareas y workers específicos para cada subsistema, para así mantener una separación clara entre las tareas relacionadas con el sistema web y las tareas relacionadas con el sistema bioinformático y además poder escalar, desplegar y monitorear cada subsistema de forma independiente según las necesidades del proyecto.

En esta fase se seleccionaron las tecnologías principales utilizadas durante el desarrollo:

- _Django_ para el sistema web.

- _FastAPI_ para el sistema bioinformático.

- _PostgreSQL_ como sistema de persistencia.

- _Celery_ y _Redis_ para la gestión de tareas asíncronas.

- _Docker_ para el despliegue y aislamiento de dependencias.

Adicionalmente, se diseñó el modelo inicial de datos, definiendo entidades relacionadas con usuarios, procesos, archivos y notificaciones, así como las relaciones entre ellas. Finalmente, se evaluaron distntos enfoques de diseño, investigando patrones comunes en sistemas similares, con el objetivo de facilitar la extensibilidad del sistema. , especialmente en lo relativo a la integración de nuevos modelos predictivos y mecanismos de generación de características.

=== Conclusiones
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

Se inicializó el sistema web utilizando _Django_, organizando la funcionalidad en distintas aplicaciones siguiendo una separación basada en responsabilidades. La división en apps real no coincide exactamente con la descomposición conceptual presentada en @sec:modulos_web, ya que se ha adaptado a la estructura de _Django_ buscando un equilibrio entre la separación de responsabilidades y la coherencia con el framework utilizado.

Las aplicaciones principales definidas fueron:
- `home`: gestión de autenticación, navegación general y página principal.
- `conversion`: gestión de procesos bioinformáticos, comunicación con el sistema bioinformático, almacenamiento de archivos y generación de features.
- `prediction`: ejecución de modelos de predicción y gestión de resultados.
- `notifications`: gestión de notificaciones asociadas al estado de los procesos.

Esta organización permite mantener una separación clara entre las distintas áreas del sistema, encapsulando la lógica específica de cada dominio dentro de su propia aplicación y reduciendo el acoplamiento entre componentes.

==== Configuración de persistencia y almacenamiento
Aunque inicialmente se consideró el uso de _SQLite_ como sistema de persistencia en las primeras fases del desarrollo por su simplicidad, finalmente se optó por hacer uso de _PostgreSQL_ desde el inicio debido a que el acceso a la base de datos de distintos workers podía dar problemas de concurrencia. ASí mismo, se optó por esta opción para evitar problemas de migración y compatibilidad que podrían surgir al cambiar de SQLite a PostgreSQL en fases posteriores.

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

=== Conclusiones

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
1. Asegurar que a herramienta se encuentra instalada.
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

#todo("A lo mejor Dani me puede dar alguna clave de extra para esta sección, que he ido un poco a ojo")

==== Diseño de la API de comunicación entre subsistemas

La comunicación entre el sistema web y el sistema bioinformático se implementó mediante una API REST sobre HTTP. Esta API permite desacoplar completamente ambos subsistemas y facilita la evolución independiente de cada uno. El sistema bioinformático expone endpoints para:

#todo("Arreglar el formato de la tabla, es demasiado alta para una única página y la parte de abajo peta")

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

=== Conclusiones
Durante este sprint se implementó la funcionalidad clave del pipeline bioinformático del sistema, incluyendo tanto el sistema bioinformático como su integración con el sistema web. La independencia de ambos subsistemas permitió ejecutar procesos de ensamblaje y anotación de forma desacoplada y asíncrona, sentando las bases para la integración posterior de generación de features y la integración de modelos de predicción.

== Sprint 5 - Integración y generación de features

[5], [27/01-10/02 2026], [Procesamiento y parseo de datos anotados y almacenamiento en base de datos],
=== Objetivos
- Objetivo 1
- Objetivo 2

=== Detalles de implementación
Como se ha llevado a cabo, etc.

=== Conclusiones

- Parseo de resultados
- Persistencia en base de datos



== Sprint 6 - Módulo de predicción de resistencia

[6], [10/02-03/03 2026], [Desarrollo del módulo de predicción de resistencia mediante ML],
=== Objetivos
- Objetivo 1
- Objetivo 2

=== Detalles de implementación
Como se ha llevado a cabo, etc.

=== Conclusiones
- Pipleine de predicción de resistencia
- Integración de modelo


== Sprint 7 - Arquitectura modular para modelos de predicción

Adicionalmente, se definió el módulo `ai_models`, para la administración aislada de los modelos de aprendizaje automático.

[7], [03/03-17/03 2026], [Diseño e implementación de arquitectura modular para modelos de predicción],
=== Objetivos
- Objetivo 1
- Objetivo 2

=== Detalles de implementación
Como se ha llevado a cabo, etc.

=== Conclusiones

- Arquitectura de modelos
- Registro automático de modelos


== Sprint 8 - Interfaz de usuario y notificaciones

[8], [17/03-14/04 2026], [Desarrollo de la interfaz de usuario y sistema de notificaciones],
=== Objetivos
- Objetivo 1
- Objetivo 2

=== Detalles de implementación
Como se ha llevado a cabo, etc.

=== Conclusiones

- Pantallas de conversión de datos genómicos
- Notificaciones y seguimiento
- Pantalla de predicción


== Sprint 9 - Integración del sistema, pruebas y validación

[9], [14/04-21/04 2026], [Integración del sistema, pruebas y validación],
=== Objetivos
- Objetivo 1
- Objetivo 2

=== Detalles de implementación
Como se ha llevado a cabo, etc.

=== Conclusiones

- Integración del sistema
- Pruebas y validación


== Sprint 10 - Memoria, ajustes finales y puesta en producción

[10], [21/04-12/05 2026], [Redacción de la memoria, ajustes finales y puesta en producción],
=== Objetivos
- Objetivo 1
- Objetivo 2

=== Detalles de implementación
Como se ha llevado a cabo, etc.

=== Conclusiones
- Redacción de la memoria
- Ajustes finales
- Puesta en producción
- Despliegue final

== Conclusiones

En este capítulo concluimos que...
