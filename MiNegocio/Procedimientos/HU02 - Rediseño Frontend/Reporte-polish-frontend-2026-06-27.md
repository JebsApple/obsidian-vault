---
tags: [proyecto/minegocio, sprint-3, reporte, s3-hu02, victor, sandbox, polish, diseño]
fecha: 2026-06-27
tipo: reporte-polish
rama: sandbox/proc-front
---

# Reporte: Polish de Diseño Frontend — S3-HU02
**Fecha:** 2026-06-27 | **Sprint:** 3 | **Rama:** `sandbox/proc-front` | **Responsable:** Victor Herrera

---

## Resumen

Segunda sesión de trabajo sobre `sandbox/proc-front`. Se aplicaron correcciones de bugs visuales detectados en deploy, una lección de arquitectura JWT, y una ronda completa de polish de UI. Rama sincronizada en Gitea con 8 commits sobre `main`.

---

## Bugs corregidos (post-reporte anterior)

### 1. Favicon (Bug #1)
- **Antes:** Pestaña del browser mostraba el logo Vue CLI por defecto
- **Fix:** `public/favicon.svg` creado con el SVG del kiosko MiNegocio. `public/index.html` actualizado con `type="image/svg+xml"`

### 2. Sidebar "gris a la mitad" en mobile (Bug #2)
- **Antes:** En viewport ≤768px el sidebar ocupaba solo su alto natural, dejando espacio blanco debajo
- **Fix:** `App.vue` y `SideBar.vue` con `@media (max-width: 768px)` — sidebar ocupa ancho completo, nav horizontal, `height: auto`

### 3. Imágenes de productos 404 (Bug #3)
- **Antes:** `<img :src="p.imagen_url">` daba 404 porque nginx no proxiaba `/uploads/`
- **Fix:** `vue.config.js` — proxy `/uploads/ → localhost:3000` en devServer. Producción requiere config nginx (tarea de infra)

### 4. Login no guardaba usuario en localStorage (Bug #4 silencioso)
- **Antes:** LoginPage solo guardaba `token` + `refresh_token`. Sidebar mostraba "Usuario" siempre
- **Fix inicial:** Se guardó `usuario` JSON + `esAdmin` en localStorage
- **Refactor posterior:** Eliminado (ver sección arquitectura JWT abajo)

---

## Refactor: JWT como fuente única de verdad

**Problema identificado:** Guardar `usuario` y `esAdmin` en localStorage crea dos fuentes de verdad sincronizables. Si el backend emite un nuevo JWT con rol diferente, localStorage queda desactualizado.

**Solución aplicada:**
- `authService.js` → `getUserFromToken()` nueva función que decodifica el JWT con `jwtDecode` (ya instalado) y retorna `{ id, nombre, rol }`
- `SideBar.vue` → `usuarioNombre` y `esAdmin` ahora son computed que leen el JWT directamente
- `LoginPage.vue` → guarda solo `token` + `refresh_token`, nada más
- Lección registrada en `Knowledge/lecciones.md`

---

## Polish de UI

### Avatar de usuario con iniciales
- **Antes:** Icono genérico `<i class="ti ti-user">` en cuadrado gris
- **Ahora:** Círculo rojo (`#d60000`) con inicial del nombre del usuario en blanco
- **Implementación:** `computed usuarioInicial()` → `.charAt(0).toUpperCase()`. CSS `.avatar-initial` con `font-weight: 700`
- **Archivo:** `SideBar.vue`

### Rediseño completo de LoginPage
| Elemento | Antes | Ahora |
|----------|-------|-------|
| Layout | Centrado simple sin tarjeta | Card con sombra, fondo `#f4f4f2` |
| Branding | Solo `<h2>Login</h2>` | Logo SVG kiosko + "MiNegocio" con paleta roja/negra + subtítulo |
| Labels | Sin labels | Labels `"Usuario"` / `"Contraseña"` con font-weight 600 |
| Focus | Border rojo | Border rojo + `box-shadow 0 0 0 3px rgba(214,0,0,0.08)` |
| Botón | Simple rojo | Estado loading con spinner animado + texto "Ingresando..." |
| Error | Texto rojo simple | Card roja con badge circular `!` y borde `#fecaca` |
| Estado disabled | Sin estado | Inputs + botón con `opacity: 0.65` durante carga |

### VentasPage — eliminación de inline styles
- **Antes:** 6 elementos con `style="..."` incluyendo `@mouseenter`/`@mouseleave` en JS para simular hover
- **Ahora:** Clases `.productos-grid`, `.producto-card`, `.producto-nombre`, `.producto-precio`, `.producto-stock`, `.busqueda-input`
- **Mejora extra:** Hover con CSS puro → `border-color: var(--color-brand)` + `transform: translateY(-1px)` (imposible con inline `@mouseenter`)

### InventarioPage — eliminación de inline styles
- **Antes:** 7 elementos con `style="..."`
- **Ahora:** Clases `.resultados-lista`, `.resultado-item`, `.resultado-info`, `.resultado-nombre`, `.resultado-stock-actual`, `.stock-input`, `.btn-agregar`
- **Mejora extra:** `.resultado-item:hover` con `border-color: var(--color-brand)` en CSS

### Ganancia estimada en FormularioProducto
- **Antes:** Badge azul fijo independiente del margen
- **Ahora:** Verde (`#16a34a`, `#f0fdf4`) cuando precio_venta > precio_compra, rojo (`#dc2626`, `#fef2f2`) cuando no
- **Clases:** `.ganancia-badge--ok` / `.ganancia-badge--perdida`

### Modal personalizado (AppModal)
- **Antes:** `alert()` y `confirm()` nativos del browser
- **Ahora:** `AppModal.vue` — modal con animación fade, icono circular, botones con paleta del proyecto
- **API:** `this.$modal.alert(msg)` / `this.$modal.confirm(msg)` (Promise-based via `provide/inject`)
- **Reemplazos:** CarritoCompras (venta registrada + error), ProductosRegistrados (eliminar), ProductosPage (eliminar)

---

## Arquitectura de la solución modal

```
App.vue
  └── provide: { $modal: { alert, confirm } }  ← ref a AppModal
  └── <AppModal ref="modal" />                 ← una instancia global

CarritoCompras / ProductosPage / ProductosRegistrados
  └── inject: ['$modal']
  └── await this.$modal.confirm('¿Eliminar?')  ← Promise<boolean>
  └── await this.$modal.alert('Venta registrada #...')
```

---

## Tests

**Estado final:** 23/23 ✅ (5 suites)

| Suite | Tests | Estado |
|-------|-------|--------|
| SideBar.test.js | 5 | ✅ — actualizado: usa JWT fake en lugar de `localStorage.setItem('esAdmin')` |
| AnalisePage.test.js | 4 | ✅ |
| AdminUsuariosPage.test.js | 4 | ✅ |
| authGuard.test.js | 7 | ✅ |
| LoginPage.test.js | 3 | ✅ — selector actualizado a `.login-error` |

---

## Commits en `sandbox/proc-front`

| Hash | Descripción |
|------|-------------|
| `6e3bdca` | feat: avatar con iniciales, rediseño login, limpieza inline styles |
| `aae642c` | fix: renombrar _resolve a resolveFn (vue/no-reserved-keys) |
| `0badd57` | feat: modal personalizado reemplaza alert/confirm nativos del browser |
| `425c93c` | fix: ganancia estimada verde/rojo según precio de compra vs venta |
| `9eac9c6` | refactor: leer nombre y rol del JWT en vez de duplicar en localStorage |
| `6bb00c0` | fix: 4 bugs frontend (favicon, sidebar mobile, uploads proxy, login) |
| `75e1326` | fix+test: correcciones ponytail + 20 tests unitarios Vitest |
| `015c186` | feat: sandbox proc-front S3-HU02 — base frontend |

---

## Pendiente (infra — fuera de scope de código)

- **nginx prod/dev:** `location /uploads/ { proxy_pass http://localhost:3001; }` para imágenes en deploy real
- **BD:** limpiar productos de prueba (`nombre LIKE 'Test%'` o `nombre = 'awa'`)

---

## Estado del sandbox

```
Rama:    sandbox/proc-front (8 commits sobre main)
Build:   ✅ sin errores
Tests:   ✅ 23/23 passing
Puerto:  8082 (dev server local)
Gitea:   actualizado → commit 6e3bdca
```

---

## Referencias

- [[Reporte-proc-front-2026-06-27]] — reporte base anterior
- [[Errores-Frontend-a-corregir-2026-06-26]] — fuente de los bugs corregidos
- [[MiNegocio/Conocimiento/lecciones]] — lección JWT localStorage registrada
