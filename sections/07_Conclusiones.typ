= Conclusiones
<sec:conclusiones>

Este Trabajo de Fin de Grado se ha centrado en dos pilares fundamentales: simplificar el uso de herramientas del pipeline de análisis genómico y facilitar el acceso y despliegue de modelos de predicción de resistencia a antibióticos.

En este sentido, se ha desarrollado un proyecto dual. Por un lado, se proporciona un framework con una infraestructura flexible orientada a que investigadores y desarrolladores puedan integrar y ofrecer modelos de predicción. Por otro lado, se ofrece a usuarios del ámbito biomédico una interfaz unificada que permite ejecutar el pipeline completo de análisis genómico y obtener predicciones de resistencia de forma sencilla e intuitiva, reduciendo considerablemente la complejidad técnica asociada habitualmente a este tipo de herramientas.

Con este enfoque, se busca reducir la brecha existente entre el desarrollo de modelos predictivos y su utilización práctica. Para ello, el sistema se diseñó siguiendo una arquitectura modular y fácilmente extensible, lo que permite incorporar nuevas herramientas bioinformáticas, modelos y extractores de características (parsers) sin necesidad de modificar el núcleo de la aplicación. Esta decisión permite que la plataforma pueda evolucionar y adaptarse a futuros avances en el campo de la genómica y la predicción de resistencia a antibióticos.

Además, durante el desarrollo se abordaron distintos retos técnicos relacionados con la integración de herramientas bioinformáticas, la ejecución de tareas asíncronas de larga duración, la persistencia de resultados biológicos, el diseño extensible del framework y la creación de interfaces de usuario accesibles. El resultado final es un sistema capaz de coordinar procesos complejos y ofrecer resultados de manera eficiente y amigable para el usuario.

No obstante, existen todavía diversas líneas de trabajo futuras que permitirían ampliar las capacidades del sistema y mejorar su utilidad práctica.

En primer lugar, aunque el sistema ha sido preparado para producción y desplegado en entornos locales mediante _Docker_, todavía no se ha realizado un despliegue estable en un entorno de investigación real. COmo trabajo futuro, resultaría interesante completar este despliegue y validar el sistema con usuarios reales del ámbito biomédico, permitiendo obtener feedback sobre la experiencia de uso y detectar posibles mejoras funcionales o de interfaz.

Por otro lado, el sistema actual ejecuta las predicciones de forma síncrona, lo que puede resultar limitante para múltiples modelos o modelos de mayor complejidad. En este sentido, una posible línea de trabajo futura sería extender el sistema de ejecución asíncrona mediante _Celery_ también al módulo de predicción, mejorando la escalabilidad y la experiencia de usuario.

Asimismo, el framework podría enriquecerse incorporando nuevas herramientas bioinformáticas y modelos de predicción, ampliando así su aplicabilidad a distintos contextos y necesidades de investigación. Del mismo modo, sería interesante añadir soporte para nuevas estrategias de extracción de características y nuevas representaciones genómicas orientadas a modelos de aprendizaje automático.

También sería de gran utilidad integrar herramientas de visualización de resultados biológicos, lo que facilitaría a los usuarios la interpretación de la información generada por el sistema. De igual forma, la incorporación de técnicas de explicabilidad aplicadas a modelos de aprendizaje automático permitiría ofrecer información más interpretable sobre las predicciones realizadas por el sistema, un aspecto especialmente relevante en contextos biomédicos.

A nivel personal, cabe destacar que este proyecto ha sido una experiencia muy enriquecedora, ya que me ha permitido aplicar los conocimientos adquiridos durante la carrera en un contexto real de investigación interdisciplinar, combinando aspectos de ingeniería del software, desarrollo web, bioinformática y aprendizaje automático. Además, el desarrollo del sistema me ha permitido profundizar en tecnologías y metodologías que van más allá de los contenidos de la carrera, especialmente en áreas relacionadas con arquitectura de software, sistemas asíncronos y despliegue de aplicaciones complejas.

Finalmente, considero especialmente satisfactorio haber podido contribuir a un campo tan relevante como el análisis genómico y la predicción de resistencia a antibióticos mediante el desarrollo de una herramienta orientada a facilitar la investigación y reducir la complejidad técnica de este tipo de procesos. Espero que este trabajo pueda servir como base para futuros desarrollos y contribuir al avance de herramientas accesibles dentro del ámbito de la bioinformática y la salud pública.
