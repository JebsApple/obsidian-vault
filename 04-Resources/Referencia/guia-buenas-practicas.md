# Guía de Buenas Prácticas para Proyectos de Software

> Destilación de conocimientos a partir de materiales académicos y experiencia práctica en ingeniería de software. Complementado con investigación actualizada sobre la industria.

---

## 1. Levantamiento de Requerimientos

### 1.1 Principios de comunicación con stakeholders

La comunicación efectiva es la actividad más desafiante en el desarrollo de software. Principios clave:

- **Escuchar activamente**: entender el punto de vista de la otra parte, evitar interrumpir, prestar atención a lo que no se dice explícitamente.
- **Prepararse antes de comunicarse**: entender el problema antes de la reunión, investigar la jerga del cliente, llevar agenda y preguntas clave.
- **Alguien debe facilitar**: toda reunión necesita un líder que mantenga el foco y medie conflictos.
- **Cara a cara**: la comunicación presencial (o videollamada) funciona mejor, sobre todo con un dibujo o borrador como centro de discusión.
- **Tomar notas y documentar**: asignar a alguien para registrar puntos y decisiones. Usar actas de reunión.
- **Buscar colaboración, no imponer**: el conocimiento colectivo del equipo describe mejor el sistema. Hacer preguntas abiertas ("¿Qué opinas?", "¿Qué otras opciones vemos?").
- **Mantener el foco**: entre más participantes, más probable que la conversación salte de tema. El facilitador debe mantener un solo punto de discusión a la vez.
- **Si algo no está claro, dibujar**: un bosquejo aclara cuando las palabras no alcanzan.
- **Saber pasar al siguiente punto**: si no hay acuerdo o algo no se puede aclarar ahora, pasar a lo siguiente. La comunicación lleva tiempo.
- **Negociación win-win**: no es un concurso ni un juego. Entender lo que es importante para cada parte, comunicar límites técnicos con claridad, buscar soluciones que maximicen valor dentro de los recursos disponibles.

### 1.2 Identificación de stakeholders

Los interesados son todas las personas, grupos u organizaciones que afectan o se ven afectadas por el sistema.

- La lista inicial crecerá a medida que se contacte a las partes interesadas. Preguntar siempre: "¿Con quién más piensa que debería hablar?"
- Cada stakeholder ve el sistema desde su propio contexto: el médico quiere agilidad, la recepcionista quiere una agenda fácil, el administrador quiere reportes.
- **Error común**: hablar solo con el stakeholder más ruidoso. La persona con más opiniones rara vez es la que tiene más contexto.

### 1.3 Tipos de preguntas para romper el hielo

- **Preguntas libres de contexto**: ¿Quién está detrás de la solicitud? ¿Quién usará la solución? ¿Cuál será el beneficio económico? ¿Hay otra fuente para la solución?
- **Preguntas de efectividad**: ¿Son relevantes mis preguntas? ¿Estoy haciendo demasiadas? ¿Puede alguien más proveer información adicional?

### 1.4 Requerimientos funcionales vs no funcionales

**Funcionales**: servicios que el sistema debe proveer, cómo debe reaccionar a entradas, cómo comportarse en situaciones específicas.

**No funcionales**: limitaciones sobre servicios o funciones. Categorías comunes:
- Rendimiento (tiempo de respuesta, concurrencia)
- Usabilidad (facilidad de uso)
- Seguridad (cifrado, autenticación)
- Mantenibilidad (modularidad del código)
- Portabilidad (distintos SO)
- Disponibilidad (uptime)
- Escalabilidad

**Error frecuente**: saltarse los requerimientos no funcionales. Rendimiento, seguridad, accesibilidad, observabilidad y cumplimiento normativo son sistemáticamente subestimados y se convierten en emergencias después.

### 1.5 Errores comunes en el levantamiento

- **Hablar solo con el stakeholder más ruidoso** — mapear stakeholders antes de agendar entrevistas.
- **Asumir "es igual que la vez pasada"** — la familiaridad con el dominio hace que los analistas pasen por alto diferencias críticas.
- **Saltarse los no funcionales** — siempre se vuelven emergencias tarde o temprano.
- **Tratar "lo queremos en WordPress" como requerimiento** — los stakeholders suelen plantear soluciones cuando en realidad describen problemas. Preguntar "por qué" hasta que el problema sea visible.
- **Detenerse cuando todos están de acuerdo** — el acuerdo rápido suele ser señal de profundidad insuficiente, no de alineación real. Explorar casos borde y modos de falla antes de declarar consenso.
- **Decir "sí" a todo sin explicar el esfuerzo** — lleva a compromisos imposibles, retrasos y software de baja calidad.

---

## 2. Modelado y Arquitectura

### 2.1 Principios de diseño

1. **El diseño debe rastrearse hasta el modelo de requerimientos** — cada clase, módulo o componente debe relacionarse con un requerimiento. No crear componentes que no respondan a una necesidad.
2. **Considerar siempre la arquitectura del sistema** — el diseño debe alinearse con la arquitectura general (capas, microservicios, cliente-servidor).
3. **El diseño de datos es tan importante como el de funciones** — modelar correctamente clases, atributos y relaciones evita errores futuros.
4. **Las interfaces deben diseñarse con cuidado** — versionar APIs, documentar con OpenAPI/Swagger, mantener compatibilidad hacia atrás.
5. **La UI debe ajustarse al usuario final** — la UX no es solo "que se vea bonita", sino que sea intuitiva, rápida y accesible.
6. **Independencia funcional** — cada componente debe tener una responsabilidad clara. Una clase debe hacer una sola cosa.
7. **Bajo acoplamiento** — los componentes deben depender lo menos posible unos de otros. Usar interfaces e inyección de dependencias.
8. **Modelos entendibles** — diagramas y documentación deben ser simples y claros, incluso para no desarrolladores.
9. **Diseño iterativo** — no necesitas el diseño completo desde el inicio. Mejorar y detallar con el tiempo.
10. **El modelado no impide ágil** — tener diagramas ligeros no contradice Scrum o XP. Ayuda a mantener el sistema.

### 2.2 Diagramas UML esenciales

| Diagrama | Propósito |
|----------|-----------|
| **Casos de Uso** | Interacción actores-sistema, visión de alto nivel de funcionalidades |
| **Clases** | Estructura estática: clases, atributos, métodos, relaciones |
| **Secuencia** | Interacción entre objetos a lo largo del tiempo para un caso de uso |
| **Actividades** | Flujo de actividades o pasos para completar un proceso |
| **Paquetes** | Organización jerárquica, capas, dependencias entre módulos |
| **Despliegue** | Asignación de artefactos de software a nodos físicos |

### 2.3 Relaciones entre clases

- **Asociación simple**: relación entre clases (línea sólida)
- **Asociación dirigida**: flecha que indica dirección de la relación
- **Herencia/Generalización**: padre-hijo (flecha vacía)
- **Agregación**: "parte de" (diamante vacío). Las partes pueden existir sin el todo.
- **Composición**: las partes viven y mueren con el todo (diamante relleno)
- **Dependencia**: relación temporal (línea discontinua)
- **Multiplicidad**: 1, 0..1, 0..\*, 1..\*

### 2.4 Diagrama de paquetes para capas

Útil para visualizar:
- Capas del sistema (presentación, lógica de negocio, acceso a datos)
- Dependencias y evitar acoplamientos innecesarios
- Planificar mantenimiento y evolución arquitectónica

---

## 3. Metodologías de Desarrollo

### 3.1 Manifiesto Ágil (2001)

Valoramos más:
- **Individuos e interacciones** que procesos y herramientas
- **Software funcionando** que documentación exhaustiva
- **Colaboración con el cliente** que negociación de contrato
- **Respuesta al cambio** que seguir un plan

### 3.2 Los 12 principios del desarrollo ágil

1. Prioridad: satisfacer al cliente con entregas tempranas y continuas
2. Bienvenidos los cambios, incluso tardíos
3. Entregar software funcional con frecuencia (semanas a meses)
4. Negocios y desarrolladores trabajan juntos diariamente
5. Individuos motivados, con apoyo y confianza
6. Conversación cara a cara es el método más eficiente
7. Software funcionando es la medida principal de avance
8. Desarrollo sostenible: ritmo constante indefinidamente
9. Excelencia técnica y buen diseño mejoran la agilidad
10. Simplicidad: maximizar el trabajo no realizado
11. Las mejores arquitecturas surgen de equipos autoorganizados
12. El equipo reflexiona regularmente y ajusta su comportamiento

### 3.3 Scrum

**Roles**:
- **Product Owner**: define y prioriza requisitos, maximiza valor del negocio
- **Scrum Master**: facilita, elimina impedimentos, asegura que Scrum se aplique correctamente
- **Equipo de Desarrollo**: autoorganizado, multidisciplinario, 3-6 personas

**Artefactos**:
- **Product Backlog**: lista priorizada de historias de usuario
- **Sprint Backlog**: historias seleccionadas para el sprint activo (no se agregan nuevas)
- **Incremento**: producto funcional al final del sprint, debe cumplir la Definition of Done (DoD)

**Eventos**:
- **Sprint Planning**: el equipo selecciona qué trabajar, despeja dudas, estima complejidad
- **Daily Scrum**: 15 minutos, 3 preguntas: ¿qué hice ayer? ¿qué haré hoy? ¿tengo impedimentos?
- **Sprint Review**: presentar el incremento a interesados, recibir retroalimentación
- **Sprint Retrospective**: el equipo analiza qué estuvo bien, qué mejorar, compromisos para el próximo sprint

**Historias de Usuario**: formato "Como [rol], quiero [acción] para [beneficio]". Deben cumplir INVEST:
- **I**ndependiente
- **N**egociable
- **V**aliosa
- **E**stimable
- **S**mall (pequeña)
- **T**esteable

### 3.4 Kanban

- Visualizar el flujo de trabajo (columnas: Pendiente, En progreso, Terminado)
- Limitar el trabajo en progreso (WIP) para evitar sobrecarga
- Gestionar el flujo: identificar cuellos de botella
- Políticas explícitas para mover tareas entre columnas
- Mejora continua: revisar y ajustar regularmente

### 3.5 Extreme Programming (XP)

- **Planeación**: historias de usuario, priorización, estimación, iteraciones cortas
- **Diseño**: simple, refactorización constante, CRC Cards
- **Codificación**: programación en pares, propiedad colectiva del código, integración continua
- **Pruebas**: TDD (escribir pruebas antes de programar), pruebas automatizadas, pruebas de aceptación del cliente

### 3.6 Modelo en Cascada

Apropiado cuando:
- El problema se entiende bien
- Los requerimientos están bien definidos y son estables

Limitaciones:
- Rara vez se sigue realmente secuencial
- Difícil para el cliente indicar todos los requerimientos al inicio
- Errores graves no se detectan hasta etapas avanzadas

### 3.7 Prototipado

Útil para identificar requerimientos cuando no están claros. Riesgos:
- Los interesados pueden confundir el prototipo con la versión final
- Se pierde de vista la calidad y mantenibilidad
- Tentación de tomar atajos para que el prototipo funcione rápido

### 3.8 Modelo en Espiral

Acopla la naturaleza iterativa de los prototipos con el control del cascada. Requiere experiencia considerable en evaluación de riesgos.

---

## 4. Calidad del Software

### 4.1 ¿Qué es calidad?

David Garvin propuso 5 visiones:
- **Trascendental**: excelencia innata, se percibe por experiencia
- **Del usuario**: se adapta a las necesidades del consumidor
- **Del fabricante**: hacer las cosas bien desde la primera vez
- **Del producto**: cantidad de atributos valiosos que posee
- **Basada en el valor**: rendimiento aceptable a un precio justo

### 4.2 Calidad del diseño vs calidad del software

- **Calidad del diseño**: grado en que el software cumple funciones y características especificadas en el modelo de requerimientos
- **Calidad del software**: proceso efectivo + producto útil + valor cuantificable

Satisfacción del usuario = producto funcional + buena calidad + entrega a tiempo y dentro del presupuesto

### 4.3 Costo de la Calidad (CoQ)

El CoQ no es solo lo que se gasta en calidad, sino también el costo de **no hacer las cosas bien desde el principio**.

| Categoría | Descripción | Ejemplos |
|-----------|-------------|----------|
| **Prevención** | Evitar errores antes de que ocurran | Capacitación, revisión de req., diseño sólido, estándares, automatización de pruebas, SonarQube |
| **Evaluación** | Verificar que se cumplan estándares | Pruebas unitarias/integración/sistema, code review, auditorías |
| **Fallo Interno** | Errores detectados antes de entrega | Tiempo corrigiendo bugs, retrabajo, rediseños, fallas en build |
| **Fallo Externo** | Errores detectados en producción | Soporte técnico, pérdida de clientes, daño a reputación, penalizaciones, vulnerabilidades explotadas |

**Objetivo**: minimizar el costo total. Invertir más en prevención y evaluación para reducir fallos. Es más barato prevenir errores que corregirlos tarde.

**Regla general**: 1 USD en prevención = 10 USD en fallo interno = 100 USD en fallo externo.

### 4.4 El dilema de la calidad

- Calidad terrible → nadie lo compra
- Calidad perfecta → demasiado tiempo y costo, el negocio quiebra
- **Punto óptimo**: producto "suficientemente bueno" que ofrece las funciones de alta calidad que los usuarios desean, con errores menores conocidos en funciones menos críticas

### 4.5 Proceso efectivo: tres pilares

1. **Gestión y controles**: fechas, roles, organización (evita el caos)
2. **Prácticas de ingeniería**: analizar antes de programar, diseñar soluciones sólidas
3. **Actividades paraguas**: code review, control de cambios, mediciones, gestión de configuración

---

## 5. Pruebas y Automatización

### 5.1 Beneficios de la automatización

- **Rapidez**: ejecución mucho más rápida que manual
- **Repetibilidad**: resultados consistentes tantas veces como sea necesario
- **Cobertura**: múltiples escenarios y configuraciones
- **Detección temprana**: errores identificados rápido durante el desarrollo
- **Ahorro a largo plazo**: inversión inicial que se recupera en fases posteriores
- **Soporte a CI/CD**: las pruebas automatizadas validan cada cambio en el pipeline

### 5.2 Retos

- Costos iniciales de implementación
- Mantenimiento: cambios en la aplicación pueden romper scripts
- No apto para todo: pruebas exploratorias y de usabilidad difíciles de automatizar
- Curva de aprendizaje del equipo

### 5.3 Tipos de pruebas en el pipeline

- **Unitarias**: funciones o métodos individuales (JUnit, pytest)
- **Integración**: interacción entre componentes
- **Funcionales y de aceptación**: cumplimiento de requisitos
- **Frontend**: Selenium, Cypress
- **API**: Postman
- **Análisis estático**: SonarQube

### 5.4 SonarQube

Plataforma de análisis continuo de código que:
- Evalúa calidad y seguridad del código fuente
- Identifica bugs, vulnerabilidades, code smells
- Se integra con CI/CD para análisis automático tras cada cambio
- Bloquea despliegues si no se cumplen estándares
- Previene deuda técnica acumulada

### 5.5 Estrategia de pruebas QA

**Preventive QA** (antes del defecto): revisiones de requerimientos, diseño reviews, code reviews, análisis estático, definición de criterios de aceptación.

**Detective QA** (después del defecto): pruebas de regresión, pruebas exploratorias, monitoreo en producción.

**Regla**: prevenir temprano, detectar continuamente, aprender de cada escape.

---

## 6. Código Limpio

### 6.1 Principios fundamentales

| Principio | Descripción | Beneficios |
|-----------|-------------|------------|
| **DRY** | No repetirse. Cada pieza de conocimiento tiene una representación única. | Cambios rápidos y seguros, menor volumen, más fácil de probar |
| **KISS** | Mantenerlo simple. El código simple es más comprensible, confiable y fácil de mantener. | Facilita lectura y revisión, reduce errores |
| **YAGNI** | No lo vas a necesitar. No anticipar requisitos que nunca se usan. | Menos código que mantener, desarrollo más rápido |
| **Regla de las Tres** | Extraer a función/método al tercer uso del mismo bloque. | Reduce errores, mejora claridad |

### 6.2 Principios SOLID

| Letra | Principio | Idea central |
|-------|-----------|--------------|
| **S** | Single Responsibility | Una clase debe tener una sola razón para cambiar |
| **O** | Open/Closed | Abierta para extensión, cerrada para modificación |
| **L** | Liskov Substitution | Una subclase debe poder reemplazar a su padre sin romper el sistema |
| **I** | Interface Segregation | Interfaces pequeñas y específicas, no una grande con todo |
| **D** | Dependency Inversion | Depender de abstracciones, no de implementaciones concretas |

### 6.3 Prácticas de código limpio

- **Nombres significativos**: `calcularArea(base, altura)` es mejor que `f(a, b)`. Los nombres son la principal fuente de comunicación entre personas que leen código.
- **Funciones pequeñas**: una función debe hacer una sola cosa. Funciones largas mezclan responsabilidades y son difíciles de probar.
- **Separación de preocupaciones**: no mezclar lógica de negocio con interfaz o acceso a datos. Capas independientes = mejor mantenimiento.
- **Refactorización continua**: el código se deteriora con el tiempo. Refactorizar mantiene un diseño saludable sin cambiar el comportamiento externo.
- **Comentarios útiles**: el código debería explicarse solo. Los comentarios deben explicar el "por qué", no el "qué".

### 6.4 Patrón Singleton

Útil para: conexión única a BD, manejador de configuración global, logger. Ventajas: control total sobre la instancia, recursos compartidos. Desventajas: dificulta el testing (no se puede mockear fácilmente), rompe inyección de dependencias, puede convertirse en antipatrón si se abusa.

---

## 7. DevOps

### 7.1 Las prácticas continuas

| Práctica | Descripción |
|----------|-------------|
| **Desarrollo continuo** | Entregables desglosados en sprints, incrementos entregados a QA |
| **Prueba continua** | Herramientas automatizadas evalúan incrementos en paralelo |
| **Integración continua (CI)** | Código nuevo se integra al existente y se revisa para detectar errores |
| **Entrega continua (CD)** | Automatizar el despliegue a entornos de prueba o producción |
| **Monitoreo continuo** | Supervisar rendimiento en producción, buscar problemas antes que los usuarios |

### 7.2 Ciclo DevOps completo

1. **Plan**: definir qué construir, gestión de requerimientos (Jira, Trello)
2. **Code**: escribir código, control de versiones (Git)
3. **Build**: compilar en artefactos ejecutables (Maven, Gradle, Docker)
4. **Test**: ejecutar pruebas automatizadas (JUnit, Selenium, SonarQube)
5. **Release**: versionado, etiquetado, revisión final
6. **Deploy**: desplegar a producción (automático o manual)
7. **Operate**: gestionar en producción (Kubernetes, AWS, Azure)
8. **Monitor**: supervisar logs, métricas, alertas (Prometheus, Grafana, ELK)

### 7.3 Herramientas comunes por fase

| Fase | Herramientas |
|------|--------------|
| Plan | Jira, Trello |
| Code | Git, GitHub, VS Code |
| Build | Maven, Gradle, Docker, NPM, Webpack |
| Test | JUnit, Selenium, Cypress, Postman, SonarQube |
| Release | Git, Jenkins, GitLab CI/CD |
| Deploy | Jenkins, Kubernetes, Docker |
| Operate | Kubernetes, AWS, Azure, GCP |
| Monitor | Prometheus, Grafana, ELK, New Relic, CloudWatch |

---

## 8. Experiencia de Usuario (UX)

### 8.1 Los 5 planos del diseño UX (Jesse James Garrett)

1. **Estrategia** (abstracto): objetivos del producto, necesidades del usuario. Fuentes: entrevistas, encuestas.
2. **Alcance**: funcionalidades y contenido. Fuentes: requerimientos funcionales, historias de usuario.
3. **Estructura**: cómo se organiza y navega. Fuentes: mapas de sitio, diagramas de flujo.
4. **Esqueleto**: wireframes, diseño de navegación, layout. Herramientas: Figma, Balsamiq, Adobe XD.
5. **Superficie** (concreto): apariencia visual, prototipos de alta fidelidad, guías de estilo.

### 8.2 Características de una buena UX

- **Usable**: fácil de usar, autoexplicativo
- **Agradable**: que den ganas de usarlo
- **Inclusivo**: que todas las personas puedan usarlo (idioma, capacidades, cultura)
- **Útil**: que tenga una utilidad clara

### 8.3 Reglas doradas de interacción

Las reglas doradas son principios de diseño; los mecanismos de interacción son los componentes de la interfaz (botones, menús, formularios) que permiten aplicar esos principios.

---

## 9. Gestión de Riesgos

### 9.1 Tipos de riesgos en proyectos de software

1. **Personal/equipo**: falta de experiencia, alta rotación, conflictos, poca disponibilidad de expertos
2. **Técnicos**: tecnologías nuevas o poco probadas, problemas de integración, requerimientos no claros, cambios de plataforma
3. **Planificación**: estimaciones incorrectas, fechas poco realistas, mala asignación de tareas
4. **Financieros**: cambios en presupuesto, aumento inesperado de costos, retrasos que aumentan gasto
5. **Requerimientos**: requisitos cambiantes o mal definidos, clientes que no se comunican claro, cambios frecuentes
6. **Calidad**: ausencia de pruebas adecuadas, errores que llegan a producción, incumplimiento normativo

### 9.2 Presión gerencial y plazos

Cuando existe presión por acortar tiempos, el equipo tiende a tomar atajos y omitir actividades de calidad. Si una fecha es irracional:
- Mantenerse firme y explicar por qué se necesita más tiempo
- Sugerir un subconjunto de funcionalidades de alta calidad que pueda entregarse en el plazo
- Documentar formalmente los cambios en requerimientos y su impacto en cronograma y presupuesto

### 9.3 Actividades paraguas (protección continua)

- Seguimiento y control del proyecto
- Gestión de riesgos
- Aseguramiento de la calidad
- Revisiones técnicas (code review)
- Mediciones (puntos de función, velocidad del equipo)
- Gestión de la configuración (Git)
- Gestión de la reutilización (librerías, módulos)
- Preparación de documentación e informes

---

## 10. Ingeniería de Software: Fundamentos

### 10.1 Capas de la ingeniería de software

1. **Calidad** (base): confiabilidad, mantenibilidad, eficiencia
2. **Procesos**: actividades para desarrollar software efectivamente
3. **Métodos**: técnicas de análisis, diseño, implementación, prueba, mantenimiento
4. **Herramientas**: soporte automatizado (IDEs, Git, CI/CD, SonarQube)

### 10.2 Marco de trabajo del proceso

- **Comunicación**: entender objetivos, reunir requerimientos
- **Planeación**: describir tareas, riesgos, recursos, programación
- **Modelado**: crear modelos para entender requerimientos y diseño
- **Construcción**: generar código y pruebas
- **Implementación**: entregar software, evaluar, recibir retroalimentación

### 10.3 Atributos de calidad del software

- **Mantenibilidad**: el software debe poder evolucionar para satisfacer necesidades cambiantes
- **Confiabilidad y seguridad**: no causar daño físico/económico en caso de falla; usuarios malintencionados no deben poder acceder
- **Eficiencia**: no desperdiciar recursos del sistema (memoria, CPU)
- **Aceptabilidad**: comprensible, utilizable, compatible con otros sistemas

### 10.4 Siete principios de Hooker

1. **La razón de que exista todo**: el software existe para proveer valor a los usuarios
2. **KISS**: mantenerlo simple
3. **Mantener la visión**: no perder de vista la arquitectura y objetivos
4. **Lo que usted produzca, otros lo consumirán**: escribir código pensando en quienes lo leerán
5. **Estar abierto al futuro**: diseñar pensando en cambios
6. **Planear pensando en la reutilización**: anticipar componentes reutilizables
7. **Pensar!**: no programar en automático, pensar antes de actuar

---

## 11. Checklist por Fase del Proyecto

### Inicio / Levantamiento
- [ ] Mapear todos los stakeholders relevantes
- [ ] Preparar agenda y preguntas clave antes de cada reunión
- [ ] Documentar decisiones en actas
- [ ] Distinguir funcionales de no funcionales
- [ ] Validar requerimientos con prototipos o borradores
- [ ] No decir "sí" a todo sin explicar esfuerzo
- [ ] Explorar casos borde antes de declarar consenso

### Diseño / Arquitectura
- [ ] Cada componente se traza a un requerimiento
- [ ] La arquitectura está definida (capas, microservicios, etc.)
- [ ] Las interfaces están versionadas y documentadas
- [ ] Diagramas UML necesarios están creados
- [ ] Se aplican principios SOLID y bajo acoplamiento
- [ ] Diseño de datos validado (clases, relaciones, multiplicidad)

### Desarrollo
- [ ] Se siguen DRY, KISS, YAGNI
- [ ] Nombres significativos en todo el código
- [ ] Funciones pequeñas con una sola responsabilidad
- [ ] Separación de preocupaciones (capas)
- [ ] Code review antes de fusionar
- [ ] Pruebas unitarias escritas (TDD idealmente)
- [ ] Refactorización continua

### Pruebas / QA
- [ ] Pruebas unitarias, integración, funcionales automatizadas
- [ ] Análisis estático con SonarQube o similar
- [ ] Pruebas de regresión en CI/CD
- [ ] Cobertura mínima definida (70-80%)
- [ ] Pruebas de aceptación validadas con el cliente

### Despliegue / Operaciones
- [ ] Pipeline CI/CD configurado
- [ ] Artefactos versionados y etiquetados
- [ ] Monitoreo en producción (logs, métricas, alertas)
- [ ] Plan de rollback definido
- [ ] Documentación de operación actualizada

### Post-lanzamiento
- [ ] Retrospectiva del equipo
- [ ] Deuda técnica documentada
- [ ] Lecciones aprendidas registradas
- [ ] Plan de mejoras para siguiente iteración
