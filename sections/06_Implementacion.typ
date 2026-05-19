#import "../utils/todo.typ": todo
#import "@preview/dtree:0.1.1": dtree
= Implementación
<sec:implementación>

== Introducción

En este capítulo se aborda el proceso de implementación del sistema desarrollado en este trabajo, organizado de forma incremental mediante distintos sprints. A lo largo de estos sprints se abordaron tanto la definición de la arquitectura y la infraestructura base del sistema como la implementación progresiva de las funcionalidades relacionadas con el análisis genómico y la predicción de resistencia a antibióticos.

Para cada sprint se describen los objetivos planteados, las principales decisiones técnicas adoptadas, los problemas encontrados durante el desarrollo y los resultados obtenidos.

== Tecnologías y herramientas utilizadas

En esta subsección se describen las principales tecnologías y herramientas utilizadas en el desarrollo del sistema, explicando las razones detrás de su elección. La selección de las mismas se ha realizado teniendo en cuenta los requisitos definidos para el proyecto, especialmente aquellos relacionados con la mantenibilidad, extensibilidad, interoperabilidad y facilidad de despliegue. Se puede observar un diagrama simplificado de las tecnologías en la @fig:tecnologias.

#figure(
  placement: auto,
  image("/memoria/figures/tecnologias.svg", width: 90%),
  caption: "Tecnologías utilizadas",
)<fig:tecnologias>

=== Frontend
La interfaz web se ha desarrollado utilizando _HTML_, _CSS_ y _JavaScript_, junto con _Tailwind CSS_ y _DaisyUI_ para el diseño visual de la aplicación.

Se ha optado por no utilizar frameworks frontend complejos como _React_ o _Angular_, ya que la interfaz del sistema se centra principalmente en la gestión de formularios, la visualización de resultados y el seguimiento de procesos asíncronos, sin requerir una lógica de interacción especialmente compleja en el lado del cliente. El uso de este tipo de frameworks habría introducido una complejidad adicional tanto en el desarrollo como en el despliegue del sistema, sin aportar sin aportar ventajas relevantes para los requisitos del sistema. En su lugar se ha priorizado una arquitectura frontend ligera y sencilla de mantener que permite iterar rápidamente sobre el diseño de la interfaz y adaptarla a las necesidades de los usuarios, sin la sobrecarga que implicaría un framework más pesado.

Para el diseño visual se ha utilizado _DaisyUI_, basada en _Tailwind CSS_. Tailwind permite construir interfaces de forma flexible mediante utilidades CSS reutilizables, mientras que DaisyUI proporciona componentes reutilizables que permiten ofrecer una apariencia consistente. Esta decisión permite acelerar el desarrollo de la interfaz, evitando complejidad innecesaria  garantizando al mismo tiempo una apariencia consistente y profesional.

=== Backend web
El backend del sistema web se ha desarrollado utilizando _Django_ como framework principal y _PostgreSQL_ como sistema de gestión de bases de datos.

Debido a la integración con modelos de predicción, se ha decidido utilizar _Python_ como lenguaje principal del proyecto, ya que se trata del lenguaje predominante tanto en el ámbito de la ciencia de datos y el aprendizaje automático. Esto facilita la integración con modelos predictivos y herramientas externas en el mismo ecosistema tecnológico.

Dentro de los frameworks de desarrollo web disponibles para Python, se ha optado por _Django_ debido a su amplia gama de funcionalidades integradas, como sus sistema de gestión de usuarios y autenticación, el ORM para la persistencia de datos y el panel de administración. Estas características permiten acelerar el desarrollo de funcionalidades comunes y permiten centrarse en la lógica específica del proyecto. Además, gran parte del sistema consiste en la gestión de entidades persistentes relacionadas entre sí como procesos, archivos o notificaciones, lo que se adapta bien al modelo relacional y el ORM de Django.

Como sistema de persistencia se ha utilizado _PostgreSQL_ debido a su fiabilidad, rendimiento y  compatibilidad con Django.

=== Sistema bioinformático
El subsistema bioinformático se ha desarrollado también principalmente en Python, debido a la amplia disponibilidad de herramientas y bibliotecas bioinformáticas, haciendo que sea el lenguaje más adecuado para la integración de las herramientas de ensamblaje y anotación, así como para la gestión de pipelines de procesamiento.

Para la implementación de la API del sistema bioinformático se ha utilizado _FastAPI_. A diferencia del sistema web principal, este subsistema no requiere funcionalidades avanzadas de gestión de usuarios o renderizado de vistas, sino una interfaz ligera y eficiente orientada a la comunicación entre servicios. FastAPI permite implementar esta API de forma sencilla, con buena integración con Python.

El sistema bioinformático integra herramientas especializadas para distintas etapas del pipeline genómico. Por un lado se hace uso de herramientas de ensamblaje como _SPAdes_ @SPAdes, _Raven_ @Raven o _Flye_ @Flye, permitiendo adaptar el procesamiento a distintos tipos de datos de secuenciación, incluyendo tecnologías Illumina y ONT.

Por otro lado, para la anotación del genoma se utiliza _Bakta_ @Bakta, una herramienta orientada a la anotación de secuencias de ADN especialmente diseñada para muestras de bacterias. _Bakta_ ofrece una anotación rápida y estandarizada, lo que facilita la generación de resultados consistentes y de alta calidad, además de ser compatible con el formato de salida JSON, lo que permite su integración directa con el sistema web para la generación de características y la ejecución de modelos predictivos.

=== Gestión de tareas asíncronas
Para la gestión de las tareas asíncronas de ensamblaje y anotación se ha utilizado _Celery_ junto con _Redis_ como sistema de cola de mensajes.

_Celery_ permite definir tareas desacopladas que son ejecutadas por workers independientes del servidor web principal. Esto permite delegar la ejecución de procesos de larga duración sin bloquear la interacción del usuario con la aplicación y facilita la ejecución concurrente de múltiples tareas.

Por otro lado, _Redis_ se emplea como intermediario para la gestión de colas gracias a su sencilla integración con _Celery_ y el hecho de que es un sistema de almacenamiento en memoria que ofrece un alto rendimiento en operaciones de lectura y escritura.

Además, este enfoque simplifica la coordinación entre el sistema web y el sistema bioinformático, permitiendo gestionar el envío de tareas, la monitorización de su estado y la recuperación de resultados de forma desacoplada.

=== Despliegue y contenedorización
Para el despliegue del sistema se ha optado por una arquitectura basada en contenedores utilizando _Docker_. Se ha optado por esta tecnología ya que se trata del sistema más extendido y conocido de contenedorización. Además, cuenta con amplio soporte y documentación online, lo que facilita su uso tanto durante el desarrollo como en la fase de despliegue y producción.

Para la orquestación de los contenedores se ha decidido usar _Docker Compose_, lo que permite definir y gestionar la infraestructura del sistema de forma sencilla a través de archivos de configuración. Esto facilita la reproducibilidad del entorno y simplifica tanto el desarrollo local como futuros despliegues.

=== Pruebas y validación
Para las pruebas unitarias se ha utilizado _unittest_, el framework de testing estándar de _Python_ integrado en _Django_. Se ha elegido esta tecnología debido a su integración nativa con el framework, que facilita la creación de tests para modelos, vistas, servicios y componentes del sistema. Además, la integración con el sistema de testing de _Django_ permite ejecutar las pruebas sobre una base de datos temporal aislada, garantizando la independencia entre casos de prueba.

Adicionalmente, se ha hecho uso de la biblioteca _unittest.mock_, que permite simular comportamientos y dependencias durante las pruebas, facilitando la validación de componentes de forma aislada.

=== Puesta en producción
Para la puesta en producción del sistema se ha utilizado _Gunicorn_ como servidor WSGI para la ejecución de la aplicación _Django_. _Gunicorn_ ofrece un rendimiento sólido, soporte para múltiples workers y una integración sencilla con aplicaciones Python, siendo una de las soluciones más utilizadas para el despliegue de aplicaciones web basadas en _Django_.

Por otro lado, para la gestión de archivos estáticos se ha utilizado _WhiteNoise_,que permite servir dichos archivos directamente desde la propia aplicación sin necesidad de configurar un servidor web adicional como _nginx_. Este enfoque simplifica la arquitectura de despliegue y facilita la portabilidad de la aplicación dentro de entornos basados en contenedores _Docker_.

La combinación de _Gunicorn_ y _WhiteNoise_ proporciona una solución ligera y sencilla de mantener, especialmente adecuada para despliegues pequeños y medianos como el contemplado en este proyecto.


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

== Sprint 3 - Desarrollo de la infraestructura base
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
Aunque inicialmente se consideró el uso de _SQLite_ como sistema de persistencia en las primeras fases del desarrollo por su simplicidad, finalmente se optó por hacer uso de _PostgreSQL_ desde el inicio debido a que el acceso a la base de datos de distintos workers podía dar problemas de concurrencia. Así mismo, se optó por esta opción para evitar problemas de migración y compatibilidad que podrían surgir al cambiar de _SQLite_ a _PostgreSQL_ en fases posteriores.

===== Modelo de datos
Se definió el modelo de datos inicial utilizando los modelos de _Django_, incluyendo entidades relacionadas con usuarios, procesos, archivos y notificaciones y sus relaciones, especificadas en @sec:modelo_datos.

Relativo al modelo de datos, cabe destacar el uso de validación a nivel de entidad, mediante el método `clean()`, especialmente en `ConversionTask`. Estas validaciones permiten evitar estados inconsistentes independientemente de la capa desde la que se creen los objetos. Las restricciones implementadas se centraron principalmente en garantizar la coherencia entre tipos de tareas, validar correctamente las dependencias entre procesos y asegurar que las tareas relacionadas perteneciesen al mismo usuario.

Además, se sobrescribió el método `save()` para forzar la ejecución automática de `full_clean()` antes de persistir las entidades, garantizando así que todas las validaciones se aplicasen de forma consistente.

Finalmente, se seleccionaron distintas estrategias de borrado (`CASCADE`, `PROTECT` y `SET_NULL`) en función del dominio funcional de cada entidad, preservando la consistencia histórica de procesos y notificaciones sin comprometer la integridad referencial del sistema.


===== Almacenamiento de archivos
Por otro lado, debido al gran tamaño de los archivos relacionados con el pipeline genómico (FASTQ, FASTA y JSON) y a las diferencias en su ciclo de vida, se decidió diferenciar entre almacenamiento temporal y persistente (@fig:upload_structure), diferenciando:

- *Archivos Temporales*: Los archivos FASTQ utilizados como entrada durante los procesos de ensamblaje se almacenan temporalmente y se eliminan automáticamente tras finalizar el procesamiento para reducir el consumo de espacio. Estos se encuentran almacenados en su propia carpeta temporal `uploads/temp/` durante el procesamiento.

- *Archivos Persistentes*: Archivos FASTA o JSON generados en los procesos de ensamblaje o anotación. Se almacenan en `uploads/persistent/user_{user_id}/{file_type}/`, según el usuario y el tipo de archivo, facilitando búsquedas y gestión.

#figure(
  [
    #show raw.where(block: false): it => {
      it.text
    }
    #block[
      #set align(left)
      #dtree(```
      /
      📁 | uploads
       📁 | persistent
        📁 | user_<user_id>
         📁 | fasta
          📄 | <sample>.fasta
         📁 | json
          📄 | <sample>.json
       📁 | temp
        📁 | user_<user_id>
         📁 | fastq
          📄 | <sample>.fastq
      ```)
    ]
  ],
  caption: "Estructura de archivos subidos",
  kind: image,
)<fig:upload_structure>

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

Finalmente, para simplificar el despliegue de ambos subsistemas, se desarrolló un script de automatización (`deploy.py`) encargado de orquestar la construcción de imágenes Docker y la ejecución de los contenedores. Este script permite desplegar mediante un único comando tanto el subsistema bioinformático como el sistema web, automatizando además la creación de la red interna de Docker utilizada para la comunicación entre ellos.

Este enfoque facilita la reproducibilidad del entorno de ejecución y simplifica considerablemente tanto el despliegue local como una futura puesta en producción del sistema.

==== Ejecución asíncrona

Para coordinar la ejecución de tareas de larga duración se configuró _Celery_ junto con _Redis_. Los workers definidos en cada subsistema permiten ejecutar procesos de forma asíncrona y desacoplada del flujo principal de la aplicación.

En el sistema web los workers monitorizarán el envío de tareas al sistema bioinformático, la monitorización de su estado, la recuperación de resultados y la ejecución de predicciones.

Por otro lado, en el sistema bioinformático, los workers se encargan de ejecutar las herramientas de ensamblaje y anotación, además de tareas auxiliares de mantenimiento y limpieza.

La separación entre los workers del sistema web y del sistema bioinformático permite escalar ambos subsistemas de forma independiente según la carga de cada uno y permite mantener los dos sistemas totalmente desacoplados.

==== Implementación de autenticación y control de acceso

Aunque la gestión de usuarios no es un punto clave del sistema, se consideró necesario para asociar procesos y resultados a usuarios concretos y permitir un seguimiento individualizado de su progreso. Para ello se decidió utilizar el sistema de autenticación integrado de _Django_, aprovechando sus mecanismos de gestión de usuarios, sesiones y permisos.

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

La separación de ambos subsistemas permitió aislar las dependencias específicas de las herramientas bioinformáticas, los elevados requisitos computacionales y los largos tiempos de ejecución asociados a los procesos de ensamblaje y anotación. Además, este enfoque facilita la escalabilidad del sistema y reduce el impacto de posibles errores producidos durante la ejecución de herramientas externas.

Internamente, el sistema bioinformático se estructura en tres componentes principales:

- Una API HTTP encargada de recibir solicitudes de ejecución desde el sistema web (`app.py`).
- Un sistema de workers asíncronos responsable de ejecutar los procesos bioinformáticos, integrados con las herramientas externas (`task.py`).
- Un módulo de utilidades para la gestión de los procesos (`utils.py`).

Las herramientas bioinformáticas se integraron mediante la ejecución de procesos externos desde Python utilizando el módulo `subprocess`. Este enfoque permite encapsular la lógica de invocación de cada herramienta y controlar parámetros de ejecución, directorios de salida y gestión de errores de forma homogénea.

===== Integración de herramientas de ensamblaje
El sistema se diseñó para soportar distintos tipos de tecnologías de secuenciación, integrando diferentes herramientas de ensamblaje según el tipo de lecturas utilizadas. Para secuenciación de lecturas cortas (_Illumina_) se integró _SPAdes_, mientras que para secuenciación de lecturas largas (_ONT_) se integraron _Flye_ y _Raven_. En todos los casos, la integración sigue una estructura similar:

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

La integración del sistema web con el sistema bioinformático se implementó mediante una capa de servicios encargada de encapsular las llamadas HTTP. La comunicación con el sistema bioinformático se encapsuló en una capa de servicios implementada en el archivo `bio_api_client.py`, encargada de abstraer las llamadas HTTP y unificar la interacción con la API externa, siguiendo un patrón fachada. Se puede ver un ejemplo en @cod:bioapiclient.

#figure(
  placement: auto,
  raw(read("/memoria/code/bio_api_client.py"), block: true, lang: "python"),
  caption: "Ejemplo del código de la capa de servicios encargada de la comunicación con el sistema bioinformático",
)<cod:bioapiclient>

Las tareas asíncronas del sistema web, definidas en `tasks.py`, utilizan este cliente para iniciar procesos de ensamblaje o anotación en el subsistema bioinformático, consultar el estado de los procesos y recuperar resultados.

La ejecución de procesos se realiza mediante tareas _Celery_, permitiendo que el usuario continúe interactuando con la aplicación mientras los procesos bioinformáticos se ejecutan en segundo plano.

==== Monitorización y flujo de procesos

Uno de los principales retos de la integración es la sincronización del estado de procesos de larga duración entre ambos subsistemas. Debido a que las tareas de ensamblaje y anotación pueden prolongarse varios minutos o incluso horas, no es adecuado mantener conexiones HTTP persistentes entre ambos sistemas. Para abordar este problema se implementó un mecanismo de monitorización basado en polling periódico desde los workers del sistema web.

Una vez dada la orden de iniciar una tarea bioinformática, se almacena el identificador del proceso remoto en la base de datos del sistema web. A partir de ese momento, un worker consulta periódicamente el estado del proceso mediante llamadas HTTP a la API bioinformática. Un ejemplo simplificado del mecanismo de polling implementado se muestra en @cod:polling.py.

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

Para facilitar la extensibilidad del sistema, se implementó un mecanismo de registro automático basado en el patrón _Registry_ (@cod:parser_registry.py). Este mecanismo permite registrar automáticamente nuevos parsers mediante decoradores, evitando configuraciones manuales.

#figure(
  placement: auto,
  [
    #set text(size: 12pt)
    #raw(read("/memoria/code/parser_registry.py"), block: true, lang: "python")
  ],
  caption: "Registro de parsers",
)<cod:parser_registry.py>

Cada parser se registra utilizando un identificador único que posteriormente permite su resolución dinámica dentro del flujo de generación de features. Un ejemplo simplificado de implementación de un parser se muestra en @cod:parser_decorator.py.

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

- Integrar modelos de machine learning dentro del sistema web.
- Diseñar una primera interfaz para la ejecución de predicciones.
- Implementar utilidades para la transformación de las características almacenadas en base de datos al formato requerido por los modelos.
- Validar el flujo completo desde la anotación hasta la obtención de predicciones.


=== Detalles de implementación

==== Implementación de modelos de predicción
Como primera aproximación funcional al sistema de predicción, se integraron dos modelos proporcionados por el equipo de investigación: `base_bakta_50` y `base_bakta_90`. Ambos modelos comparten una arquitectura y flujo de procesamiento similares, por lo que se describe únicamente el funcionamiento de `base_bakta_50` definido en `model_classes.py` (@cod:base_bakta_50.py).

#figure(
  placement: auto,
  raw(read("/memoria/code/base_bakta_50.py"), block: true, lang: "python"),
  caption: "Modelo de predicción base_bakta_50",
)<cod:base_bakta_50.py>

El modelo fue diseñado para predecir resistencia a antibióticos a partir de la información binaria de presencia o ausencia de genes relevantes en la muestra analizada. La implementación se estructuró en torno a tres responsabilidades principales:

- Obtención de las features necesarias para el modelo.
- Carga dinámica de pesos entrenados.
- Ejecución de las predicciones.

===== Obtención de features
Cada modelo define internamente las características que necesita para realizar predicciones. En el caso de `base_bakta_50`, estas características corresponden a un conjunto de genes relevantes para la resistencia antimicrobiana.

Para ello se implementó el método `features()` (@cod:bakta_50_features.py), encargado de cargar automáticamente la lista de genes esperados por el modelo a partir de archivos en formato _pickle_. Durante este proceso se normalizan nombres e identificadores para hacerlos compatibles con la estructura de genes almacenada en el sistema tras el parseo de anotaciones de _Bakta_. Esto evita acoplar directamente el formato interno del modelo con la representación en base de datos.

#figure(
  placement: auto,
  raw(read("/memoria/code/bakta_50_features.py"), block: true, lang: "python"),
  caption: "Definición de las features utilizadas por el modelo base_bakta_50",
)<cod:bakta_50_features.py>

===== Carga dinámica de pesos
Se implementó el método `load()` (@cod:bakta_50_load.py), encargado de cargar dinámicamente los pesos asociados al antibiótico concreto sobre el que se desea realizar la predicción.

#figure(
  placement: auto,
  raw(read("/memoria/code/bakta_50_load.py"), block: true, lang: "python"),
  caption: "Definición del método de carga para el modelo base_bakta_50",
)<cod:bakta_50_load.py>

La carga se hace utilizando archivos `.pt` de `PyTorch`, almacenados organizadamente por modelo y antibiótico. Durante este proceso también se inicializan las features utilizadas durante la predicción.

===== Ejecución de predicciones

Finalmente, se definió un método `predict()` (@cod:bakta_50_predict.py) encargado de realizar la predicción de resistencia a partir de las características obtenidas de la muestra.

#figure(
  placement: auto,
  raw(read("/memoria/code/bakta_50_predict.py"), block: true, lang: "python"),
  caption: "Definición del método de predicción para el modelo base_bakta_50",
)<cod:bakta_50_predict.py>

Durante la predicción se generan automáticamente los vectores binarios de presencia y ausencia requeridos por el modelo, utilizando las utilidades de transformación desarrolladas en este sprint. El resultado devuelto consiste en un valor numérico que representa la probabilidad de resistencia frente a un antibiótico concreto.

==== Utilidades de transformación de features

Uno de los principales retos encontrados durante la integración de modelos de predicción fue la transformación de las características almacenadas en la base de datos al formato exacto requerido por los modelos.

Para evitar duplicar la lógica en cada modelo, se desarrolló un conjunto de utilidades en el archivo `input_utils.py`, incluyendo funciones reutilizables asociadas a la transformación de características.

===== Generación de vectores de presencia y ausencia

Muchos de los modelos estudiados utilizan vectores binarios indicando la presencia o ausencia de genes concretos en una muestra. Para abstraer este proceso se implementó la función `presence_from_list(model_feature, file_upload)` (@cod:model_utils_presence.py).

#figure(
  placement: auto,
  raw(read("/memoria/code/model_utils_presence.py"), block: true, lang: "python"),
  caption: "Generación de vectores binarios de presencia y ausencia",
)<cod:model_utils_presence.py>

La función recibe la lista de genes esperados por el modelo y una muestra almacenada en el sistema (FileUpload), devolviendo un vector binario normalizado donde cada posición representa la presencia (1) o ausencia (0) del gen correspondiente. Esto permite desacoplar la lógica de consulta de base de datos del código específico de cada modelo.

===== Lectura de configuraciones serializadas

Por otro lado, también se definió la utilidad `get_columns_from_pickle()` (@cod:model_utils_pickle.py), encargada de cargar estructuras serializadas utilizadas por distintos modelos. Esta función se utiliza principalmente para recuperar listas de genes, nombres de columnas o configuraciones generadas durante el entrenamiento de los modelos.

#figure(
  placement: auto,
  raw(read("/memoria/code/model_utils_pickle.py"), block: true, lang: "python"),
  caption: "Función de carga de archivos de pickle con información relevante para la generación de features",
)<cod:model_utils_pickle.py>

===== Resolución de rutas de pesos
Finalmente, se implementó get_model_weights_path(antibiotic, model_name) (@cod:model_utils_weights.py), encargada de resolver automáticamente la ruta al archivo de pesos correspondiente.

#figure(
  placement: auto,
  raw(read("/memoria/code/model_utils_weights.py"), block: true, lang: "python"),
  caption: "Función de carga de archivos de pesos para modelos de torch",
)<cod:model_utils_weights.py>

Esta utilidad evita rutas codificadas manualmente dentro de cada implementación y facilita la organización modular de los modelos y sus pesos asociados.

=== Resultados
Durante este sprint se implementó la primera versión funcional del módulo de predicción de resistencia a antibióticos. Se integraron modelos reales de machine learning, se desarrollaron utilidades para transformar automáticamente las características generadas por el pipeline bioinformático y se validó el flujo completo desde la anotación hasta la obtención de predicciones.

Además, este sprint permitió confirmar necesidades arquitectónicas relacionadas con extensibilidad y mantenibilidad que motivaron el desarrollo posterior de una arquitectura modular específica para modelos de predicción, como se consideró inicialmente en la fase de diseño del sistema.

== Sprint 7 - Arquitectura modular para modelos de predicción
=== Objetivos
Este sprint se desarrolló entre el 3 y el 17 de marzo de 2026 y tuvo como objetivo refinar y generalizar la integración de modelos de predicción en el sistema web. Tras validar el flujo de predicción en el sprint 6, se buscó construir la arquitectura extensible definida durante la fase de diseño del sistema para facilitar la incorporación de nuevos modelos minimizando modificaciones sobre el núcleo de la aplicación. Los objetivos principales fueron:

- Implementar un mecanismo de registro automático de modelos mediante decoradores.
- Definir una interfaz común para adaptadores de modelos.
- Permitir la selección dinámica de modelos en tiempo de ejecución.
- Validar la integridad de los adaptadores de nuevos modelos durante el registro.

=== Detalles de implementación

==== Arquitectura modular de modelos
Con el objetivo de cumplir con los requisitos de extensibilidad definidor para el sistema, se implementó la arquitectura modular basada en los patrones _Adapter_, _Registry_ y _Strategy_. El objetivo principal es desacoplar la lógica interna de cada modelo, la carga de los pesos, la transformación de características, la ejecución de predicciones y la selección dinámica del modelo utilizado.

===== Definición de la interfaz común
Primero, se definió una clase base `ModelInterface` (@cod:model_interface.py), encargada de establecer una interfaz común para todos los adaptadores de modelos. Esta interfaz actúa como un _Adapter_ entre el sistema web y modelos potencialmente heterogéneos, ocultando diferencias internas de implementación.

#figure(
  placement: auto,
  raw(read("/memoria/code/model_interface.py"), block: true, lang: "python"),
  caption: "Clase base para los modelos de predicción",
)<cod:model_interface.py>

La interfaz define tres métodos principales:
- `features(file_upload)` (@cod:model_interface.py:3): Dado un archivo de subida persistido en base de datos (`FileUpload`), obtiene las características necesarias para realizar la predicción.

- `load()` (@cod:model_interface.py:6): Carga los pesos del modelo y prepara el modelo para ejecución.
- `predict(file_upload)` - (@cod:model_interface.py:9): Ejecuta la predicción, devolviendo un valor numérico que representa la probabilidad de resistencia.

Gracias a esta abstracción, el resto del sistema puede interactuar con cualquier modelo registrado a través de esta interfaz común, sin necesidad de conocer detalles específicos de cada modelo.

===== Registro automático de modelos
A continuación, se implementó un mecanismo de registro automático para los modelos de predicción siguiendo el patrón _Registry_ (@cod:model_registry.py).
#figure(
  placement: auto,
  raw(read("/memoria/code/model_registry.py"), block: true, lang: "python"),
  caption: "Registro de modelos de predicción",
)<cod:model_registry.py>

El registro permite detectar nuevos modelos mediante decoradores, evitando configuraciones manuales y facilitando la extensión del sistema con nuevos modelos de forma sencilla.

Cada modelo se registra utilizando un identificador único:

#figure(
  ```python
    @register_model("base_bakta_50")
  class BaseBakta50(ModelInterface):
  ```,
  caption: "Decorador para registro de modelos de predicción",
)<cod:model_decorator>

Durante el arranque de la aplicación, el sistema construye automáticamente:
- `MODEL_REGISTRY`: Un diccionario que mapea el identificador de cada modelo a su clase adaptadora concreta.
- `MODEL_ANTIBIOTIC_SUPPORT`: Un diccionario que mapea el identificador de cada modelo a la lista de antibióticos para los que tiene pesos disponibles.

La compatibilidad con antibióticos se obtiene inspeccionando dinámicamente los archivos de pesos disponibles para cada modelo, permitiendo reflejar esta información en la interfaz de usuario y evitar errores de selección de modelos para antibióticos no soportados.

Para evitar errores durante la integración de nuevos modelos, se implementó un sistema de validación ejecutado durante el registro(@cod:model_registry.py:9). Que verifica automáticamente que la clase hereda de `ModelInterface`, que implementa los métodos requeridos y que dispone de identificadores válidos.

===== Selección dinámica de modelos
Por otro lado, inspirado en el patrón _Strategy_, se implementó un mecanismo de selección dinámica del modelo concreto utilizado para realizar una predicción. Esto permite intercambiar distintos modelos de predicción simplemente llamando a una función con distintos parámetros. El código se puede ver en @cod:model_predict.py.

#figure(
  placement: auto,
  raw(read("/memoria/code/model_predict.py"), block: true, lang: "python"),
  caption: "Llamada única de predicción",
)<cod:model_predict.py>

Se define la función `get_prediction()` que recibe como parámetro el nombre del modelo a utilizar, el antibiótico y la muestra asociada, y resuelve dinámicamente la implementación concreta a utilizar. Esto permite intercambiar algoritmos de predicción sin modificar el flujo del sistema, utilizando una interfaz común (métodos `load()` y `predict()`) independiente de la implementación interna.

==== Organización modular de modelos

Para facilitar la integración de nuevos modelos, se definió una estructura en el módulo `ai_models`. La estructura estándar es la mostrada en @fig:model_structure.

#figure(
  [
    #show raw.where(block: false): it => {
      it.text
    }
    #block[
      #set align(left)
      #dtree(```
      /
      📁 | ai_models
       📁 | <model_name>
        📁 | weights
         📄 | <antibiotic>.pt
        📄 | model_classes.py
      ```)
    ]
  ],
  caption: "Estructura de archivos para los modelos de predicción",
  kind: image,
)<fig:model_structure>

Cada modelo se encapsula en su propia carpeta, incluyendo: su definición, su adaptador, sus pesos y la configuración asociada, donde `model_classes.py` debe exponer la arquitectura del modelo y la clase adaptadora que implementa la interfaz de predicción, registrada mediante el decorador `@register_model("alias")`. En la carpeta `weights`, deberá aparecer una lista de archivos de pesos en formato `.pt` nombrados por el antibiótico al que pertenecen.

==== Integración en el flujo de procesamiento
Finalmente, la nueva arquitectura se integró dentro del flujo principal del sistema web.

Además de la predicción individual, se implementó `get_prediction_matrix()` (@cod:model_matrix.py), encargada de ejecutar múltiples combinaciones de modelos y antibióticos.

#figure(
  placement: auto,
  raw(read("/memoria/code/model_matrix.py"), block: true, lang: "python"),
  caption: "Función de predicción para múltiples antibióticos",
)<cod:model_matrix.py>

El método `get_prediction_matrix(models, antibiotics, file_upload)` recibe una lista de modelos, una lista de antibióticos y un archivo de subida asociado a un proceso de anotación, y devuelve una matriz de predicciones con la probabilidad de resistencia a cada antibiótico para cada modelo. La función itera sobre cada combinación de modelo y antibiótico, llamando a la función `get_prediction` para obtener la predicción correspondiente y almacenándola en una estructura de diccionario anidado que se devuelve al finalizar el proceso. Preparando los resultados para su visualización según el mockup planteado durante el diseño del sistema en la @fig:mock_prediccion.

=== Resultados
Durante este sprint se consolidó la arquitectura modular del sistema de predicción, definiendo una infraestructura extensible para la integración de nuevos modelos de predicción. La combinación de patrones _Adapter_, _Registry_ y _Strategy_ permitió desacoplar completamente la lógica de selección, carga y ejecución de modelos, facilitando su reutilización y evolución futura.

Además, se validó la integración completa de los modelos `base_bakta_50` y `base_bakta_90`, estableciendo un flujo de predicción (@fig:prediction_flow) completamente funcional y preparado para futuras ampliaciones del sistema.


#figure(caption: "Flujo simplificado de predicción", kind: image, [
  #import "@preview/tiptoe:0.4.0": *
  #import "@preview/codly:1.3.0": *
  #set block(breakable: false)
  // Cambiar height por auto si no se quiere alto fijo
  #let bloque = block.with(
    stroke: rgb("#891536"),
    fill: gray.lighten(90%),
    radius: 5pt,
    inset: 2mm,
    height: 2.3cm,
    width: 100%,
  )
  #let flecha = block(height: 1cm, [#line(
    tip: triangle.with(length: 5mm, width: 1.0cm),
    stroke: 0.7cm + rgb("#f6e3a8"),
  )])
  #set text(8pt)
  #show list: set text(8.0pt)
  #set list(indent: 0mm, body-indent: 1mm)
  #codly-disable()
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr),
    gutter: 2mm,
    align: (x, y) => { if (calc.rem(x, 2) == 0 and calc.rem(y, 2) == 0) { left } else { center + horizon } },
    bloque[
      ```python
      class ModelInterface:
        def features(self):
            pass
        def load(self):
            pass
        ...
      ```
    ],
    flecha,
    // Si el bloque tiene altura automática, poner dentro de align(horizon, bloque[...]) para que esté centrado
    bloque[
      ```python
            @register_model("base_model")
      class BaseAdapter(ModelInterface):
        def features(self):
          return features
        ...
      ```

    ],
    flecha,
    bloque[
      ```python
      def register_model(name):
       def _decorator(cls):
        MODEL_REGISTRY[key] = cls
        MODEL_ANTIBIOTICS[key] = _get_antibiotics()
       return cls
      ```
    ],
    grid.cell(x: 4, y: 1, rotate(90deg, flecha)),
    grid.cell(x: 4, y: 2, bloque[
      ```python
      def get_prediction(...):
       ...
       adapter = model_adapter()
       adapter.load()
      return adapter.predict()
      ```
    ]),
    grid.cell(x: 3, y: 2, rotate(180deg, flecha)),
    grid.cell(x: 2, y: 2, bloque[
      ```python
      def get_predict_matrix():
       for antibio in antibios:
         for model in models:
          get_prediction(model, antibiotic)
       return data
      ```
    ]),
    grid.cell(x: 1, y: 2, rotate(180deg, flecha)),
    grid.cell(x: 0, y: 2, bloque[
      #image("../figures/flujo_prediction.png", width: 100%)
    ]),
  )
  #codly-enable()
])<fig:prediction_flow>

== Sprint 8 - Interfaz de usuario y notificaciones
=== Objetivos
Este sprint se desarrolló entre el 17 de marzo y el 14 de abril de 2026 y tuvo como objetivo implementar la interfaz de usuario final del sistema, así como los mecanismos de seguimiento y notificación de procesos. Durante esta fase se integraron las funcionalidades desarrolladas en sprints anteriores dentro de una interfaz unificada que permite ejecutar y monitorizar el pipeline completo de análisis genómico desde el navegador. Los objetivos principales de este sprint fueron:
- Desarrollar la interfaz web del sistema.
- Integrar los flujos de ensamblaje, anotación y predicción.
- Implementar un sistema de notificaciones asociado al estado de las tareas.
- Implementar vistas para la gestión y el seguimiento de procesos.
- Implementar una interfaz visual para la consulta de los resultados de predicción.

=== Detalles de implementación

==== Desarrollo de la interfaz web
A partir del diseño definido en la fase de arquitectura del sistema, se implementó una estructura de templates basada en _Django Templates_, organizada en torno a una plantilla base común (`base.html`). Esta plantilla incluye la estructura general de la aplicación, la barra de navegación, el footer, los estilos compartidos y la integración del sistema de mensajes de Django. El resto de plantillas heredan de esta plantilla base, permitiendo reutilizar componentes comunes y mantener una apariencia homogénea en toda la aplicación.

Los templates se organizaron siguiendo una estructura modular, separando las distintas áreas funcionales del sistema en directorios específicos (`templates/conversion/`, `templates/prediction/` y `templates/notifications/`). Esta organización permite mantener una separación clara entre las distintas funcionalidades del sistema.

También se trabajó en la definición de una identidad visual coherente para toda la aplicación, manteniendo una paleta de colores uniforme y adaptando las vistas a distintos tamaños de pantalla mediante diseño responsive.Esto permitió mejorar la experiencia de usuario y facilitar el uso de la aplicación desde diferentes dispositivos.

La interfaz se desarrolló por completo en inglés debido al carácter internacional del ámbito del proyecto. Además, gran parte de la terminología técnica utilizada en análisis genómico y modelos predictivos se emplea habitualmente en inglés, por lo que se consideró que mantener la interfaz en este idioma facilita su comprensión y uso por parte de investigadores y profesionales del ámbito bioinformático a nivel global.

Adicionalmente, se diseñó una barra de navegación común que permite acceder desde cualquier vista a las principales funcionalidades del sistema: ensamblaje, anotación, seguimiento de procesos, predicción y notificaciones, así como un acceso directo a la página de inicio (@fig:navbar).

#figure(
  image("/memoria/figures/navbar.png", width: 100%),
  caption: "Barra de navegación del sistema web",
)<fig:navbar>

===== Formularios de ensamblaje y anotación
Para el ensamblaje y la anotación se definieron vistas específicas orientadas a solicitar al usuario los archivos y parámetros necesarios para iniciar cada proceso.

Se definieron formularios _HTML5_ con validación manual a través de `request.POST` y `request.FILES`. Se optó por esta opción debido a la simplicidad de los formularios. Esta aproximación proporciona control explícito sobre la validación y mantiene la lógica centralizada en las vistas.

Se implementaron validaciones tanto sobre los archivos subidos como sobre la coherencia del flujo de procesamiento. Estas validaciones comprueban la existencia y el formato de los archivos, la compatibilidad entre tecnologías de secuenciación y ensamblaje, así como la validez y propiedad de los procesos previos utilizados como entrada.

En la vista de ensamblaje (@fig:assembly_view), el usuario puede seleccionar entre ensamblaje para lecturas cortas (_Illumina_) con _SPAdes_, o lecturas largas (_ONT_) con _Flye_ o _Raven_. En función de la opción seleccionada se muestran dinámicamente los campos necesarios para cada tipo de ensamblaje. Adicionalmente, se incorporó una opción de anotación automática tras finalizar el ensamblaje, permitiendo encadenar ambas etapas dentro de un único flujo de trabajo.

#figure(
  placement: auto,
  image("/memoria/figures/view_assembly.png", width: 100%),
  caption: "Vista de ensamblaje en la pestaña Illumina",
)<fig:assembly_view>

Por otro lado, la vista de anotación (@fig:annotation_view) permite al usuario seleccionar un archivo FASTA proveniente de un ensamblaje previo o subir un archivo FASTA externo. También se incorporó una opción para realizar la extracción profunda de características, incluyendo información adicional sobre las secuencias genómicas.

#figure(
  placement: auto,
  image("/memoria/figures/view_annotation.png", width: 100%),
  caption: "Vista de anotación",
)<fig:annotation_view>

Además, se añadió una segunda pestaña a la vista de anotación orientada a únicamente a la generación de features a partir de archivos JSON generado por _Bakta_, permitiendo reutilizar anotaciones externas sin necesidad de repetir el pipeline completo de anotación.

===== Interfaz de predicción

La interfaz de predicción (`prediction.html`), permite a los usuarios ejecutar modelos de predicción de resistencia a antibióticos sobre muestras previamente procesadas. El flujo de interacción implementado es:

1. Selección de antibióticos.
2. Selección de los modelos compatibles.
3. Selección de la muestra.
4. Ejecución de la predicción.
5. Visualización de resultados.

Tanto la lista de modelos como la compatibilidad con antibióticos se generan dinámicamente a partir del sistema de registro de modelos implementado en el sprint anterior. Esto evita mantener configuraciones manuales duplicadas en frontend y garantiza que únicamente se muestren combinaciones válidas para el usuario. La vista inicial de predicción puede observarse en @fig:prediction_view_form.

#figure(
  placement: auto,
  image("/memoria/figures/view_prediction.png", width: 100%),
  caption: "Formulario de predicción",
)<fig:prediction_view_form>

Una vez ejecutada la predicción, el sistema llama internamente a `get_prediction_matrix()` para generar las predicciones de todas las combinaciones entre modelos y antibióticos seleccionados. Los resultados se muestran mediante una matriz tabular donde cada fila representa un antibiótico y cada columna un modelo de predicción. Adicionalmente, como en el mockup, se añadió una columna adicional que muestra la media de las predicciones para cada antibiótico, proporcionando una visión global de la resistencia estimada para cada antibiótico independientemente del modelo utilizado (@fig:prediction_view_results).

Los valores de probabilidad de resistencia se representan visualmente mediante códigos de color, facilitando la interpretación rápida de los resultados: verde para probabilidades bajas, amarillo para probabilidades intermedias y rojo para probabilidades altas.

#figure(
  placement: auto,
  image("/memoria/figures/view_prediction_results.png", width: 100%),
  caption: "Visualización de resultados de predicción",
)<fig:prediction_view_results>

Adicionalmente, se implementó la posibilidad de exportar en formato CSV la matriz completa de resultados para su análisis posterior o integración con herramientas externas. La exportación mantiene la misma estructura tabular mostrada en la interfaz.

===== Seguimiento de procesos

Para el seguimiento de procesos se implementó una vista (`task_list.html`) que muestra el historial completo de tareas del usuario autenticado. Esta vista permite monitorizar procesos de ensamblaje, anotación y extracción de features de forma visual mediante indicadores de estado y componentes gráficos diferenciados según el tipo y estado de la tarea (@fig:tasks_view).

#figure(
  placement: auto,
  image("/memoria/figures/view_task_list.png", width: 100%),
  caption: "Vista de lista de tareas",
)<fig:tasks_view>

Cada proceso muestra información relacionada con:
- Tipo de proceso.
- Estado actual.
- Archivo de entrada asociado.
- Fecha de última actualización.
- Resultados generados.

Se utilizaron badges y otros indicadores visuales como el color para representar estados como `pending`, `running`, `completed` o `failed`, permitiendo identificar rápidamente la situación de cada proceso.

Adicionalmente, desde esta pantalla el usuario puede acceder a una vista detallada de cada proceso (@fig:tasks_view_details), donde se muestran las distintas etapas ejecutadas, los archivos generados y las opciones de descarga disponibles. También se incorporó la posibilidad de asignar nombres personalizados a los procesos para facilitar su identificación posterior.

#figure(
  placement: auto,
  image("/memoria/figures/view_task_detail.png", width: 100%),
  caption: "Vista de detalle de tarea",
)<fig:tasks_view_details>

==== Sistema de notificaciones
Finalmente, se implementó un sistema completo de notificaciones, dentro del módulo `notifications`, permitiendo informar al usuario sobre el estado y evolución de sus procesos bioinformáticos.

Las notificaciones se generan automáticamente desde los workers y procesos de monitorización asociados al flujo asíncrono del sistema. Cada notificación se persiste en la base de datos y queda asociada al usuario correspondiente.

Desde la interfaz, las notificaciones se muestran mediante un icono de campana integrado en la barra de navegación, acompañado de un contador de notificaciones sin leer. Al acceder a la vista de historial (@fig:notification_history), el usuario puede consultar todas sus notificaciones organizadas cronológicamente y filtrarlas según su estado. Adicionalmente, las notificaciones presentan distintos estilos visuales según su contenido para su fácil identificación y rápida comprensión.

#figure(
  placement: auto,
  image("/memoria/figures/view_notifications.png", width: 100%),
  caption: "Vista de historial de notificaciones",
)<fig:notification_history>

Las notificaciones incluyen distintos tipos de eventos relacionados con:
- Inicio de procesos.
- Finalización correcta.
- Fallos durante la ejecución.
- Advertencias o recomendaciones.
- Saturación del servidor o retrasos en la ejecución.

Para simplificar la gestión de estas operaciones se implementó un servicio centralizado (`notifications/services.py`) encargado tanto de persistir las notificaciones como de gestionar el envío opcional de correos electrónicos utilizando las utilidades integradas en _Django_. Se definieron distintas funciones según el tipo de notificación, un ejemplo simplificado de una función de generación de notificaciones de finalización correcta de un proceso se muestra en @cod:notify_user_conversion_complete.py.

#figure(
  placement: auto,
  raw(read("/memoria/code/notify_user_conversion_complete.py"), block: true, lang: "python"),
  caption: "Ejemplo de código de notify_user_conversion_complete()",
)<cod:notify_user_conversion_complete.py>

Adicionalmente, se incorporó soporte para notificaciones por correo electrónico. Para ello, el usuario puede configurar su dirección de correo y otorgar consentimiento desde la pantalla de configuración de perfil (@fig:notification_settings).

#figure(
  placement: auto,
  image("/memoria/figures/view_profile_settings.png", width: 100%),
  caption: "Vista de configuración de notificaciones",
)<fig:notification_settings>

La integración entre el sistema de notificaciones y el flujo de los procesos genómicos, se implementó directamente dentro de las tareas de _Celery_. Son los propios workers los encargados de actualizar el estado de las tareas y generar las notificaciones correspondientes, garantizando que la información mostrada al usuario permanezca sincronizada con el estado real de ejecución.

=== Resultados
Durante este sprint se implementó la interfaz de usuario completa del sistema, integrando todas las funcionalidades desarrolladas en fases anteriores dentro de una aplicación web coherente y funcional. Asimismo, se desarrolló un sistema de seguimiento y notificaciones que permite monitorizar el estado de los procesos bioinformáticos de forma centralizada y transparente para el usuario.

La interfaz de predicción se diseñó para facilitar la interpretación visual de los resultados y permitir su exportación para análisis posteriores, mientras que las vistas de seguimiento y notificaciones mejoraron significativamente la experiencia de usuario durante la ejecución de tareas de larga duración.

Este sprint permitió ofrecer toda la funcionalidad desarrollada previamente en una aplicación completamente funcional desde el punto de vista del usuario final, integrando procesamiento bioinformático, generación de features, modelos predictivos y monitorización asíncrona dentro de una única interfaz web

== Sprint 9 - Integración del sistema, pruebas y validación

=== Objetivos
Este sprint se desarrolló entre el 14 y el 21 de abril de 2026 y tuvo como objetivo validar el funcionamiento global del sistema desarrollado durante los sprints anteriores. Durante esta fase se realizaron pruebas sobre los distintos componentes implementados, verificando tanto el correcto funcionamiento individual de los módulos principales como la ejecución completa del pipeline de análisis genómico y predicción. Los objetivos principales de este sprint fueron:

- Validar el funcionamiento de los distintos módulos del sistema y su interacción.
- Realizar pruebas sobre los servicios y tareas asíncronas implementadas.
- Detectar y corregir errores encontrados.
- Validar la experiencia de uso desde la interfaz web.

=== Detalles de implementación

==== Validación funcional del pipeline completo
Durante este sprint se realizaron pruebas funcionales manuales sobre el flujo completo soportado por la aplicación. Estas pruebas permitieron verificar la correcta ejecución de las distintas etapas del sistema y la sincronización entre el sistema web y el subsistema bioinformático. Se validaron distintos escenarios de uso, incluyendo:

- Flujo completo automático de ensamblaje y anotación.
- Ejecución independiente de ensamblajes.
- Ejecución manual de procesos de anotación.
- Generación aislada de features a partir de archivos JSON.
- Ejecución de modelos de predicción.
- Exportación de resultados en formato FASTA, JSON y CSV.

Las pruebas se realizaron utilizando distintos archivos de ejemplo y diferentes configuraciones de parámetros, comprobando la correcta persistencia de resultados, la actualización de estados y la generación adecuada de archivos de salida.

Adicionalmente, se verificó el correcto funcionamiento del sistema de notificaciones, comprobando que las notificaciones se generaban y mostraban correctamente en la interfaz durante las distintas fases de ejecución de los procesos.

==== Pruebas automatizadas

Además de las pruebas funcionales manuales, se desarrolló una suite de pruebas automatizadas sobre distintos componentes críticos del sistema, especialmente aquellos relacionados con la lógica de negocio, el procesamiento asíncrono y la integración entre subsistemas.

Las pruebas implementadas cubren principalmente:
- Modelos de datos y validación de relaciones.
- Sistema de parsers y generación de features.
- Servicios de notificaciones.
- Cliente de integración con el sistema bioinformático.
- Registro y carga dinámica de modelos de predicción.
- Utilidades de transformación de características.

Las pruebas se diseñaron cubriendo distintos escenarios de ejecución, incluyendo casos válidos, entradas inválidas y situaciones de error, permitiendo validar el comportamiento del sistema ante diferentes condiciones.

Para facilitar el aislamiento de componentes se utilizaron técnicas de mocking para simular dependencias externas, especialmente en el caso del sistema bioinformático y las llamadas HTTP, evitando la necesidad de ejecutar procesos reales durante las pruebas y permitiendo controlar los estados y respuestas de manera precisa.

Adicionalmente, se ha hecho uso de _subtests_ para validar el comportamiento de determinadas funcionalidades con múltiples combinaciones de parámetros de entrada, reduciendo la duplicación de código y facilitando la cobertura de distintos escenarios de ejecución.

==== Validación del sistema asíncrono
También se realizaron pruebas específicas sobre el sistema de tareas asíncronas implementado mediante _Celery_, verificando especialmente el comportamiento de los mecanismos de polling y la sincronización entre subsistemas.

Estas pruebas permitieron validar:

- La actualización del estado de los procesos.
- La descarga y persistencia de los resultados generados.
- La gestión de errores y reintento automático de las tareas.
- La eliminación de archivos temporales tras completar procesos.
- La generación automática de notificaciones asociadas a los procesos.

Una vez más, para facilitar estas pruebas se utilizaron llamadas simuladas (mocking) sobre servicios externos, permitiendo validar el comportamiento del sistema de forma aislada sin depender de la ejecución real del subsistema bioinformático.

==== Corrección de errores y ajustes finales

Durante las pruebas se identificaron y corrigieron varios problemas. Entre los principales ajustes realizados destacan:

- *Gestión de archivos temporales*: Se detectó que en algunos flujos los archivos FASTQ temporales no se eliminaban correctamente. Se revisó la lógica de limpieza en los workers de _Celery_ y se implementaron mecanismos adicionales para asegurar su eliminación incluso en casos de error.

- *Exportación de JSON en flujos completos*: Durante pruebas de flujos complejos (ensamblaje + anotación automática), se encontró que el archivo JSON de anotación generado tras el flujo no se descargaba correctamente desde la interfaz. Se revisó la lógica de las tareas y se detectó que el archivo no se estaba descargando.

- *Sincronización de notificaciones*: Se identificaron casos en los que determinadas notificaciones no se almacenaban correctamente cuando una tarea fallaba inesperadamente. Para solucionarlo se añadió una utilidad adicional encargada de garantizar la persistencia de las notificaciones generadas por los workers.

=== Resultados
Durante este sprint se validó el funcionamiento global del sistema mediante una combinación de pruebas funcionales manuales y pruebas automatizadas. Las pruebas realizadas permitieron comprobar la correcta interacción entre los distintos módulos implementados, así como el funcionamiento del pipeline completo de procesamiento y predicción desde la interfaz web.

Adicionalmente, se verificó el correcto comportamiento del sistema asíncrono y de los mecanismos de sincronización entre subsistemas, confirmando la estabilidad general de la arquitectura desarrollada.

Los problemas identificados fueron menores, principalmente relacionados con la gestión de archivos temporales y la sincronización de notificaciones, lo que indica que la arquitectura definida en sprints anteriores fue sólida. Tras la corrección de estos problemas, el sistema se encontró preparado para su despliegue y uso.

== Sprint 10 - Memoria, ajustes finales y puesta en producción

=== Objetivos

Este sprint final se desarrolló entre el 21 de abril y el 12 de mayo de 2026 con el objetivo de completar la redacción de la memoria del proyecto, realizar los ajustes finales sobre el sistema y preparar la aplicación para un futuro despliegue en producción. Los objetivos principales fueron:

- Finalizar la redacción de la memoria y documentación técnica.
- Realizar ajustes finales de usabilidad, estabilidad y seguridad.
- Preparar la aplicación para un despliegue en producción.

=== Detalles de implementación

==== Redacción de la memoria

Durante este sprint se completó la memoria técnica del proyecto. La memoria incluye diagramas de arquitectura, diagramas de secuencia, modelos conceptuales y capturas de pantalla de la interfaz desarrollada, permitiendo documentar tanto la arquitectura software como el flujo completo del sistema.

Adicionalmente, se elaboró la documentación técnica del repositorio mediante un archivo `README.md`, incluyendo instrucciones de instalación, configuración y ejecución del sistema, así como indicaciones para extender la arquitectura mediante la incorporación de nuevos modelos de predicción y parsers.

También se revisó la organización interna del código fuente y la nomenclatura utilizada en distintos módulos con el objetivo de mejorar la mantenibilidad y legibilidad del proyecto.

==== Ajustes finales del sistema

Una vez integradas todas las funcionalidades principales, se realizaron distintos ajustes finales orientados a mejorar la experiencia de usuario, la estabilidad del sistema y la robustez de los flujos asíncronos implementados. Entre los principales destacan:

- *Refinamiento de interfaz*: se revisaron estilos, componentes visuales y distribución de elementos para mejorar la consistencia visual y la adaptación a distintos tamaños de pantalla.
- *Mensajes de usuario*: Se mejoró la claridad y especificidad de los mensajes de error y confirmación en las vistas.
- *Configuración de timeouts*: Se ajustaron los timeouts en el polling de sincronización entre subsistemas para operaciones largas.
- *Adición de nuevos middlewares de seguridad*: Se añadieron configuraciones y middlewares de seguridad proporcionados por Django para reforzar la protección frente a ataques comunes y mejorar la preparación del sistema para producción.
- *Mensajes de notificaciones*: Se definieron mensajes de notificación más específicos y detallados para cada tipo de evento, mejorando la información proporcionada al usuario sobre el estado de sus procesos.

==== Preparación para producción
Aunque el sistema no fue desplegado en un entorno de producción real durante el desarrollo del TFG, se realizó una preparación completa de la aplicación para facilitar un futuro despliegue seguro y reproducible.

En primer lugar, se sustituyó el backend de correo de desarrollo por una integración basada en _SendGrid_, permitiendo el envío real de notificaciones por correo electrónico desde la aplicación.

Para la gestión de configuración sensible se definió un archivo `.env` específico para producción, desacoplando del código fuente parámetros críticos como credenciales, claves secretas y configuración de servicios externos.

Adicionalmente, se preparó una configuración específica de _Docker Compose_ orientada a producción, separando los distintos servicios de la aplicación y facilitando su despliegue reproducible mediante contenedores.

Durante la preparación del despliegue se evaluó inicialmente el uso de _nginx_ como reverse proxy y servidor de archivos estáticos. Sin embargo, finalmente se optó por utilizar _Gunicorn_ junto con _WhiteNoise_ para simplificar la arquitectura del sistema y reducir la complejidad de despliegue.

_Gunicorn_ actúa como servidor encargado de ejecutar la aplicación _Django_, mientras que _WhiteNoise_ permite servir los archivos estáticos desde la propia aplicación. Esta solución resulta especialmente adecuada para despliegues pequeños y medianos, mejorando la portabilidad y simplificando considerablemente el proceso de despliegue mediante contenedores Docker.

=== Resultados
Durante este sprint se completó la documentación técnica del proyecto y se realizaron los ajustes finales necesarios para estabilizar la aplicación y mejorar la experiencia de uso.

Además, el sistema quedó preparado para un futuro despliegue en producción mediante contenedores _Docker_, incorporando soporte para _PostgreSQL_, _Redis_, _Celery_, notificaciones por correo electrónico y configuraciones de seguridad orientadas a entornos reales.

Con ello, el proyecto finaliza con una plataforma funcional, modular y extensible capaz de ejecutar flujos completos de análisis genómico y predicción de resistencia a antibióticos desde una interfaz web integrada.

== Conclusiones
El desarrollo de este proyecto ha permitido diseñar e implementar una plataforma completa para el análisis genómico y la predicción de resistencia a antibióticos, integrando múltiples tecnologías y herramientas bioinformáticas dentro de una arquitectura modular y extensible.

A lo largo de los distintos sprints se han abordado diferentes aspectos del sistema, desde la definición de la arquitectura y el diseño de la interfaz, hasta la implementación de modelos de predicción y la integración de un sistema de notificaciones. La combinación de patrones de diseño como _Adapter_, _Registry_ y _Strategy_ ha permitido desacoplar los distintos componentes del sistema, facilitando su mantenimiento y evolución futura.

La validación realizada durante los sprints finales ha confirmado la estabilidad y funcionalidad del sistema, permitiendo detectar y corregir algunos problemas menores relacionados principalmente con la gestión de archivos temporales y la sincronización de notificaciones.

En resumen, el proyecto ha culminado con éxito la implementación de una plataforma funcional y preparada para su despliegue, ofreciendo una solución integral para el análisis genómico y la predicción de resistencia a antibióticos desde una interfaz web unificada.
