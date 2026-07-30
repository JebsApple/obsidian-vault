---
tipo: sistema
version: 1.0
creado: 2026-07-30
modificado: 2026-07-30
---

# Manifiesto del Vault

**Propósito:** Memoria persistente + documentación de reportes + planificación de proyectos.

## Principios

1. **Captura rápida, clasificación diferida** — todo entra por 00-Inbox, se procesa semanalmente.
2. **Enlaces sobre carpetas** — el valor está en las conexiones `[[wiki-link]]`, no en la jerarquía.
3. **Frontmatter consistente** — cada nota tiene tipo, estado, fecha. Sin excepciones.
4. **MOCs como navegación** — los mapas de contenido son la capa de descubrimiento.
5. **Continuidad entre sesiones** — el archivo `CONTEXTO.md` es el punto de reanudación.

## Estructura

| Directorio | Propósito | Ciclo de vida |
|---|---|---|
| `00-Inbox/` | Captura temporal | Se vacía semanalmente |
| `01-Daily/` | Notas diarias | Se archivan a los 30 días |
| `02-Projects/` | Proyectos activos | Pasan a 05-Archive al completarse |
| `03-Areas/` | Responsabilidades continuas | Sin fin |
| `04-Resources/` | Conocimiento atómico + referencias | Permanente |
| `05-Archive/` | Material completado/obsoleto | Permanente |
| `90-Sistema/` | Infraestructura del vault | Se mantiene actualizado |
| `MOCs/` | Mapas de contenido | Crece orgánicamente |
| `Plantillas/` | Templates Templater | Se actualizan con el sistema |
| `Assets/` | Imágenes organizadas por proyecto | Se limpia con el proyecto |

## Ciclo de vida de una nota

```
Inbox → Proyecto/Área/Recurso → Archive
  ↑_______________________________| (referencia)
```

## Stack

- **Editor:** Obsidian
- **Sync:** Syncthing multi-máquina + Git (GitHub: JebsApple/obsidian-vault)
- **Plugins core:** Dataview, Templater, Tasks, Kanban, Calendar
- **Agentes:** Claude Code / opencode con protocolo `90-Sistema/PROTOCOLO.md`
- **Graph:** graphify-out (auto-generado)
