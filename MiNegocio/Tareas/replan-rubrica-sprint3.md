---
tags: [plan, sprint-3, rubrica]
---

# Plan Reajustado — Rúbrica Sprint 3 (254 pts)

Basado en revisión de `Rubrica Sprint 3.xlsx`.

## Puntaje total: 254 pts

## Prioridad por puntaje — lo que falta

| # | Item | Pts | Estado |
|---|---|---|---|
| 1 | **README Front** (21) + **README Back** (26) | 47 | ❌ No empezado |
| 2 | **Pipeline Jenkins Front** (config + build + deploy) | 15 | ⚠️ Jenkinsfile existe, verificar en Gitea |
| 3 | **Presentación Sprint 3** | 18 | ❌ No empezado |
| 4 | **Squash & Merge policy** (front 5 + back 5) | 10 | ❌ No configurado |
| 5 | **Evidencia Front + Back + DB** (capturas) | 9 | ❌ No empezado |
| 6 | **SonarQube análisis + quality gate** | 6 | ❌ No empezado |
| 7 | **Dashboard + Export PDF/Excel** | 9 | ❌ No empezado |
| 8 | **Versionado semántico** (3) + **versión visible front** (1) + **versión visible back** (1) | 5 | ❌ No empezado |
| 9 | **Log a archivos** (3) + **comentarios código back** (3) | 6 | ⚠️ Logging implementado, falta persistencia a archivo |
| 10 | **README contenido detallado** (rutas server, logs, deploy) | — | Incluido en #1 |

## Plan de ejecución (hoy)

### 1. Frontend a producción (merge dev→main)
- [ ] Actualizar `package.json` version → `3.0.0`
- [ ] Agregar componente `VersionTag.vue` visible en sidebar/footer
- [ ] Commit en dev → push
- [ ] Crear PR dev→main en Gitea con Squash & Merge
- [ ] Tag semver `v3.0.0` en main
- [ ] Verificar Jenkins deploy a prod

### 2. Backend — versión visible + tag
- [ ] Agregar endpoint `/api/version` o header
- [ ] Commit + push a dev → PR → main → tag `v3.0.0`

### 3. Documentación (READMEs)
- [ ] README Frontend completo (21 pts)
- [ ] README Backend completo (26 pts)

### 4. Squash & Merge policy (si alcanza)
- [ ] Configurar en Gitea: solo squash merge
- [ ] Documentar en README

### 5. Presentación (si alcanza)
- [ ] Slides HTML

---

## Items ya completados (no requieren más esfuerzo)

- [x] Repositorios front/back/db en Gitea (3 pts)
- [x] Uso de ramas feature con nomenclatura (10 pts)
- [x] Calidad historial Git (10 pts)
- [x] Calidad código por capas (10 pts)
- [x] Auth JWT + bcrypt + JWT_SECRET (3 pts)
- [x] Variables de entorno DB dev/prod (3 pts)
- [x] Aislamiento entornos dev/prod (3 pts)
- [x] Despliegue dev front/back (6 pts)
- [x] Pipeline Jenkins Back (5 pts)
- [x] Deploy automático Back (5 pts)
- [x] Logging estructurado backend (slog, niveles, request_id) (3 pts)
- [x] Limpieza código muerto, CSS duplicado, nomenclatura
- [x] Gestión Scrum (HU, QA, daily, seguimiento)
- [x] Deuda técnica (bcrypt, JWT_SECRET, limpieza)
