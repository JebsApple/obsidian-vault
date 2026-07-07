---
tags: [proyecto/minegocio, plan, produccion, ruta-critica, checklist]
updated: 2026-07-07
---

# Ruta Crítica a Producción

Checklist secuencial para llevar el frontend a producción sin WIP. Cada paso debe estar COMPLETO y VERIFICADO antes del siguiente.

---

## Paso 1: Hotfix Seguridad

**Rama:** `hotfix-S3HX-token-seguridad` (base: `main`)
**Duración estimada:** 1 día

| Item | Descripción | Done |
|------|-------------|:----:|
| 1.1 | Remover token Gitea del remote `origin` en frontend | ☐ |
| 1.2 | Eliminar fallback JWT_SECRET hardcodeado en backend | ☐ |
| 1.3 | Pushear ramas locales pendientes a Gitea (backend + database T15) | ☐ |
| 1.4 | Commit + push working tree frontend (`S3-HU02`) | ☐ |
| 1.5 | Merge hotfix a `main` + push | ☐ |
| 1.6 | Verificar que `main` compila y build pasa | ☐ |

### Comandos

```bash
# Frontend: cambiar remote
cd /home/icin/minegocio-frontend
git remote remove origin
# mantener solo gitea como remote único

# Backend: commit rama T15
cd /home/icin/minegocio-backend
git add -A && git commit -m "S3-HU02-T15: IVA 19% + proveedores + ubicaciones + fix fantasmas"
git push gitea S3-HU02-T15-iva-proveedores

# Database: commit rama T15
cd /home/icin/minegocio-database
git add -A && git commit -m "S3-HU02-T15: proveedores + ubicaciones + columnas IVA + seed"
git push gitea S3-HU02-T15-iva-proveedores
```

---

## Paso 2: Gitea Cleanup

**Rama:** `S3-HU02-T18-gitea-cleanup` (base: `S3-HU02`)
**Duración estimada:** 1 día

| Item | Descripción | Done |
|------|-------------|:----:|
| 2.1 | Auditar ramas locales vs Gitea en 3 repos | ☐ |
| 2.2 | Mergear `S3-HU02` (frontend) y `S3-HU02-T15-iva-proveedores` (backend/db) a `dev` | ☐ |
| 2.3 | Resolver conflictos de merge si existen | ☐ |
| 2.4 | Eliminar ramas S2 obsoletas en Gitea | ☐ |
| 2.5 | Decidir sobre `minegocio-backend-old` | ☐ |
| 2.6 | `go build ./...` + `go vet ./...` + `go test ./...` OK | ☐ |
| 2.7 | `npm run build` + `npx vitest run` OK | ☐ |

---

## Paso 3: Logging Estructurado

**Rama:** `S3-HU02-T19-logging-estructurado` (base: `dev`)
**Duración estimada:** 2 días

| Item | Descripción | Done |
|------|-------------|:----:|
| 3.1 | Crear `config/logger.go` con `slog` (Go 1.22) | ☐ |
| 3.2 | Crear `middleware/logging.go` (request logging) | ☐ |
| 3.3 | Migrar handlers: `log.Printf` → `slog.Info/Warn/Error` | ☐ |
| 3.4 | Migrar services/repos: logs de operaciones | ☐ |
| 3.5 | Migrar main.go: startup + errores fatales | ☐ |
| 3.6 | Configurar nivel de log por `APP_ENV` | ☐ |
| 3.7 | `go build ./...` + `go test ./...` OK | ☐ |

---

## Paso 4: Frontend Completo

**Rama:** `S3-HU03-T01-frontend-completo` (base: `dev`)
**Duración estimada:** 3 días

| Item | Descripción | Done |
|------|-------------|:----:|
| 4.1 | Endpoints backend: `GET /api/ventas/{id}` | ☐ |
| 4.2 | Endpoints backend: CRUD `/api/usuarios` + imagen | ☐ |
| 4.3 | `AdminUsuariosPage.vue` implementado | ☐ |
| 4.4 | `ContactoPage.vue` completado | ☐ |
| 4.5 | Iconos SVG en `assets/icons/` | ☐ |
| 4.6 | Prueba de humo manual (ver Guia-Pruebas-Capturas) | ☐ |
| 4.7 | `npm run build` + `npx vitest run` OK | ☐ |

---

## Paso 5: Tests + SonarQube

**Rama:** `S3-HU02-T20-tests-sonar` (base: `dev`)
**Duración estimada:** 2 días

| Item | Descripción | Done |
|------|-------------|:----:|
| 5.1 | Tests handlers/repos ubicaciones | ☐ |
| 5.2 | Tests cálculo IVA | ☐ |
| 5.3 | Medir cobertura backend (target ≥60%) | ☐ |
| 5.4 | Instalar `@vitest/coverage-v8`, medir cobertura frontend | ☐ |
| 5.5 | Generar token SonarQube y setear en backend | ☐ |
| 5.6 | Crear `sonar-project.properties` para frontend | ☐ |
| 5.7 | Ejecutar `sonar-scanner` en ambos proyectos | ☐ |
| 5.8 | Revisar y corregir bugs/code smells encontrados | ☐ |
| 5.9 | `go build` + `go test` + `npm run build` + `npx vitest run` OK | ☐ |

---

## Paso 6: Merge a Producción

**Rama:** dev → main
**Duración estimada:** 1 día

| Item | Descripción | Done |
|------|-------------|:----:|
| 6.1 | Testeo en `dev` por ≥1 compañero | ☐ |
| 6.2 | Sin bugs críticos conocidos | ☐ |
| 6.3 | `git checkout main && git merge --no-ff dev` | ☐ |
| 6.4 | Tag semver: `git tag -a v3.1.0 -m "v3.1.0 - S3-HU02: frontend completo"` | ☐ |
| 6.5 | `git push gitea main --tags` | ☐ |
| 6.6 | Jenkins deploy a producción (o manual) | ☐ |
| 6.7 | Smoke test completo en :8000 | ☐ |
| 6.8 | Capturas de pantalla actualizadas | ☐ |
| 6.9 | READMEs actualizados (frontend + backend) | ☐ |
| 6.10 | Obsidian vault actualizado (MiNegocio.md, ramas, tags) | ☐ |

---

## Resumen Visual

```
Sem 1         Sem 2         Sem 3         Sem 4
┌────────┐   ┌────────┐   ┌────────┐   ┌────────┐
│Hotfix  │   │Frontend│   │Tests   │   │Merge a │
│Seguridad│   │Completo│   │+ Sonar │   │main    │
│+ Gitea │   │        │   │        │   │→ PROD  │
└────────┘   ├────────┤   ├────────┤   ├────────┤
             │Logging │   │Fix bugs│   │Smoke   │
             │(paral.)│   │Sonar   │   │test    │
             └────────┘   └────────┘   └────────┘
```

---

## Definición de "Hecho"

- [ ] Código commiteado y pusheado a Gitea
- [ ] Rama mergeada a `dev`
- [ ] `go build ./...` y `go vet ./...` OK
- [ ] `go test ./...` OK
- [ ] `npm run build` OK
- [ ] `npx vitest run` OK
- [ ] SonarQube sin issues críticos/bloqueantes
- [ ] Verificado en entorno dev (:8080)
- [ ] Documentado en Obsidian vault
