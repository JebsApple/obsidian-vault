---
tags: [proyecto/minegocio, sprint-3, gitea, taiga, handoff]
updated: 2026-06-27
assignee: victor
estado: listo-para-subir (Gitea pendiente — lo hace Victor)
---

# Instrucciones de subida a Gitea + comentarios Taiga — S3 (frontend)

> **NADA se subió a Gitea todavía.** Todo el trabajo está en ramas LOCALES.
> Este doc dice paso a paso cómo separar y subir, y deja los comentarios Taiga listos para pegar.
> Servidor de prueba corriendo en **http://192.168.50.25:8082** (rama S3-HU02).

---

## 1. Mapa de ramas locales

```
main
└── S3-HU02 (integradora)  ← TODO el trabajo de HU02 (Victor)
      │  14 commits sobre la base e7061e4 (ver §2)
      └── S3-HU01-T05-limpieza-frontend   ← +1 commit (99174e7)
            └── S3-HU01-T10-comentarios-espanol  ← +1 commit (c478d36)
                  └── S3-HU01-T11-readme-frontend ← +1 commit (48e4bc9)
```

**Dependencia clave:** los 3 commits de HU01 (frontend) se hicieron SOBRE los renombrados
de S3-HU02, así que **se integran DESPUÉS de S3-HU02** (no son independientes de main).

---

## 2. S3-HU02 — qué contiene (rama integradora, Victor)

Commits (de más nuevo a más viejo) sobre `e7061e4`:

| Commit | Tarea Taiga | Qué hace |
|--------|-------------|----------|
| b62bb65 | HU02-T09 | desactiva regla eslint multi-word (vistas de 1 palabra) |
| 5ee57e8 / 80b160e | **HU02-T04** | tests 23→53 (servicios + KanbanBoard) |
| 9380797 | HU02-T09 | revierte rename de Contacto (es de Ignacio) |
| a9043b0 / 65902a8 | HU02-T09 | renombra vistas sin sufijo Page |
| f5925a7 / 507d36f | **HU02-T08** | CSS a español + animaciones Kanban suaves |
| ffa7127 / 1094180 | **HU02-T08** | colores hardcodeados → var(--color-brand) |
| 2339f11 / 1496826 | **HU02-T06 + T05** | fetch()→servicios + console.error→$modal |
| 6cd7db6 / e22f1fb | HU02-T01 (+ HU01-T05) | logout via authService, usuario desde JWT |

### Subir S3-HU02 a Gitea
```bash
cd /home/icin/minegocio-frontend
git checkout S3-HU02
git push gitea S3-HU02            # sin -f
# luego: integrar a dev → testeo equipo → main (flujo normal del vault)
```

> Las sub-ramas individuales (T01..T08) ya existen en Gitea de antes. Estas mejoras
> ya están integradas en S3-HU02; basta con subir S3-HU02.

---

## 3. HU01 (frontend, Victor) — subir DESPUÉS de S3-HU02

Cada tarea = 1 commit limpio. Subir la rama tal cual (ya está basada en S3-HU02):

```bash
git push gitea S3-HU01-T05-limpieza-frontend
git push gitea S3-HU01-T10-comentarios-espanol
git push gitea S3-HU01-T11-readme-frontend
```

> Nota: estas ramas contienen también los commits de S3-HU02 (porque dependen de él).
> Al integrar, hacerlo sobre S3-HU02 ya integrado; los 3 commits HU01 se aplican encima sin conflicto.

---

## 4. Comentarios para pegar en Taiga

### Tarea **S3-HU02-T04** (Testing frontend) — comentario
```
Cobertura ampliada de 23 → 53 tests (10 suites, 0 errores). Nuevas suites:
authService, productosService, ventasService, inventarioService, KanbanBoard.
Cubre capa de servicios (todas las llamadas API + manejo de errores), auth JWT
(login/logout/decodificación token) y Kanban (clasificación por stock + drag&drop).
Detalle test por test en Obsidian: Tasks/taiga-tests-S3-HU02.md. Ejecutar: npx vitest run.
```

### Tarea **S3-HU01-T05** (Limpieza código muerto — parte Victor) — comentario
```
Frontend: creado src/utils/stockStatus.js con STOCK_BAJO_UMBRAL=4 como fuente única.
Corregida la inconsistencia de umbral (GaleriaProductos usaba <=10 vs <=4 en el resto);
ahora GaleriaProductos, KanbanBoard, Productos e Inventario consumen el util.
HelloWorld.vue ya no existe (limpieza previa). App.vue.cerrarSesion ya usa authService.logout().
Pendiente (no hecho por riesgo estético): consolidar CSS duplicado de badges/botones entre
GaleriaProductos.vue (scoped) y productos.css → requiere mover reglas compartidas a base.css
con verificación visual. Commit: 99174e7 (rama S3-HU01-T05-limpieza-frontend).
```

### Tarea **S3-HU01-T10** (Comentarios en inglés) — comentario
```
Frontend: traducidos a español todos los comentarios en inglés (encabezados de sección CSS
en base.css, componentes.css, variables.css, inventario.css; comentarios en SideBar.vue y
Login.vue). Solo comentarios, sin cambios funcionales ni visuales. Commit: c478d36.
(Pendiente parte backend de T10 si aplica: models.go, repository/usuario_repository.go.)
```

### Tarea **S3-HU01-T11** (READMEs) — comentario
```
Frontend: README.md reescrito — stack, requisitos, puesta en marcha paso a paso, scripts,
ambientes (corrige inconsistencia: PROD = nginx + backend dockerizados vía Jenkins; DEV nativo),
estructura de directorios actualizada (utils/, vistas sin sufijo Page, __tests__/), reglas de
arquitectura, rutas, auth JWT y convención de ramas. Quitadas credenciales hardcodeadas.
Commit: 48e4bc9. (Pendiente: README del backend.)
```

---

## 5. Checklist pre-push (del flujo del vault)
- [x] `npx vitest run` → 53/53
- [x] `npm run build` → DONE (0 errores)
- [x] Sin `fetch()` directo en views, sin `console.error`, sin colores hardcodeados
- [ ] Subir a Gitea (Victor) y crear comentarios Taiga de arriba
