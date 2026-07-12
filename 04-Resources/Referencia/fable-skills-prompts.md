---
tags:
  - referencia/claude
  - referencia/fable
  - referencia/skills
  - referencia/prompts
date: 2026-07-12
source: tododeia.com
---

# Fable 5 — Skills y Prompts adicionales

Skills instaladas + prompts personalizados para proyectos propios.

## Skills instaladas en ~/.claude/skills/

| Skill | Archivo | Para qué |
|-------|---------|----------|
| fable-chequeo-seguridad | `~/.claude/skills/fable-chequeo-seguridad/SKILL.md` | Auditoría de seguridad del código |
| fable-arranque | `~/.claude/skills/fable-arranque/SKILL.md` | Empaquetar un proyecto nuevo |
| fable-plan | `~/.claude/skills/fable-plan/SKILL.md` | Planes antes de construir |
| fable-abogado-del-diablo | `~/.claude/skills/fable-abogado-del-diablo/SKILL.md` | Crítica constructiva a ideas |
| fable-fixer | `~/.claude/skills/fable-fixer/SKILL.md` | Arreglo de bugs con evidencia |

---

## Skills adicionales (de tododeia.com)

### Skill Creator — la meta-skill

Crea skills a partir de un archivo o descripción simple.

**De un archivo:**
```
Usa skill-creator. Te adjunto un archivo con [QUÉ ES: tu manual, tu plantilla, tu proceso].
Conviértelo en una skill completa que pueda usar contigo desde hoy.
Si al archivo le falta información, pregúntame lo que necesites.
Al final dime cómo se llama la skill, qué hace y con qué frase la activo.
```

**De una descripción:**
```
Usa skill-creator. Quiero una skill que haga esto:
[DESCRIBE EL PROCESO CON TUS PALABRAS, COMO SE LO CONTARÍAS A UN ASISTENTE NUEVO EN SU PRIMER DÍA].

Hazme las preguntas que te falten.
Cuando la tengas, muéstramela completa y explícame en una línea cuándo se va a activar sola.
```

### Documentos con tu formato

Le enseñas tu estilo una vez y lo repite siempre.

```
Créame una habilidad (skill) para que cada vez que te pida un reporte
lo armes con mi estructura y mi tono, sin que yo tenga que explicártelo de nuevo.

Antes de escribirla, hazme las preguntas que necesites sobre mi formato:
secciones, orden, extensión, tono y a quién va dirigido.
Después pídeme 1 o 2 reportes míos de referencia para copiar el estilo real.

Cuando la tengas lista, muéstrame la skill completa y dime exactamente
cómo se va a activar la próxima vez que te pida un reporte.
```

### Proceso de varios pasos con plan B

Flujos con manejo de errores integrado.

```
Créame una habilidad (skill) para [TU PROCESO]. El proceso siempre va en este orden:

Paso 1: [PRIMER PASO CON DATOS NECESARIOS].
Paso 2: [SEGUNDO PASO].
Paso 3: [TERCER PASO].

Escribe la skill de forma que los pasos se sigan siempre en ese orden
y que no se pase al siguiente sin terminar el anterior.
Si un paso necesita algo que solo yo tengo, pregúntame en vez de inventarlo.
```

**Agregar plan B:**
```
A la skill de [NOMBRE] agrégale manejo de errores:
Si el paso 2 falla porque [LO QUE PUEDE FALLAR], entonces [LA ALTERNATIVA].
Si el paso 3 falla porque [LO QUE PUEDE FALLAR], entonces [LA ALTERNATIVA].
Si pasa algo fuera de la lista, detente y avísame.
```

### Abogado del Diablo (versión completa de 8 ángulos)

Más completa que la versión Fable. Incluye pre-mortem y punto ciego.

```
Vas a actuar como mi Abogado del Diablo. Olvida el modo amable.

REGLAS:
- Prohibido validarme, felicitarme o abrir con algo positivo.
- Asume que mi idea va a fracasar y propónte demostrarlo.
- Sé brutal con la idea, nunca conmigo.

CRITÍCAME POR ESTOS OCHO ÁNGULOS:
1. Premisas falsas: qué doy por hecho que podría no ser cierto.
2. Mercado: ¿le duele a alguien de verdad o solo le incomoda?
3. Competencia: quién ya lo hace mejor, más barato o primero.
4. Viabilidad: qué se rompe en la práctica.
5. Números: ¿cierra la economía?
6. Ejecución: ¿yo, con estos recursos, puedo lograrlo?
7. Pre-mortem: es 12 meses después y fracasó; cuéntame la autopsia.
8. Punto ciego: qué estoy evitando pensar.

ENTRÉGAME EN ESTE ORDEN:
- VEREDICTO sin anestesia.
- LAS GRIETAS ordenadas por severidad.
- LA QUE LO MATA.
- SI INSISTO, ARREGLA ESTO PRIMERO.

Aquí está mi idea: [PEGA TU IDEA]
```

---

## Prompts personalizados para proyectos propios

### Para la web de la iglesia

```
Estoy trabajando en la web de una iglesia para su congregación.
Necesitan una página clara que comunique horarios, eventos y
contacto sin confundir a personas mayores.

Cada vez que te pida contenido para la iglesia (avisos, horarios,
eventos), escríbelo en este tono: cálido pero directo, sin
jerga religiosa complicada, pensado para leerse en un celular.
Máximo 100 palabras por sección.
```

### Para Lucierna (app de oración)

```
Estoy construyendo Lucierna, una app de turnos de oración nocturna
por relevo para ~30 personas de una iglesia. Flutter + Supabase.
Android-first.

Cada vez que diseñes una feature nueva para Lucierna, respeta:
- Flujo vertical completo antes que piezas sueltas
- Offline-first: que funcione sin internet y sincronice después
- Accesibilidad: contraste alto, texto grande, sin animaciones
- Lo más simple que funcione: sin abstracciones innecesarias
```

---

## Los 4 principios de Fable 5 (resumen rápido)

1. **Prompts cortos** — un párrafo claro le gana a tres páginas
2. **Objetivo + porqué** — no dictes pasos, dile qué quieres lograr
3. **Márcale límites** — qué no puede tocar y cuándo preguntar
4. **Pídele evidencia** — "ya quedó" sin prueba no cuenta

---

## Instalación de skills nuevas

Skills de tododeia se instalan así:

```bash
mkdir -p ~/.claude/skills/[nombre-skill]
# Crear SKILL.md con frontmatter name + description
# Claude Code las detecta automáticamente
```

Para plugins (Abogado del Diablo versión plugin):
```
/plugin marketplace add Hainrixz/abogado-del-diablo
/plugin install abogado-del-diablo@abogado-del-diablo
```

---

*Fuente: tododeia.com/community — guías Fable 5 Prompting, Sistema de Skills, Abogado del Diablo*
*Compilado: 2026-07-12*
