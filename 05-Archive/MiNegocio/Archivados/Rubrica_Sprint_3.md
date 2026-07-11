# Rúbrica Sprint 3

| Criterio | Descripción | Puntaje Óptimo |
| :--- | :--- | :---: |

## Gestión Scrum

| Definición historias de usuario | Las historias cumplen criterios INVEST, son comprensibles y entregan valor al usuario. | 5 |
| Asignación de responsable | Cada historia posee un responsable claramente identificado. | 3 |
| Revision QA historia de usuario | Existe evidencia de revisión y validación antes de marcar la historia como terminada. | 5 |
| Daily y seguimiento | Registro de avance y seguimiento continuo del trabajo durante el sprint. | 5 |
| Cumplimiento de historias anteriores | Cumplen las historias con deuda técnica | 5 |
| Cumplimiento de historias comprometidas | Las historias comprometidas para el sprint fueron completadas y demostradas en producción. | 3 |

## Gestión de repositorios

| Repositorio bd en gitea | Existe repositorio independiente para base de datos con acceso y organización adecuada. | 1 |
| Repositorio backend en gitea | Existe repositorio independiente para backend | 1 |
| Repositorio frontend en gitea | Existe repositorio independiente para frontend | 1 |
| Uso de ramas en los repositorios (front) | El trabajo se desarrolla en ramas distintas a main y permiten identificar la historia de usuario relacionada | 5 |
| Uso de ramas en los repositorios(back) | El trabajo se desarrolla en ramas distintas a main y permiten identificar la historia de usuario relacionada | 5 |
| Integración de ramas a main (front) | La integración a main utiliza exclusivamente Squash & Merge para mantener un historial limpio. | 5 |
| Integración de ramas a main (backend) | La integración a main utiliza exclusivamente Squash & Merge para mantener un historial limpio. | 5 |
| Calidad del historial Git (front) | Commits descriptivos y representativos en el tiempo del avance realizado. | 5 |
| Calidad del historial Git (back) | Commits descriptivos y representativos en el tiempo del avance realizado. | 5 |
| Versionado Semántico | El proyecto utiliza versión (ej. 1.0.0) y aumenta al pasar historias a producción. | 3 |

## Desarrollo software

| Calidad del código fuente (front) | Código organizado, legible. | 5 |
| Calidad del código fuente (back) | Código organizado, mantenible (por capas) | 5 |
| Calidad scripts de Base de Datos | Cada modificación del esquema posee scripts de migración y rollback | 5 |

## Calidad de la Implementación (Frontend)

| Consistencia visual. | Mantiene diseño homogéneo y coherente entre pantallas. | 3 |
| Navegación intuitiva. | El flujo de uso es claro y fácil de comprender para el usuario. | 3 |
| Validaciones visibles. | Se validan datos obligatorios y formatos de formularios | 3 |
| Mensajes de error comprensibles. | Los errores informan claramente el problema al usuario. | 3 |
| Limpieza en el código | No hay bloques de código muertos o líneas comentadas que no se utilicen | 3 |
| Buenas Practicas | Tiene nombres descriptivos para clases, métodos y variables | 3 |
| Versión | El cambio de versión es visible | 1 |

## Calidad de la Implementación (Backend)

| Comentarios en el código | Hay comentarios claros y útiles en los principales métodos, clases o bloques de lógica | 3 |
| Limpieza en el código | No hay bloques de código muertos o líneas comentadas que no se utilicen | 3 |
| Configuración y seguridad | El token de seguridad debe ser usado para todas las llamadas a la api | 3 |
| Buenas Practicas | Tiene nombres descriptivos para clases, métodos y variables | 3 |
| Log | Registro persistente en archivos del servidor con niveles INFO, WARN y ERROR. No sólo impresión por consola. | 3 |
| Variables de entorno | Utiliza correctamente las credenciales para conectar a bd (usuario para dev y usuario para prod) | 3 |
| Versión | El cambio de versión es visible | 1 |

## Testing y Calidad

| Evidencia Front | Capturas mostrando el funcionamiento de la interfaz. | 3 |
| Evidencia Backend | Capturas de Postman mostrando pruebas exitosas. | 3 |
| Evidencia Base de Datos | Capturas de inserciones o consultas realizadas. | 3 |
| Test Unitarios Backend | Cobertura de  servicios principales mediante pruebas unitarias. | 3 |
| SonarQube | Proyecto analizado exitosamente desde local y sin errores críticos. | 3 |
| Calidad Sonar | Sin Bugs críticos y deuda técnica aceptable. 80% cobertura | 3 |

## DevOps

| Aislamiento de entornos | Existen ambientes diferenciados para desarrollo y producción. | 3 |
| Despliegue en dev | La aplicación se encuentra operativa en ambiente de desarrollo. | 3 |
| Despliegue en prod | La aplicación se encuentra desplegada y funcionando en producción. | 5 |
| Configuración de pipeline Jenkins Front | pipeline en front que permita automatizar el proceso de construcción, validación y despliegue | 5 |
| Compilación y construcción automática Front | obtener el código desde el repositorio y ejecutar con un usuario diferente a icin (el root del servidor) | 5 |
| Automatización del despliegue Front | permite desplegar en el servidor b automáticamente | 5 |
| Configuración de pipeline Jenkins Back | pipeline en backend que permita automatizar el proceso de construcción, validación y despliegue | 5 |
| Compilación y construcción automática Back | obtener el código desde el repositorio y ejecutar con un usuario diferente a icin (el root del servidor) | 5 |
| SonarQube | El despliegue del backend pasa por sonarqube y recibe la aprobación de quality gate | 3 |
| Automatización del despliegue Back | permite desplegar en el servidor b automáticamente | 5 |

## Documentación

| README Front |  | 21 |
| README Back |  | 26 |

## Funcionalidad del Sprint

| Dashboard | Presenta indicadores relevantes del sistema. | 3 |
| Exportación PDF | Permite exportar el dashboard o reporte a PDF. | 3 |
| Exportación Excel | Permite exportar el dashboard o reporte a Excel. | 3 |
| Calidad del dashboard | Información útil, visualmente clara y correctamente calculada. | 3 |
| Presentación |  | 18 |
| Readme contenido | Front |  |
| Descripción del sistema. | 1 | 1 |
| Arquitectura. | 1 | 1 |
| Tecnologías utilizadas. | 1 | 1 |
| Requisitos previos. | 1 | 1 |
| Instalación. | 1 | 1 |
| Configuración de variables de entorno. | 1 | 1 |
| Rutas – se identifican principales archivos o directorios en el servidor, logs, backend dev/prod, front dev/prod, nginx. | 3 | 3 |
| Cómo levantar Frontend. Local | 3 | 0 |
| Cómo levantar Backend. Local | 0 | 3 |
| Cómo levantar Frontend. Dev | 3 | 0 |
| Cómo levantar Backend. Dev | 0 | 3 |
| Cómo conectarse a la BD. | 0 | 3 |
| Cómo ejecutar migraciones. De BD | 0 | 1 |
| URLs de Desarrollo. | 1 | 1 |
| URLs de Producción. | 1 | 1 |
| Credenciales de prueba. | 1 | 0 |
| Cómo ejecutar pruebas unitarias. (solo backend) | 0 | 1 |
| Cómo ejecutar SonarScanner desde local. (solo backend) | 0 | 1 |
| Cómo desplegar en Producción. | 3 | 3 |
|  | 21 | 26 |
