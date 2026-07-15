# Knowledge Graph Analysis Report
Generated from: `graph.json`
- **Nodes:** 764
- **Edges:** 845
- **Density:** 0.0029
- **Components:** 115
- **Hyperedges:** 39

---
## 1. Orphaned / Disconnected Nodes

Found **47** isolated (degree 0) and **323** leaf (degree 1) nodes.

| # | Label | Degree | Node ID |
|---|-------|--------|---------|
| 1 | .diff_fromdelta() | 0 | `stversions_obsidian_plugins_automatic_linker_main_d_diff_fromdelta` |
| 2 | .diff_prettyhtml() | 0 | `stversions_obsidian_plugins_automatic_linker_main_d_diff_prettyhtml` |
| 3 | .diff_todelta() | 0 | `stversions_obsidian_plugins_automatic_linker_main_d_diff_todelta` |
| 4 | .patch_fromtext() | 0 | `stversions_obsidian_plugins_automatic_linker_main_d_patch_fromtext` |
| 5 | .patch_totext() | 0 | `stversions_obsidian_plugins_automatic_linker_main_d_patch_totext` |
| 6 | branch naming convention (spanish) | 0 | `05_archive_minegocio_conocimiento_lecciones_md_branch_naming_spanish` |
| 7 | buscadorproductos.vue — componente reutilizable de busqueda | 0 | `buscador_productos_component` |
| 8 | c-architect agent | 0 | `05_archive_minegocio_conocimiento_agentes_md_c_architect` |
| 9 | c-devops agent | 0 | `05_archive_minegocio_conocimiento_agentes_md_c_devops` |
| 10 | c-sys-test agent (qa) | 0 | `05_archive_minegocio_conocimiento_agentes_md_c_sys_test` |
| 11 | carritocompras.vue component | 0 | `guia_ignacio_md_carrito_compras` |
| 12 | comentarios.md — cambios ui/ux sidebar/tabs/responsive | 0 | `05_archive_minegocio_tareas_comentarios_file` |
| 13 | conditional marker system | 0 | `04-resources_referencia_leyenda-estados-visuales_conditional_marker` |
| 14 | diseno de experiencia de usuario (ux) — 5 planos de garrett | 0 | `04_resources_zettelkasten_ux_diseno_ux_diseno_garrett` |
| 15 | fork de quickshell caelestia para keyhint (super+space) | 0 | `03_areas_linux_caelestia_integracion_sistema_keyhint_fork` |
| 16 | frontend testing & screenshot guide | 0 | `guia_pruebas_frontend_md` |
| 17 | hu01-t04: sonarqube + jenkins (nicolas) | 0 | `procedimiento_nicolas_hu01_sonarqube` |
| 18 | hu01-t05: dead code cleanup (victor) | 0 | `05_archive_minegocio_procedimientos_hu01_deuda_técnica_procedimiento_victor_hu01_dead_code` |
| 19 | hu01-t08: api endpoint documentation task (ignacio) | 0 | `05_archive_minegocio_procedimientos_hu01_deuda_técnica_procedimiento_ignacio_hu01_endpoint_docs` |
| 20 | hu01-t10: spanish comments cleanup (victor) | 0 | `05_archive_minegocio_procedimientos_hu01_deuda_técnica_procedimiento_victor_hu01_spanish_comments` |

---
## 2. Community Size Distribution

Total communities: **119**
Total nodes in communities: **764** / 764

### Size distribution

| Size range | Count |
|-----------|-------|
| 1 | 47 |
| 2-3 | 22 |
| 4-6 | 20 |
| 7-10 | 8 |
| 11-20 | 11 |
| 21-50 | 11 |

### Top 10 smallest non-singleton communities (size ≥ 2)

| Community | Size | Sample nodes |
|-----------|------|-------------|
| 60 | 2 | script run-claude-pedido.sh (ejecucion automatica de claude), flujo cron 2:30 am: git pull + leer pedido.md + claude -p --dangerously-skip-permissions |
| 62 | 2 | script toggle-buds-mode (a2dp <-> hfp), script status-audio |
| 61 | 2 | script mic-celular (wo mic via wifi), auto-conexion plug&play (udev + systemd) mic celular |
| 63 | 2 | deriva — sistema de widgets flotantes con fisica, whatsapp remote control — plan |
| 64 | 2 | plantilla ers (especificacion de requerimientos de software), requerimientos: funcionales y no funcionales |
| 65 | 2 | estado de la sesion — 2026-06-20 (hyprland), sesion 2026-06-21 — hyprland keyhint/screenshots |
| 66 | 2 | inventario consulta productos directo (sin inventario_view), inventario_view sql view |
| 67 | 2 | soft delete pattern (activo boolean), soft-delete 'inteligente' pattern |
| 69 | 2 | sidebar unificada (login+logged-in), s3-hu02-t14 ui improvements (sidebar, tabs, inline stock) |
| 68 | 2 | nginx must proxy /uploads/ lesson, frontend errors report (2026-06-26) |

---
## 3. Bridge Nodes (High Betweenness Centrality)

| # | Label | Betweenness | Communities connected | Node ID |
|---|-------|-------------|---------------------|---------|
| 1 | .diff_main() | 0.0040 | 0, 7 | `stversions_obsidian_plugins_automatic_linker_main_d_diff_main` |
| 2 | se() | 0.0035 | 0, 7 | `stversions_obsidian_plugins_automatic_linker_main_se` |
| 3 | handoff a opencode — cuota de claude code agotada 2026-07-10 | 0.0035 | 1, 12 | `sesion_2026_07_10_handoff` |
| 4 | minegocio | 0.0027 | 5, 16 | `05_archive_minegocio_minegocio_md_project` |
| 5 | inventario.vue — fix pendiente para kanban con productos inactivos | 0.0023 | 1, 12 | `inventario_vue_pending_fix` |
| 6 | iglesia project readme — jesus reigns under worship | 0.0016 | 2, 22 | `02_projects_iglesia_project_readme` |
| 7 | proveedor crud (backend+frontend) | 0.0016 | 5, 16 | `guia_gabriel_md_proveedor_crud` |
| 8 | github jebsapple/luciernaga-app | 0.0010 | 2, 22 | `02_projects_luciernaga_app_blueprints_plan_001_luciernaga_app_luciernaga_repo` |

---
## 4. Missing Links (Suggested Edges)

| # | Node A | Node B | Jaccard | Common neighbors |
|---|--------|--------|---------|-----------------|
| 1 | at() | rt() | 1.000 | 2 |
| 2 | at() | ot() | 1.000 | 2 |
| 3 | at() | lt() | 1.000 | 2 |
| 4 | ot() | rt() | 1.000 | 2 |
| 5 | lt() | rt() | 1.000 | 2 |
| 6 | lt() | ot() | 1.000 | 2 |
| 7 | ct() | gt() | 1.000 | 2 |
| 8 | ct() | ht() | 1.000 | 2 |
| 9 | ct() | ut() | 1.000 | 2 |
| 10 | gt() | ht() | 1.000 | 2 |

---
## 5. Temporal Analysis

| Directory | Nodes with dates | Most recent | Oldest |
|-----------|-----------------|-------------|--------|
| 03-Areas | 7 | 2026-07-12 | 2026-06-29 |
| 05-Archive | 66 | 2026-07-10 | 2026-06-19 |
| Other | 14 | 2026-07-01 | 2026-07-01 |

**677** nodes have no date pattern in their source path.

---
## 6. Cross-Project Connections

| # | Node A | Dir A | Node B | Dir B | Relation |
|---|--------|-------|--------|-------|----------|
| 1 | devops | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 2 | diagrama de clases uml | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 3 | diagrama de despliegue uml | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 4 | diagrama de casos de uso uml | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 5 | automatizacion de pruebas | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 6 | calidad de software | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 7 | diagrama de actividades uml | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 8 | diagrama de secuencia uml | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 9 | extreme programming (xp) | 04-Resources | moc ingenieria de software (referenced) | Other | references |
| 10 | principios de codigo limpio | 04-Resources | moc ingenieria de software (referenced) | Other | references |

---
## 7. MOC Coverage Check (Blind Spots)

Communities **with** MOC node: **10**
Communities **without** MOC (size ≥ 3): **50**

### Communities missing a MOC

| Community | Size | Sample nodes |
|-----------|------|-------------|
| 0 | 37 | main.js, te(), at(), rt() +1 more |
| 1 | 35 | sprint 3 plan de trabajo, s3-hu01: resolucion de deuda tecnica y pipeline ci/cd, s3-hu02: mejora de frontend — interfaz moderna con kanban y navegacion, s3-hu03: dashboard de ventas con estadisticas +1 more |
| 5 | 28 | minegocio, victor herrera (vherrera), gabriel flores, ignacio varela +1 more |
| 6 | 28 | victor hu05: keywords exposicion (separacion dev/prod), s3-hu05: crud de proveedores (historia de usuario), s3-hu05 instrucciones detalladas — gabriel (crud proveedores), auditoria 2026-07-02 — s3-hu02 t08/t15 + kanban ubicaciones + fix fantasmas +1 more |
| 8 | 27 | homelab, 3-2-1 backup rule, proxmox ve, linux hardening +1 more |
| 9 | 23 | hyprland custom scripts, waybar hover daemon, backup opencode config, opencode sandbox +1 more |
| 12 | 20 | sesion 2026-07-03 — rediseno kanban + gates de produccion en jenkins, kanbanboard.vue, modalagregarproducto.vue, vue_app_habilitar_wip flag +1 more |
| 13 | 18 | blueprint: traductor de comics a psd v2, gemini translation provider, openrouter translation provider, deepl api provider +1 more |
| 14 | 18 | fuga de procesos chroma-mcp huerfanos, mako.service failed (conflicto dbus con caelestia-shell), script fix-audit-20260712, fix hotkeys caelestia shell en hyprland.lua +1 more |
| 15 | 17 | ci/cd pipeline, gitops, infrastructure as code, terraform +1 more |
| 16 | 17 | venta transaccional con for update, registro_ventas table, punto de venta (pos) system, proveedor crud (backend+frontend) +1 more |
| 17 | 15 | ignacio varela — s2-hu02 punto de venta, nicolas valdes — s2-hu01 codigo de barras + inventario, victor herrera — s2-hu04 carga de imagenes + galeria, ponytail audit — sprint 2 +1 more |
| 19 | 12 | hermes agent — plan de instalacion, hermes agent readme, hermes agent — backlog, hermes agent (autonomous agent runtime) +1 more |
| 20 | 12 | cachyos, linux-cachyos (eevdf), linux-cachyos-bore (bore), linux-cachyos-lts +1 more |
| 21 | 11 | app.json, defaultviewmode, showlinenumber, strictlinebreaks +1 more |
| 24 | 9 | plugin obsidian git (commit 10min / push 30min), systemd timer obsidian-sync.timer (cada 30 min), script vault-sync / vsync (sync manual), syncthing para sync multi-maquina en tiempo real +1 more |
| 25 | 9 | netbird, pangolin, suwayomi server, mihon +1 more |
| 28 | 8 | manifest.json, id, name, version +1 more |
| 26 | 8 | fable 5 skills, fable 5 prompting principles, fable 5 manuals, fable chequeo de seguridad +1 more |
| 27 | 8 | kanban por ubicaciones fisicas (no por stock), kanbanboard.vue (drag-drop by ubicacion), analisis.vue dashboard (chart.js), ubicaciones crud (inventario_repository.go) +1 more |

---
## Summary

- **47** isolated nodes, **323** leaf nodes → consider pruning or connecting
- **119** communities, largest has 37 nodes
- **50** communities (≥3 nodes) lack a MOC → index gaps
- **10** cross-directory edges found → vault is interconnected
- **10** high-confidence missing links suggested
