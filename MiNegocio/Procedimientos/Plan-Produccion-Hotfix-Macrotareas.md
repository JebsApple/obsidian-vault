---
tags: [proyecto/minegocio, plan, produccion, hotfix, macrotareas, frontend]
updated: 2026-07-07
---

# Plan de Producción — Hotfix + Macrotareas

Objetivo: llevar el frontend a producción funcionando y sin WIP (Work In Progress). Basado en auditoría 2026-07-07.

---

## Fase 0: Hotfix (urgente, pre-prod)

Ejecutar ANTES de cualquier macrotarea. Items que bloquean producción o son riesgo de seguridad.

| # | Tarea | Repo | Detalle | Checklist |
|---|-------|------|---------|-----------|
| H1 | 🔴 **Remover token expuesto del remote `origin`** | Frontend | `.git/config` tiene token Gitea embebido en URL HTTP. Cambiar remote a SSH solo o regenerar token. | `git remote remove origin` + mantener solo `gitea` |
| H2 | 🔴 **Commitear y pushear ramas locales pendientes** | Backend, Database | `S3-HU02-T15-iva-proveedores` sin push aún. Hacer commit + push a Gitea. | `git push gitea S3-HU02-T15-iva-proveedores` |
| H3 | 🟡 **JWT secret hardcodeado** | Backend | `config/jwt.go` tiene fallback `"MiNegocio2026_SuperSecretKey_CambiarEnProduccion!"`. Mover a variable de entorno obligatoria. | Eliminar fallback, que `getEnv("JWT_SECRET")` retorne error si no está seteado |
| H4 | 🟡 **Sincronizar rama `S3-HU02` del frontend** | Frontend | Working tree local (T08 animaciones + T15 IVA + fix fantasmas + kanban ubicaciones) sin commit. Revisar, commitear y pushear. | `git status` → commit → `git push gitea S3-HU02` |
| H5 | 🟡 **Contraseñas en texto plano** | Backend | `usuario_repository.go` compara password directo en SQL. Migrar a bcrypt. | Usar `golang.org/x/crypto/bcrypt` (ya documentado en lecciones.md) |

---

## Macrotarea 1: Gitea Cleanup + Merge a Dev

Ordenar el repositorio antes de integrar.

| # | Tarea | Detalle | Depende de |
|---|-------|---------|------------|
| M1.1 | Auditar ramas locales vs Gitea (3 repos) | Comparar `git branch` local vs `git branch -r`. Identificar qué falta pushear. | H2, H4 |
| M1.2 | Mergear ramas feature a `dev` | Integrar `S3-HU02` y sub-ramas a `dev`. Resolver conflictos. | M1.1 |
| M1.3 | Eliminar ramas S2 obsoletas en Gitea | Ramas viejas que ya están en `archive/*` tags. Limpiar visualmente. | — |
| M1.4 | Decidir qué hacer con `minegocio-backend-old` | Carpeta muerta de ~30MB. Mover a `archive/` o eliminar si ya no se necesita. | — |

---

## Macrotarea 2: Logging (Info / Warn / Error)

Sistema de logging estructurado para backend.

| # | Tarea | Archivos | Detalle |
|---|-------|----------|---------|
| M2.1 | Crear logger centralizado | `config/logger.go` | Niveles INFO, WARN, ERROR. Timestamp ISO8601 + archivo/línea. Paquete `log/slog` de Go 1.22+ (std library, sin dependencias) |
| M2.2 | Middleware de request logging | `middleware/logging.go` | Capturar método, ruta, status code, duración. Usar `responseWriter` wrapper para capturar status. |
| M2.3 | Reemplazar `log.Printf` en handlers | Todos los handlers | Migrar a `slog.Info()`, `slog.Warn()`, `slog.Error()` con atributos contextuales |
| M2.4 | Reemplazar `log.Printf` en services/repos | service/, repository/ | Logs de operaciones CRUD nivel Debug o Info |
| M2.5 | Reemplazar `fmt.Printf` y `panic()` en main.go | `main.go` | Startup logs con `slog.Info()`, errores fatales con `slog.Error() + os.Exit(1)` |
| M2.6 | Configurar nivel de log por entorno | `config/logger.go` | `APP_ENV=development` → log nivel DEBUG; `production` → INFO |

---

## Macrotarea 3: Completar Frontend

Funcionalidades pendientes para tener frontend completo.

| # | Tarea | Archivos | Detalle |
|---|-------|----------|---------|
| M3.1 | Implementar `AdminUsuariosPage.vue` | `src/views/AdminUsuariosPage.vue` | CRUD usuarios: listar, crear, editar, desactivar. Solo admin. |
| M3.2 | Endpoint `GET /api/ventas/{id}` backend | `handler/venta_handler.go`, `routes/routes.go` | Devuelve detalle de una venta con items. Referenciado por frontend. |
| M3.3 | Endpoint `POST /api/usuarios/{id}/imagen` backend | `handler/`, `routes/routes.go` | Subir foto de perfil. Referenciado por `authService.uploadFotoPerfil()`. |
| M3.4 | Endpoint `GET/POST /api/usuarios` backend | `handler/usuario_handler.go`, `routes/routes.go` | CRUD usuarios completo para admin. Service + Repository. |
| M3.5 | Revisar `ContactoPage.vue` | `src/views/ContactoPage.vue` | Solo 6 líneas de CSS. Completar diseño mínimo. |
| M3.6 | Assets/icons/ — agregar iconos faltantes | `src/assets/icons/` | Carpeta vacía (solo `.gitkeep`). |
| M3.7 | Pruebas de humo frontend completo | Navegación manual | Verificar que todas las rutas cargan, auth funciona, CRUD productos, ventas, inventario |

---

## Macrotarea 4: Tests + SonarQube

Calidad y cobertura.

| # | Tarea | Archivos | Detalle |
|---|-------|----------|---------|
| M4.1 | Tests handlers/repos ubicaciones | `handler/inventario_handler_test.go` | Tests unitarios para `CreateUbicacion`, `DeleteUbicacion`, `PatchUbicacion` |
| M4.2 | Tests cálculo IVA | `service/producto_service_test.go` | Testear `precio_sin_iva = precio_venta * 100 / 119` |
| M4.3 | Medir cobertura actual backend | `go test -coverprofile=coverage.out ./...` | Establecer baseline. Meta: ≥60%. |
| M4.4 | Instalar `@vitest/coverage-v8` | `minegocio-frontend/` | `npm install -D @vitest/coverage-v8`. Configurar en `vitest.config.js`. |
| M4.5 | Medir cobertura frontend | `npx vitest run --coverage` | Establecer baseline. Meta: ≥40%. |
| M4.6 | Configurar SonarQube backend | `sonar-project.properties` | Generar token, setear `sonar.login=TOKEN`, ejecutar `sonar-scanner` |
| M4.7 | Crear SonarQube frontend | `minegocio-frontend/sonar-project.properties` | Nuevo archivo con projectKey `minegocio-frontend`. Ejecutar scanner. |
| M4.8 | Verificar resultados Sonar | Ambos proyectos | Revisar bugs, code smells, coverage. Corregir hallazgos críticos. |

---

## Ruta Crítica a Producción

```
H1 ─┐
H2 ─┤
H3 ─┤
H4 ─┤
H5 ─┤
    ├──> M1 (Gitea Cleanup) ──> M3 (Frontend) ──> Merge a main ──> Deploy PROD
    │                              ↑
    └──────────────────────────────┘
                            M2 (Logging) ──> paralelo
                            M4 (Tests+Sonar) ──> paralelo
```

**Orden recomendado:**

1. **Semana 1:** Hotfix (H1-H5) + M1 (Gitea Cleanup + merge a dev)
2. **Semana 2:** M3 (Completar frontend) — en paralelo M2 (Logging)
3. **Semana 3:** M4 (Tests + Sonar) — en paralelo fix de bugs encontrados
4. **Semana 4:** Merge a main → Deploy a PROD → Smoke test completo

---

## Ramas propuestas

| Macrotarea | Rama base | Nombre de rama |
|------------|-----------|----------------|
| Hotfix | `main` | `hotfix-S3HX-token-seguridad` |
| M1 (Gitea) | `S3-HU02` | `S3-HU02-T18-gitea-cleanup` |
| M2 (Logging) | `dev` | `S3-HU02-T19-logging-estructurado` |
| M3 (Frontend) | `dev` | `S3-HU03-T01-frontend-completo` |
| M4 (Tests+Sonar) | `dev` | `S3-HU02-T20-tests-sonar` |

> Nota: hotfix va directo a `main` por ser urgente/seguridad. El resto va a `dev` primero.

---

## Definiciones

- **WIP:** Código sin pushear a Gitea, ramas sin mergear, features a medias
- **Producción lista:** Frontend sirve en :8000, todas las rutas funcionales, auth operativo, sin bugs bloqueantes
- **Hecho = pusheado + mergeado + desplegado + verificado**
