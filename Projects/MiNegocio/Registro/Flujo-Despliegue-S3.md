---
tags: [proyecto/minegocio, procedimiento, flujo, despliegue]
updated: 2026-06-27
---

# Flujo de Trabajo -- MiNegocio S3

## Ciclo completo

```
[1. Planificar en Taiga]
  -> [2. Tag version en main]
    -> [3. Crear sub-rama T0X desde main]
      -> [4. Desarrollar en local (sandbox)]
        -> [5. Commits incrementales en sub-rama]
          -> [6. Push sub-rama a Gitea]
            -> [7. Integrar en rama HU]
              -> [8. Merge a dev -> notificar equipo]
                -> [9. Testeo companeros en dev]
                  -> [10. Merge a main con tag v3.X.0]
                    -> [11. Actualizar README + Obsidian]
```

---

## 1. Planificar

Cada HU en Taiga produce:
- **Rama HU**: `S3-HU02` — integra todas las tareas de la HU
- **Sub-ramas T0X**: `S3-HU02-T01-navegacion-barra-lateral` — una por tarea

> Nomenclatura en espanol, sin emojis, con guiones.

---

## 2. Versionado (tags en main)

Cada release en main lleva tag semver. La rama `main` siempre refleja produccion.

| Tag | Cuando |
|-----|--------|
| `v3.0.0` | Estado actual de main (base) |
| `v3.1.0` | Tras merge de `S3-HU02` a main |
| `v3.2.0` | Tras merge de siguiente HU |

```bash
# Etiquetar main al inicio del sprint
git checkout main
git tag -a v3.0.0 -m "v3.0.0 — release base del frontend MiNegocio"
git push origin v3.0.0

# Al mergear HU a main
git checkout main
git merge --no-ff S3-HU02
git tag -a v3.1.0 -m "v3.1.0 — S3-HU02: rediseno navegacion e inventario"
git push origin main --tags
```

---

## 3. Estructura de ramas

Cada HU tiene una **rama integradora** y **sub-ramas por tarea**:

```
main  (v3.0.0)
  └── S3-HU02  (integradora — contiene todo)
        ├── S3-HU02-T01-navegacion-barra-lateral
        ├── S3-HU02-T02-tablero-kanban
        ├── S3-HU02-T03-panel-principal
        ├── S3-HU02-T04-pruebas
        ├── S3-HU02-T05-validaciones
        ├── S3-HU02-T06-capas-frontend
        ├── S3-HU02-T07-kanban-inventario
        └── S3-HU02-T08-ajustes-estilo
```

**Orden de trabajo:** desarrollar en sub-rama T0X primero, luego integrar en la rama HU.

---

## 4. Crear sub-rama desde main

Nunca trabajar directo en main ni en la rama HU.

```bash
git checkout main
git pull gitea main
git checkout -b S3-HU{NUMERO}-T{NUMERO}-descripcion-breve
```

### Convencion

`S{SPRINT}-HU{NUMERO}-T{NUMERO}-{descripcion}`

Ej: `S3-HU02-T01-navegacion-barra-lateral`

- Sprint = S3
- HU = HU02
- T = T01
- Descripcion: 2-4 palabras, sin verbos, sin emojis, solo minusculas

---

## 3. Desarrollar en local (sandbox)

```bash
# Backend (puerto 3000)
cd /home/icin/minegocio-backend && go run main.go

# Frontend (puerto 8081 con hot-reload)
cd /home/icin/minegocio-frontend && npm run serve
```

Sandbox: `http://192.168.50.25:8080`

---

## 4. Separacion en capas

### Frontend (Vue.js 3)

```
src/
  main.js           <- importa base.css
  styles/
    variables.css   <- tokens (colores, radios, sombras)
    base.css        <- componentes compartidos (botones, cards, tablas)
    *.css           <- estilos pagina-especificos (solo override)
  services/         <- TODA la API. Views nunca hacen fetch() directo
    authService.js
    productosService.js
    inventarioService.js
    ventasService.js
  views/            <- solo presentacion llama services/
  components/       <- reutilizables, <style scoped>
```

**Reglas front:**
- `views/` **no** usa `fetch()` directo. Importa `services/`.
- CSS jerarquia: `variables.css` -> `base.css` -> pagina-specific.
- `main.js` importa `base.css` globalmente.
- Colores hardcodeados prohibidos. Usar `var(--color-*)`.
- Componentes usan `<style scoped>` para estilos exclusivos.

### Backend (Go)

```
main.go                   <- solo entry point + wiring
handler/                  <- HTTP + validacion basica
  interfaces.go           <- AuthServiceI, ProductoServiceI, InventarioServiceI, VentaServiceI
service/                  <- logica de negocio + I/O archivos
  interfaces.go           <- UsuarioRepositoryI, ProductoRepositoryI, InventarioRepositoryI, VentaRepositoryI
repository/               <- solo SQL
models/                   <- structs dominio + DTOs
middleware/               <- JWT, upload, context keys
routes/                   <- mapeo de rutas
```

**Reglas back:**
- `handler/` **nunca** importa `repository/`.
- `handler/` **nunca** hace I/O de archivos.
- Todos usan **interfaces** para DI, no structs concretos.
- `middleware/` se comunica por `context.Context`.
- `models/` tiene todos los structs (dominio + DTOs).
- `main.go` solo wiring.

---

## 5. Commits incrementales

Cada commit = un paso logico.

### Bueno:
```bash
git add src/styles/variables.css src/styles/base.css
git commit -m "S3-HU02-T06: crear variables.css y base.css con tokens de diseno"

git add src/services/inventarioService.js
git commit -m "S3-HU02-T06: crear inventarioService con getAll, updateStock, buscar"

git add src/views/InventarioPage.vue
git commit -m "S3-HU02-T06: migrar InventarioPage de fetch() a inventarioService"
```

### Malo:
```bash
git add -A && git commit -m "cambios"   # NUNCA
```

### Reglas:
- Mensajes en espanol con prefijo `S3-HUXX-TXX:`.
- Fix de emoji/estilo va en commit separado.
- `git log --oneline` debe leerse como historia coherente.

---

## 6. Tests unitarios

Siempre antes de pushear.

```bash
# Frontend
cd /home/icin/minegocio-frontend && npx vitest run

# Backend
cd /home/icin/minegocio-backend && go test ./... -v
```

---

## 7. Push a Gitea

```bash
git add -A
git commit -m "S3-HUXX-TXX: descripcion"
git push gitea S3-HUXX-TXX-descripcion-breve   # sin -f
git push -f gitea S3-HUXX-TXX-descripcion-breve # solo si se reescribio historia
```

> `-f` solo en ramas personales, nunca en main o compartidas.

---

## 8. Merge a Dev

1. Merge a `dev`
2. Notificar al equipo
3. Companeros prueban en sandbox dev
4. Reportar bugs en Obsidian/canal

---

## 9. Merge a Main (Produccion)

Solo cuando:
- Paso por dev y fue testeado por >=1 companero
- Sin bugs criticos
- Build pasa

```bash
git checkout main && git pull gitea main
git merge --no-ff S3-HUXX-TXX-descripcion-breve
git push gitea main
```

Usar `--no-ff` para preservar historia de la rama.

---

## 10. Actualizar documentacion

### README.md (en main, no en ramas feature)
- `minegocio-frontend/README.md` -- nuevas rutas/componentes/config
- `minegocio-backend/README.md` -- nuevos endpoints/env vars

### Obsidian vault
- `Projects/MiNegocio/MiNegocio.md` -- estado del proyecto, ramas activas
- `Tasks/` -- notas de tarea especifica
- `Knowledge/decisiones.md` -- decisiones tecnicas nuevas
- `Knowledge/lecciones.md` -- errores, soluciones, workarounds

---

## Checklist pre-push

- [ ] `git log --oneline` con commits claros y separados
- [ ] No hay `fetch()` directo en `views/` (solo via `services/`)
- [ ] No hay colores hardcodeados (usar `var(--color-*)`)
- [ ] No hay `console.log()` ni codigo comentado
- [ ] Backend: `go build ./...` pasa
- [ ] Backend: `go vet ./...` pasa
- [ ] Backend: `go test ./...` pasa
- [ ] Frontend: `npm run build` pasa
- [ ] Frontend: `npx vitest run` pasa
- [ ] No hay archivos basura (node_modules/, dist/, binarios)
- [ ] `git status` muestra solo archivos intencionados
