= Estudio previo
<sec:planificación>

== Introducción

En este capítulo se exponen aspectos de gestión previos a la ejecución del proyecto detallando aspectos como los objetivos del mismo, la metodología seguida para su desarrollo y la planificación temporal y presupuestaria del proyecto.


== Objetivos
El objetivo principal de este proyecto es diseñar y desarrollar un framework que integre el procesamiento y conversión de datos genómicos con la incorporación de modelos predictivos, con el fin de facilitar su uso por parte de personal sanitario en entornos reales.

Adicionalmente, se plantean los siguientes objetivos secundarios:

- Desarrollar un *sistema capaz de gestionar y convertir distintos formatos* de datos genómicos (FASTQ, FASTA y anotaciones generadas con Bakta), ofreciendo un entorno único en el que realizar los procesos de ensamblaje y anotación.
- Diseñar una *arquitectura modular* que permita la integración sencilla de modelos de predicción.
- Implementar un mecanismo para *automatizar la incorporación de modelos* y su disponibilidad dentro de la plataforma.
- Desarrollar una *interfaz intuitiva* que permita el uso del sistema de forma sencilla por parte del personal sanitario.
- Implementar un *sistema de notificaciones* que informe a los usuarios sobre el estado de ejecución de sus tareas y disponibilidad de resultados.
- *Optimizar la gestión de procesos* de alto coste computacional asociados al procesamiento y transformación de datos genómicos.
- Adquirir *experiencia en el desarrollo* de aplicaciones que integran bioinformática y aprendizaje automático.
- Integrar los conocimientos adquiridos a lo largo del grado en un *proyecto práctico* con aplicación en un *contexto real*.


== Metodología
<subsec:metodologia>

Para el desarrollo de este proyecto, se ha adoptado una metodología ágil adaptada a las características de un proyecto individual. Se ha priorizado la flexibilidad en la organización para poder adaptarse a las necesidades del software y a la carga lectiva del curso. Por ello, se ha optado por Scrumban, una metodología híbrida que combina la estructura de Scrum con la fluides de Kanban.

Scrumban combina la planificación iterativa propia de Scrum con la gestión visual del flujo de trabajo oferecido por Kanban. El desarrollo se ha dividido en iteraciones de duración variable (sprints), donde se definen objetivos concretos a corto plazo. Al inicio de cada iteración se se establecen las metas y al finalizar se evalúan los resultados obtenidos, ajustando la planificación en función del progreso y cambios en las prioridades y los requisitos.

// TODO: Añadir captura de pantalla???]

Como herramienta principal para la gestión de tareas se ha utilizado un tablero Kanban en Trello. Éste permite vidualizar el estado del proyecto mediante columnas (_Todo_, _In Progress_, _Blocked_ y _Done_), facilitando el seguimiento por parte de los tutores sin requerir reuniones diarias. Adicionalmente, se han establecido límites al trabajo en progreso (WIP), restringiendo el enfoque a una sola tarea activa para evitar la multitarea y favorecer la concentración y la finalización de tareas antes de iniciar nuevas.

Dada la naturaleza individual del proyecto y la necesidad de flexibilidad en la planificación, las reuniones diarias propuestas por Scrumban se han sustituido por sesiones semanales de seguimiento con los tutores. En estas reuniones se revisa el progreso, se resuelven dudas y bloqueos y se ajusta la planificación.

Este enfoque permite un desarrollo incremental y flexible, facilitando la entrega continua de funcionalidades sin depender de ciclos cerrados rígidos, adáptandose a las necesidades del proyecto y al ritmo académico.


== Planificación
La planificación el proyecto se ha estructurado mediante un enfoque iterativo basado en sprints, tal y como se ha descrito en la sección de metodología. El proyecto se ha dividido en sprints de duración variable, con una planificación adaptada a la complejidad y necesidadesde cada módulo.

Cada sprint ha estado orientado a un objetivo concreto, aportando cada una valor al sistema. A continuación se detalla la planificación temporal del proyecto. En la siguiente tabla se resumen los sprints definidos, incluyendo sus fechas, duración y objetivos principales:

#include "../tables/table_sprints.typ"

En segundo lugar, se detalla la planificación de la dedicación en horas para cada sprint, junto con la dedicación real registrada durante el desarrollo. Esto nos permite analizar las desviaciones producidas durante el desarrollo:

#include "../tables/table_time.typ"

Como puede observarse, la planificación inicial se ha mantenido en términos generales dentro de lo previsto, aunque se han producido desviaciones en determinados sprints. Destaca especialmente el sprint 8, centrado en el desarrollo de la interfaz de usuario, que requirió un esfuerzo superior al estimado para lograr una experiencia de uso intuitiva y accesible para los profesionales del ámbito de la salud.

Adicionalmente, la fase de desarrollo de la infrastructura también presentó una desviación relevante, debido a la complejidad asociada al despliegue del sistema y el servicio de conversión de datos genómicos mediante Docker y la incoporación de mecanismos de paralelización de tareas mediante la herramienta Celery.

Por el contrario, la fase de diseño de la arquitectura resultó requerir menor dedicación de lo previsto inicialmente. Esto se debe a la decisión de adoptar un enfoque modular y sencillo, evitando introducir complejidades innecesarias y priorizando la claridad y mantenibilidad del sistema.

Finalmente, se presenta el diagrama de Gantt del proyecto, en el que se representa de forma visual la distribución temporal de las principales tareas desarrolladas a lo largo de los distintos sprints:

#include "../figures/gantt_plan.typ"


== Presupuesto

El cálculo de los costes del proyecto tiene en cuanta varias partidas, cuyo importe depende en mayor o menos medida de la dedicación empleada.

En primer lugar, se consideran los costes de personal. Para su estimación se establece un coste de 23,85 euros por hora, tomando como referencia el salario medio de un desarrollador junior en España.

Por otro lado, dentro de los costes de equipo y suministros, se incluyen los costes asociados a la amortización del equipo informáti utilizado. Este equipo tiene un coste inicial de 1.200 euros y una vida útil estimada de seis años, siendo su periodo de uso en el desarrollo de este proyecto de seis meses. Adicionalmente, se estima el consumo eléctrico del equipo en 200 W por hora de uso, con un coste medio de 0,20 euros por kWh. Asimismo, se considera el gasto correspondiente a la conexión a Internet, estimado en una tarifa mensual de 50 euros.

Finalmente, se establece una reserva para riesgos e imprevistos del 10% sobre el total de los costes anteriores.

Con todo ello, el coste total del proyecto asciende a 9.268,49 euros, desglosados de la siguiente forma:

#include "../tables/presupuesto.typ"

Los costes incurridos finalmente durante la ejecución del proyecto han sido los siguientes:

#include "../tables/costes_reales.typ"

Concluimos por tanto que el coste del proyecto asciende a 8.917,81 euros. El aumento en el coste respecto a lo planificado inicialmente se debe principalmente a la mayor dedicación de horas comentada en la sección de planificación. Sin embargo, gracias a la reserva se ha podido cubrir dicho aumento de costes, obteniendo un superávit de 350,68 euros, lo que representa aproximadamente un 3,78% del presupuesto total.

== Riesgos
// TODO: Dani va a mandar algo

== Conclusiones
En este capítulo se han expuesto los aspectos de gestión previos a la ejecución del proyecto, detallando los objetivos, la metodología adoptada y la planificación temporal y presupuestaria del proyecto. Se ha establecido un marco de trabajo que ha guiado la ejecución del mismo, permitiendo una gestión eficiente de los recursos y una adaptación flexible a las necesidades del proyecto a lo largo de su desarrollo.
