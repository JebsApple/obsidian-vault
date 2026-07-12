---
tags:
  - referencia/claude
  - referencia/ecosistema
  - referencia/descubrir
date: 2026-07-12
source: web search
---

# Claude Ecosistema — Lo que no sabías que existía

Exploración amplia del ecosistema Claude Code + skills + plugins + tools.
Compilado 2026-07-12.

---

## 1. Marketplace oficial (15,000+ plugins)

**https://claude.com/plugins**

El marketplace oficial de Anthropic. Plugins oficiales con badge "Anthropic Verified".

### Top plugins útiles para tu workflow:

| Plugin | Para qué | Instalación |
|--------|----------|-------------|
| **Superpowers** | Piloto automático: subagentes, TDD, debugging en 4 fases, brainstorming visual con mockups HTML | `/plugin install superpowers@claude-plugins-official` |
| **claude-mem** | Memoria persistente entre sesiones + búsqueda semántica + visor web localhost | `/plugin install claude-mem@thedotmack` |
| **Claude Automation Recommender** | Analiza tu código y recomienda qué automations configurar (hooks, skills, MCPs) | `/plugin install claude-code-setup@claude-plugins-official` |
| **Optibot** | Code review que atrapa bugs de producción, lógica de negocio y vulnerabilidades | `/plugin install optibot` |
| **GoodMem** | Infraestructura de memoria AI: embedders, spaces, memoria via lenguaje natural | `/plugin install goodmem` |
| **neon** | Gestionar proyectos y BD Neon Postgres desde Claude | `/plugin install neon` |

### Marketplace community (calidad variable):

```
/plugin marketplace add alirezarezvani/claude-skills    # 345 skills
/plugin marketplace add ComposioHQ/awesome-claude-plugins  # 25-30 production
```

---

## 2. Skills de tododeia.com (los mismos creadores de Fable)

### Ya instaladas (5 Fable):
- fable-chequeo-seguridad
- fable-arranque
- fable-plan
- fable-abogado-del-diablo
- fable-fixer

### Disponibles para instalar:

| Skill | URL | Qué hace |
|-------|-----|----------|
| **Claude Ads** | tododeia.com/community/claude-ads | Estratega de paid media: auditoría Meta/Google/TikTok, 161 checks, health score 0-100 |
| **9 prompts Cowork** | tododeia.com/community/nueve-prompts-cowork | Automatización diaria: brief mañanero (47→4 min), detective competencia, prep juntas |
| **40 skills para Claude** | tododeia.com/community/40-skills-claude | Catálogo de 40 skills listas para copiar |
| **5 skills que realmente necesitas** | tododeia.com/community/5-claude-skills-necesarias | Las 5 esenciales según tododeia |
| **Skill Creator proyecto** | tododeia.com/community/creador-de-habilidades | Proceso de 6 pasos + 8 prompts maestros para crear skills |
| **Aprende** | tododeia.com/community/aprende-skill | Skill que guarda memoria de Claude Code |

### Guías de prompting:

| Guía | URL | Contenido |
|------|-----|-----------|
| Fable 5 Prompting | tododeia.com/community/fable-5-prompting | 4 principios + 16 prompts copiables |
| Prompt Master | tododeia.com/community/prompt-master | Revisa y mejora tus prompts antes de mandarlos |
| Prompting 101 | tododeia.com/community/prompting-101-anthropic | Los 10 pilares atemporales de Anthropic |

---

## 3. Claude Design (UI/UX desde el chat)

**https://claude.ai/design** (requiere plan Pro $20/mes)

Canvas de diseño: escribes un prompt y Claude genera wireframes, mockups, pitch decks, prototipos.

**Prompt tipo que funciona:**
```
[Tipo de artefacto] para [audiencia]. [Especificaciones de contenido].
[Estilo visual]. [Restricciones].
```

**Ejemplo:**
```
Wireframe de landing page para iglesia evangélica.
Secciones: hero con nombre, horarios, eventos, galería, contacto, buzón de oración.
Estilo: cálido, limpio, legible para personas mayores.
Restricciones: mobile-first, contraste alto, sin animaciones.
```

---

## 4. Skills nativas de Claude (ya vienen, no las ves)

Según Vilma Nunez (guía definitiva de skills):

| Skill nativa | Qué hace |
|--------------|----------|
| **Documentos Word** | Manipula XML de .docx: tablas, bordes, colores de marca, TOC automático |
| **Extracción de contenido** | Detecta tipo de contenido (clase, entrevista, podcast) y adapta extracción |
| **Presentaciones** | Genera decks con Chart.js, diseño responsive |

---

## 5. Repos de skills para explorar

| Repo | Stars | Qué tiene |
|------|-------|-----------|
| alirezarezvani/claude-skills | 198K | 345 skills + plugins. Engineering, marketing, product, C-level |
| ComposioHQ/awesome-claude-plugins | — | 25-30 production plugins |
| innoaiconsulting/claude-code-skills-vault | — | Bóveda gratuita de skills en español |
| Hainrixz/abogado-del-diablo | — | Abogado del Diablo plugin (ya lo tenemos como skill) |
| Hainrixz/claude-ads | — | Claude Ads v2.4.0 |
| obra/superpowers | 198K | Framework de subagentes agénticos |
| anthropics/skills | — | Skills oficiales de Anthropic |

---

## 6. Lo que más te serviría (recomendación personal)

Basado en tus proyectos (iglesia + Lucierna + workflow):

### Para instalar YA:
1. **Superpowers** — subagentes automáticos, te ahorraría tiempo en sprints
2. **claude-mem** — memoria persistente entre sesiones
3. **Claude Automation Recommender** — analiza tu código y te dice qué más automatizar

### Para explorar cuando tengas tokens:
1. **Claude Ads** — si algún día monetizas la iglesia o Lucierna con marketing
2. **9 prompts Cowork** — automatizar rutina diaria (briefs, reportes, competencia)
3. **Claude Design** — wireframes y mockups desde el chat (necesita Pro)

### Skills que podrías crear tú mismo:
1. **Skill de contenido iglesia** — genera avisos, horarios, eventos en el tono correcto
2. **Skill de Lucierna features** — diseñar features siguiendo tus reglas (offline-first, accesible)
3. **Skill de Obsidian** — convertir notas del vault en tareas accionables

---

## 7. Cómo instalar cualquier skill/plugin

### Plugin oficial:
```
/plugin install [nombre]@claude-plugins-official
```

### Plugin de marketplace community:
```
/plugin marketplace add [owner]/[repo]
/plugin install [nombre]@[marketplace]
```

### Skill manual (como las Fable):
```bash
mkdir -p ~/.claude/skills/[nombre-skill]
# Crear SKILL.md con frontmatter name + description
# Claude Code las detecta automáticamente
```

### Probar un plugin sin instalar:
```
claude --plugin-dir ./mi-plugin
```

---

*Fuentes: tododeia.com, claude.com/plugins, GitHub, vilmanunez.substack.com, techbloat.com, morphllm.com*
*Compilado: 2026-07-12*
