# Orphaned Nodes — 47 nodos aislados (degree 0)

> **⚖ DECISIÓN (2026-07-14)**: Descartados como obsoletos — no se crearán edges:
> - **stversions internals** (diff_*, patch_*) → ruido de AST, ignorar (ya indicado abajo)
> - **Agentes MiNegocio** (c-architect, c-devops, c-sys-test) y **tareas HU01** (T04/T05/T08/T10) → MiNegocio está PAUSADO (portafolio); deuda de sprint cerrada, sin valor conectar
> - **Componentes frontend** (buscadorproductos.vue, carritocompras.vue, testing guide) → mismo motivo, proyecto pausado
> - **fork quickshell caelestia keyhint** → superado por caelestia-shell actual
>
> **Se conservan sin acción** (conocimiento vigente, conectar solo si se retoma el tema): UX 5 planos de Garrett, conditional marker system, plantilla ERS, requerimientos funcionales/no-funcionales.
> Los nodos permanecen en graph.json (reflejan archivos reales en 05-Archive); descartar = no invertir en conectarlos.

Estos nodos no tienen conexiones a ningún otro nodo. Son contenido huérfano que podría estar mal categorizado, ser obsoleto, o necesitar edges explícitos.

## Código fuente (no necesita edges — es AST)
- `.diff_fromdelta()`, `.diff_prettyhtml()`, `.diff_todelta()`, `.patch_fromtext()`, `.patch_totext()`
- Estos son functions del plugin stversions — el AST los extrajo como nodos aislados. **Acción: ignorar**

## MiNegocio — agentes y procedural knowledge
- **c-architect agent** — agente de arquitectura, no conectado a ningún proyecto
- **c-devops agent** — agente DevOps, no conectado
- **c-sys-test agent (qa)** — agente QA, no conectado
- **branch naming convention (spanish)** — convención de branches sin referencia
- **hu01-t04: sonarqube + jenkins (nicolas)** — tarea huérfana
- **hu01-t05: dead code cleanup (victor)** — tarea huérfana
- **hu01-t08: api endpoint documentation (ignacio)** — tarea huérfana
- **hu01-t10: spanish comments cleanup (victor)** — tarea huérfana

**Acción**: Estos nodos probablemente tenían edges que se perdieron o nunca se crearon. Conectarlos a sus proyectos/procedimientos padres.

## Frontend components
- **buscadorproductos.vue** — componente reutilizable sin conexiones
- **carritocompras.vue** — componente de carrito sin conexiones
- **frontend testing & screenshot guide** — guía huérfana

**Acción**: Conectar a la comunidad "MiNegocio Frontend" (community 4/12)

## Zettelkasten concepts
- **diseño de experiencia de usuario (UX) — 5 planos de Garrett** — concepto sin conexiones
- **conditional marker system** — sistema de markers visuales

**Acción**: Conectar a "Software Eng Concepts" (community 10)

## Other
- **fork de quickshell caelestia para keyhint** — script huérfano
- **plantilla ERS (especificación de requerimientos)** — template sin conexiones
- **requerimientos: funcionales y no funcionales** — concepto base sin conexiones

**Acción**: Evaluar si son relevantes o deben archivarse
