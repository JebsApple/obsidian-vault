# DevOps

Extraído de `DevOps.pptx`

---

## Diapositiva 1

INGENIERÍA CIVIL EN INFORMÁTICA

## Diapositiva 2

ARICA - CHILE

## Diapositiva 3

DevOps
Patrick DeBois creó DevOps para combinar el desarrollo  y las operaciones.
DevOps intenta aplicar los principios del desarrollo ágil en toda la cadena de suministro de software.
Principales prácticas en DevOps:
Desarrollo continuo
Prueba continua
Integración continua
Entrega continua
Monitoreo continuo

## Diapositiva 4

Desarrollo continuo
Los entregables de software se desglosan y desarrollan en varios sprints; los incrementos se entregan a los miembros de aseguramiento de la calidad del equipo.

## Diapositiva 5

Prueba continua
Se usan herramientas de prueba automatizadas para que los miembros del equipo evalúen varios incrementos de código al mismo tiempo para asegurar que estén libres de defectos antes de la integración.

## Diapositiva 6

Integración continua (CI)
Las piezas de código con nueva funcionalidad se agregan al código existente y al entorno en tiempo de ejecución; posteriormente se revisan para asegurar que no haya errores después de la implementación.

## Diapositiva 7

Entrega continua (CD)
Se refiere al proceso de automatizar el despliegue de código en entornos de prueba o producción, asegurando que el software pueda ser entregado con alta frecuencia y sin interrupciones.

## Diapositiva 8

Monitoreo continuo
Ayuda a mejorar la calidad del software mediante un monitoreo de su rendimiento en el entorno de producción; además se busca de forma proactiva posibles problemas antes de que los usuarios los encuentren.

## Diapositiva 9

DevOps

## Diapositiva 10

Plan
Objetivo: Definir lo que se va a construir.
Esta fase implica planificar y priorizar las tareas que deben realizarse, lo cual se hace mediante la gestión de requerimientos.
Aquí se tratan temas como:
Requisitos de negocio.
Definición de nuevas funcionalidades.
Backlog de tareas o historias de usuario (en Scrum).
Planificación del alcance y tiempos.
Herramientas comunes:
Jira
Trello

## Diapositiva 11

Code
Objetivo: Escribir el código del software.
En esta fase los desarrolladores escriben el código fuente de la aplicación. El código es almacenado y gestionado en un repositorio de código fuente usando herramientas de control de versiones, generalmente Git.
Las actividades aquí incluyen:
Desarrollo de nuevas funcionalidades.
Refactorización de código.
Colaboración entre desarrolladores en ramas del repositorio.
Herramientas comunes:
Git (GitHub, GitLab, Bitbucket)
IDE (Visual Studio Code, IntelliJ IDEA, Eclipse)

## Diapositiva 12

Build
Objetivo: Compilar el código en artefactos ejecutables.
Esta fase implica compilar el código para que pueda ser ejecutado y probado. Dependiendo del lenguaje de programación y la tecnología utilizada, puede incluir:
Compilación de código fuente en binarios o ejecutables.
Generación de artefactos como archivos WAR, JAR, Docker images, etc.
Resolución de dependencias y otros recursos necesarios.
Herramientas comunes:
Maven, Gradle (para proyectos Java)
Docker (para contenedores)
Make, NPM, Webpack

## Diapositiva 13

Test
Objetivo: Verificar la calidad y el funcionamiento del software.
En esta fase se ejecutan pruebas para asegurar que el código funciona como se espera y no introduzca errores.
Se pueden realizar diferentes tipos de pruebas:
Pruebas unitarias (comprobación de funciones o métodos individuales).
Pruebas de integración (verificación de la interacción entre diferentes componentes).
Pruebas funcionales y de aceptación (comprobación de que el software cumple con los requisitos).
Herramientas comunes:
JUnit, TestNG (para Java)
Selenium, Cypress (para pruebas de frontend)
Postman (para pruebas de API)
SonarQube (para análisis estático de código)

## Diapositiva 14

Release
Objetivo: Preparar el software para su distribución.
En esta fase, el software se prepara para ser liberado a los usuarios finales. Las actividades incluyen:
Versionado del código.
Etiquetado en el sistema de control de versiones.
Revisión final de artefactos antes de su despliegue.
Herramientas comunes:
Git, GitHub
Jenkins, GitLab CI/CD

## Diapositiva 15

Deploy
Objetivo: Colocar el software en el entorno de producción.
El despliegue implica mover el software a un entorno de producción, donde estará disponible para los usuarios finales.
Este proceso puede ser:
Despliegue automático o manual.
Despliegue continuo en entornos de producción a medida que se hacen cambios.
Herramientas comunes:
Jenkins, GitLab CI/CD
Kubernetes, Docker (para gestionar contenedores y clústeres)

## Diapositiva 16

Operate
Objetivo: Gestionar el software en producción.
En esta fase, el software ya está en producción y es operado y mantenido.
Las actividades principales incluyen:
Monitoreo de la infraestructura y el rendimiento del software.
Resolución de incidentes o problemas que surjan.
Aplicación de parches y actualizaciones cuando sea necesario.
Herramientas comunes:
Kubernetes (para orquestación de contenedores)
AWS, Azure, Google Cloud (plataformas en la nube)
Nagios, Zabbix, Prometheus (para monitoreo)

## Diapositiva 17

Monitor
Objetivo: Supervisar el rendimiento y la estabilidad del software.
Después del despliegue, el monitoreo continuo es esencial para garantizar el rendimiento y detectar posibles fallos.
Las actividades en esta fase incluyen:
Monitoreo de logs y métricas en tiempo real.
Análisis de rendimiento de la aplicación.
Alertas proactivas cuando algo sale mal (errores, sobrecarga del sistema, etc.).
Herramientas comunes:
Prometheus, Grafana (para monitoreo y visualización)
ELK Stack (Elasticsearch, Logstash, Kibana) (de pago)
New Relic.
Amazon CloudWatch.

## Diapositiva 18

ARICA - CHILE

