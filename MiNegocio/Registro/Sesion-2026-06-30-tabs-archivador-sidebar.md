---
tags:
  - sesion
  - sprint3
  - frontend
  - S3-HU02
fecha: 2026-06-30
---

# Sesión 2026-06-30 — Pestañas estilo archivador + Sidebar colapsable

Rama local: `S3-HU02-T15-tabs-archivador-sidebar-colapsable` (creada desde `S3-HU02`).
Commit local: `94159e7` — **NO pusheado a Gitea** (por instrucción de Victor: nada en Gitea sin pedirlo).

## Objetivo
Pedido de Victor:
1. Replicar el switch de Inventario (Tablero/Stock) en Productos (Galería/Registrados) con la **misma apariencia**, pero rediseñado como **pestañas de archivador** con **curva invertida (cóncava)** en la unión con el contenedor de abajo, **solo del lado interior** (entre ambas pestañas).
2. Flechita a la derecha del nombre de usuario en la SideBar que **recoge la barra hacia arriba** dejando solo el logo "MiNegocio", con flechita hacia abajo para reexpandir, dando espacio al contenido con transición suave.
3. Todo responsive, textos/imágenes legibles, animaciones fancy en iconos y botones.

## Cambios realizados

### Pestañas estilo archivador
- **`src/styles/productos.css`** (fuente única, importada por ambas vistas): clases `vista-switch`, `vista-tab`, `tab-inicio`, `tab-fin`, `vista-tab-badge`, `vista-panel`.
  - Curva cóncava interior vía `mask: radial-gradient(circle ... at <esquina>)` en el pseudo-elemento `::after` de la pestaña activa. `tab-inicio` curva a la derecha, `tab-fin` a la izquierda → el "valle" del archivador queda solo entre ambas.
  - Pestaña activa con fondo blanco que se funde con `.vista-panel`; inactivas en gris con hover `translateY(-2px)`.
  - Media queries 768/480: pestañas a ancho completo, panel sin overflow.
- **`src/views/Productos.vue`**: markup migrado de `pill-switch`/`pill-badge` a `vista-tab`/`vista-tab-badge`, contenido envuelto en `#panel-productos.vista-panel`. Eliminados estilos scoped viejos.
- **`src/views/Inventario.vue`**: markup migrado de `switch-btn`/`switch-badge` a las clases compartidas, contenido en `#panel-inventario.vista-panel`. Eliminados estilos scoped viejos.
- Accesibilidad: `role="tablist"`/`role="tab"`/`role="tabpanel"`, `aria-selected`, `aria-controls`, `type="button"`.

### Sidebar colapsable siempre disponible
- **`src/App.vue`**: `actualizarBreakpoint()` ahora deja `puedeColapsar = true` siempre (antes solo en pantallas <60% del ancho). Auto-expande en pantallas anchas como conveniencia, pero permite recoger manualmente.
- **`src/components/SideBar.vue`**: micro-animación en `.toggle-btn i` (rotación/scale con `cubic-bezier(0.34, 1.56, 0.64, 1)`). La lógica de colapso (`Transition name="sidebar-slide"`, flechita a la derecha del usuario, chevron-down junto al logo al colapsar) ya existía y quedó habilitada en todo breakpoint.

## Reporte de testeo
- **Build:** `npm run build` (Node 20 vía nvm) → verde, sin errores. Bundle final `app.1b09e67b.js`.
- **Deploy dev:** `rsync -av --delete dist/ /var/www/dev/frontend/` → OK. (Jenkins solo despliega prod; dev es manual.)
- **Smoke test:** `http://192.168.50.25:8080` → HTTP 200. Bundle nuevo servido. CSS desplegado contiene `vista-tab`, `tab-inicio` y `radial-gradient` (curva confirmada).
- **Code review (vue-reviewer):**
  - CRITICAL: 0
  - HIGH: 1 (ARIA en pestañas) → **resuelto** (roles + aria-selected + aria-controls + type=button).
  - MEDIUM: 2 → paginación fuera del `vista-panel` (aceptable, es control independiente debajo del panel); `type="button"` → resuelto.
  - Veredicto tras fixes: estructura `Transition`/`v-if`/`v-else` intacta, reactividad correcta.

## Pendientes / próximos pasos
- Verificación visual en navegador por Victor (Ctrl+Shift+R para saltar caché): curva del archivador, colapso de sidebar en escritorio, responsividad 320/768/1024/1440.
- Confirmar número de tarea **T15** en Taiga (tentativo; sigue a T14).
- Push a Gitea **solo cuando Victor lo pida**, respetando nomenclatura `S3-HU02-TXX-...`.
- Comentario de Taiga añadido en [[taiga-comentarios-S3-HU02]] (sección T15).

## Iteración 2 — Ajustes pedidos por Victor (revisión en navegador)
Tras ver la primera versión, Victor pidió 5 ajustes (confirmados vía preguntas):

1. **Curva del archivador volteada**: el notch cóncavo se mantiene del lado interior pero se espejó horizontalmente la esquina del `mask` (tab-inicio → `at 100% 0`, tab-fin → `at 0 0`).
2. **Pestañas 50/50**: `.vista-switch { width:100%; gap:0 }` + `.vista-tab { flex:1 1 0; justify-content:center }`. Las dos pestañas ocupan exactamente el ancho del panel.
3. **Relleno rojo completo en activa**: `.vista-tab.active { background: var(--color-brand); color:#fff }`, badge invertido (blanco con texto rojo), notch relleno en rojo. El rojo "salta" suave entre pestañas (`transition: background .25s`).
4. **Sidebar fluida sin rebote**: keyframes `cortinaAbrir`/`cortinaCerrar` (altura+opacidad+`translateY`) con `cubic-bezier(0.16,1,0.3,1)` (ease-out-expo); transición de `.sidebar` y `.main-content` alineada al mismo easing en SideBar.vue y App.vue.
5. **Mancha radial en icono activo (estática)**: `.nav-item--active .nav-icon` y `.nav-group-trigger--activo .nav-icon` usan `radial-gradient` rojo desde el centro + `background-clip:text` + `text-fill-color:transparent`. Como los iconos Tabler son de contorno, el rojo se ve solo a través de las líneas del glyph.

**Testeo iteración 2:** build verde (`app.e30a5f61.js` / `app.b702a819.css`), deploy a dev OK, HTTP 200. Verificado en el CSS desplegado: `vt-active`, `flex:1 1 0`, `background-clip:text`, `color-mix`, `cortinaAbrir` presentes. Pendiente verificación visual de Victor (curva del archivador y mancha del icono dependen del render real del navegador).

## Iteración 3 — Pestañas por capas (rehacer 1+2+3)
Victor aclaró que las pestañas deben leerse como **una sola barra**, no dos separadas. Modelo por capas:
- **Barra gris continua** (`.vista-switch` con fondo `#ececec` y redondeo superior) = capa de atrás con las dos etiquetas.
- **Rojo deslizante** (`.vista-switch::before`, 50% de ancho) que **navega** de un lado al otro con `transform: translateX` + `cubic-bezier(0.16,1,0.3,1)`. Es la pestaña activa; su parte inferior se mete por detrás del panel (no se corta hacia abajo).
- **Curvita cóncava** (`.vista-switch::after`) que viaja junto al rojo y **voltea de lado** durante el deslizamiento (mask radial, oculto por el movimiento). Marca la pestaña activa.
- **Panel** (`.vista-panel`) con `z-index: 3` por encima del rojo/gris; borde superior-izquierdo recto para conectar con la pestaña.
- **Texto** al frente (`z-index: 2`): blanco sobre el rojo (`.vista-tab.active`), gris fuera, con `transition: color`. **Badge** invertido sobre rojo (blanco con texto rojo) y normal fuera, con transición.
- **Markup**: cada vista pasa una clase de posición al contenedor (`:class="vistaActiva === 'galeria' ? 'sel-inicio' : 'sel-fin'"`; en Inventario `tablero`/`stock`).

**Testeo iteración 3:** build verde (`app.cbb8dec0.js` / `app.24150eaa.css`), deploy a dev OK, HTTP 200. Pendiente verificación visual de Victor (deslizamiento del rojo, curvita, tuck bajo el panel).

## Commits realizados (2026-06-30)

### Frontend (`S3-HU02-T15-tabs-archivador-sidebar-colapsable`)
3 commits incrementales sobre `94159e7`:

| Commit | Mensaje |
|--------|---------|
| `0608556` | `S3-HU02-T15: mejorar sidebar con transiciones suaves, animacion cortina y mancha radial en icono activo` |
| `048b28b` | `S3-HU02-T15: redisenar pestanas archivador modelo por capas con rojo deslizante` |
| `9c3dc18` | `S3-HU02-T15: migrar vistas inventario y productos a clases sel-inicio/sel-fin para pestanas capas` |

### Database (`S3-HU02-T13-fusion-vistas-recorte-imagen`)
3 commits incrementales sobre `74a2fcd`:

| Commit | Mensaje |
|--------|---------|
| `c99613a` | `S3-HU02-T13: limpiar scripts SQL obsoletos de sprint2` |
| `e113403` | `S3-HU02-T13: refactorizar esquema.sql con tablas usuarios, productos, registro_ventas, indices y vistas` |
| `feea94f` | `S3-HU02-T13: agregar seed_dev.sql con usuarios de prueba, migraciones y actualizar README` |

### Backend fix POS (`S3-HU02-T13-fusion-vistas-recorte-imagen`)

| Commit | Mensaje |
|--------|---------|
| `b0d5b13` | `S3-HU02-T13: fix POS usar id_vendedor desde JWT en vez del body` |

### Frontend fix POS (`S3-HU02-T15-tabs-archivador-sidebar-colapsable`)

| Commit | Mensaje |
|--------|---------|
| `73c44c9` | `S3-HU02-T15: eliminar id_vendedor hardcodeado del body, backend lo toma del JWT` |

### Fusión T14+T15

Se fusionaron ambas ramas en una sola con nombre corregido (español):

| Antes | Después |
|-------|---------|
| `S3-HU02-T14-sidebar-colapsable-tabs-folder-responsive` (EN) | ❌ Eliminada de Gitea |
| `S3-HU02-T15-tabs-archivador-sidebar-colapsable` (mixto) | ❌ Eliminada de Gitea |
| → | `S3-HU02-T14-sidebar-colapsable-pestanas-archivador` ✅ Nueva en Gitea |

Los 5 commits de T15 + fix POS ahora son `S3-HU02-T14:` y están en la nueva rama.

**Push a Gitea** (2026-06-30):
- Frontend `S3-HU02-T14-sidebar-colapsable-pestanas-archivador` → ✅ Pusheada
- Database `S3-HU02-T13-fusion-vistas-recorte-imagen` → ✅ Pusheada (fast-forward)

## Convenciones aplicadas
- Comentarios de código en español.
- Commit con prefijo `S3-HU02-T15:`, en español, sin emojis.
- Nada subido a Gitea sin pedido explícito.
