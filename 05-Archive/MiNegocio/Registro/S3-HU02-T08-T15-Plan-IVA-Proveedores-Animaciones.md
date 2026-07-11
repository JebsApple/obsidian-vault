---
tags: [proyecto/minegocio, sprint-3, plan, frontend, backend, database]
updated: 2026-07-02
---

# Plan: IVA + Proveedores + Animaciones Sidebar + Ripple (S3-HU02)

## Contexto

Basado en exploracion del proyecto:
- **Frontend** (`S3-HU02`, rama activa): Sidebar con animacion cortina y mancha radial estatica (CSS gradient). Ventas.vue con cambios sin commit. FormularioProducto sin IVA ni proveedores.
- **Backend** (`main`, limpio): Producto struct sin campo IVA ni `id_proveedor`.
- **Obsidian**: S3-HU05 documentado pero pendiente (Gabriel). Tareas T06-T12 registradas.
- **8080 vs 8082**: mismo codigo (8080=build nginx, 8082=dev server hot-reload).

## Decisiones del usuario

| Aspecto | Decision |
|---------|----------|
| IVA | Desglose visual 19% chileno. `precio_sin_iva = precio_venta / 1.19` calculado automaticamente. Se almacena `precio_sin_iva` en DB. |
| Proveedores | Solo campo `id_proveedor` + `<select>` preparado en FormularioProducto. Gabriel hara CRUD completo despues. |
| Sidebar | Spring + stagger + micro-movimientos (Fable elige lo mas moderno) |
| Ripple | Circular rojo desde el centro. Sidebar + botones principales. |
| HU | T08 extendido (animaciones) + nueva T15 (IVA+proveedores) dentro de S3-HU02 |

---

## Tarea A: S3-HU02-T08 — Animaciones (EXTENDIDA)

### Archivos

| Archivo | Cambio |
|---------|--------|
| `src/components/SideBar.vue` | Spring easing `cubic-bezier(0.34, 1.56, 0.64, 1)` en colapso. Stagger en `.nav-item` con `transition-delay` incremental. Micro-movimientos iconos (scale + translateY hover). Reemplazar mancha radial estatica por ripple animado. |
| `src/styles/variables.css` | Token `--ripple-color: #d60000` |
| `src/styles/base.css` | Clase `.ripple` + keyframes `ripple-effect`. Pseudo-elemento `::after` con `transform: scale(0)->scale(4)` + opacidad fade, 0.6s ease-out. |
| Botones en vistas | Agregar clase `.ripple` a `.btn-primary`, `.btn-icon`, `.btn-sm` |

### Efectos concretos

1. **Sidebar colapso**: `transition: width 0.5s cubic-bezier(0.34, 1.56, 0.64, 1)`. Contenido usa `scaleX + opacity + filter: blur(2px)`.
2. **Stagger**: Cada `.nav-item` con `transition-delay: calc(0.04s * index)` al abrir.
3. **Ripple**: Onda circular roja `#d60000` desde el centro del elemento al hacer clic. CSS puro con `::after` + keyframes. No requiere JS.
4. **Iconos**: `transform: translateY(-1px) scale(1.1)` en hover con `transition 0.2s`.

### CA T08

- [ ] Sidebar colapsa con spring fluido (sin cortes)
- [ ] Stagger visible al abrir (items aparecen uno tras otro)
- [ ] Ripple rojo visible desde el centro en nav-items y botones
- [ ] Ripple no bloquea eventos click
- [ ] `npm run build` exitoso

---

## Tarea B: S3-HU02-T15 — IVA + Campo Proveedor

### DB (`esquema.sql`)

```sql
ALTER TABLE public.productos ADD COLUMN IF NOT EXISTS precio_sin_iva INTEGER DEFAULT 0;
ALTER TABLE public.productos ADD COLUMN IF NOT EXISTS id_proveedor INTEGER REFERENCES public.proveedores(id) ON DELETE SET NULL;
```

### Backend

**`models/models.go`:**
```go
// En Producto:
PrecioSinIVA int  `json:"precio_sin_iva"`
IDProveedor  *int `json:"id_proveedor,omitempty"`

// En CreateProductoRequest:
PrecioSinIVA int  `json:"precio_sin_iva,omitempty"`
IDProveedor  *int `json:"id_proveedor,omitempty"`
```

**`repository/producto_repository.go`:**
- Todos los SELECT incluyen `precio_sin_iva` e `id_proveedor`
- INSERT incluye ambas columnas. Si `precio_sin_iva` = 0, calcular como `precio_venta * 100 / 119`
- UPDATE incluye ambas columnas

**`handler/producto_handler.go`:**
- Si `req.PrecioSinIVA == 0`, calcular: `req.PrecioVenta * 100 / 119`

### Frontend

**`components/FormularioProducto.vue`:**
- `data().form`: agregar `precio_sin_iva`, `id_proveedor`
- Template: despues de precio_venta, mostrar desglose:
  ```html
  <div class="field" v-if="form.precio_venta > 0">
    <label>IVA 19%</label>
    <div class="iva-desglose">
      <span class="iva-valor">+${{ ivaValor().toLocaleString('es-CL') }} IVA</span>
      <span class="iva-sub">Sin IVA: ${{ sinIVA().toLocaleString('es-CL') }}</span>
    </div>
  </div>
  ```
- Template: despues de Marca, agregar:
  ```html
  <div class="field">
    <label>Proveedor</label>
    <select v-model="form.id_proveedor">
      <option value="">Sin proveedor</option>
    </select>
  </div>
  ```
- Metodos: `sinIVA()` = `Math.round(this.form.precio_venta / 1.19)`, `ivaValor()` = `this.form.precio_venta - this.sinIVA()`
- `mounted` (editar): mapear `precio_sin_iva`, `id_proveedor`
- `procesarEscaneo`: mapear ambos campos al popular formulario

**`views/Productos.vue`:**
- Tabla Registrados: columna "P. Sin IVA" despues de "P. Venta"
  ```html
  <th>P. Sin IVA</th>
  <td>${{ p.precio_sin_iva ? p.precio_sin_iva.toLocaleString('es-CL') : '—' }}</td>
  ```

**`styles/productos.css`:**
- Estilos `.iva-desglose`, `.iva-valor`, `.iva-sub`

### CA T15

- [ ] Al crear producto, `precio_sin_iva` se calcula y guarda
- [ ] Formulario muestra desglose IVA en tiempo real
- [ ] Tabla Productos muestra columna P. Sin IVA
- [ ] Select proveedor visible en formulario (vacio, sin errores)
- [ ] `go build ./...` exitoso
- [ ] `npm run build` exitoso

---

## Registro en Obsidian (Post-implementacion)

### Marcar pruebas en `Registro/S3-HU02-Registro-Taiga.md`

```markdown
### YYYY-MM-DD: S3-HU02-T08 - Animaciones sidebar + ripple

**Estado:** ✅ Listo para commit
**Archivos:** SideBar.vue, base.css, variables.css
**Pruebas:**
- [x] npm run build ✅
- [x] Sidebar colapsa con spring fluido
- [x] Stagger visible al abrir
- [x] Ripple rojo en nav-items y botones

### YYYY-MM-DD: S3-HU02-T15 - IVA + proveedores

**Estado:** ✅ Listo para commit
**Archivos:** esquema.sql, models.go, producto_repository.go, producto_handler.go, FormularioProducto.vue, Productos.vue
**Pruebas:**
- [x] go build ./... ✅
- [x] npm run build ✅
- [x] IVA 19% calculado correctamente (1190->190)
- [x] Select proveedor visible
```

### Commits preparados

```bash
# Commit 1: Animaciones
git add src/components/SideBar.vue src/styles/base.css src/styles/variables.css
git commit -m "S3-HU02-T08: mejorar animacion sidebar con spring + stagger + ripple en iconos y botones"

# Commit 2: IVA + proveedores
git add src/components/FormularioProducto.vue src/views/Productos.vue src/styles/productos.css
git add ../minegocio-backend/models/models.go ../minegocio-backend/repository/producto_repository.go ../minegocio-backend/handler/producto_handler.go
git add ../minegocio-database/esquema.sql
git commit -m "S3-HU02-T15: agregar desglose IVA 19% y campo id_proveedor en formulario producto"
```

### Actualizar vault

- `MiNegocio/MiNegocio.md`: marcar T08 y T15 como completadas
- `MiNegocio/Conocimiento/decisiones.md`: registrar decision IVA

---

## Prompt para Fable 5

```
Eres desarrollador full-stack MiNegocio (Vue 3 + Go).

CONTEXTO:
- Frontend: /home/icin/minegocio-frontend/, rama S3-HU02, puerto 8082
- Backend: /home/icin/minegocio-backend/, rama main, puerto 3000
- DB: /home/icin/minegocio-database/esquema.sql
- Paleta: rojo #d60000, blanco, negro

TAREA 1 — S3-HU02-T08: Animaciones
1. SideBar.vue: transition width spring cubic-bezier(0.34, 1.56, 0.64, 1) 0.5s. scaleX + opacity + blur. Stagger nav-items.
2. base.css: .ripple con ::after, keyframes ripple-effect (scale 0->4, opacity fade). 0.6s ease-out. Color #d60000.
3. Aplicar .ripple a .nav-item, .btn-primary, .btn-icon, .btn-sm.
4. Iconos nav: translateY(-1px) scale(1.1) en hover.

TAREA 2 — S3-HU02-T15: IVA + Proveedores
1. DB: ALTER TABLE productos ADD precio_sin_iva, ADD id_proveedor FK.
2. models.go: PrecioSinIVA + IDProveedor.
3. repository: incluir campos en SQL.
4. handler: calcular PrecioSinIVA si es 0 (precio_venta*100/119).
5. FormularioProducto: desglose IVA automatico + select proveedor vacio.
6. Productos.vue: columna P. Sin IVA.

REGLAS: NO fetch directo en views. NO colores hardcodeados. Commits separados. NO push. Probar npm run build + go build.
```

---

## Limites

| SI incluye | NO incluye |
|------------|------------|
| IVA desglose visual 19% (front+back+DB) | CRUD completo proveedores (S3-HU05) |
| Campo id_proveedor preparado | Pagina gestion proveedores |
| Sidebar: spring + scaleX + blur + stagger | Animaciones KanbanBoard (T08 original) |
| Ripple rojo circular (sidebar+botones) | Refactor authService / codigo muerto |
| Registro en Obsidian para commit posterior | Push a Gitea o merge |
| Prompt para Fable 5 | Tests automatizados (solo build checks) |

---

## Checklist final

> **EJECUTADO 2026-07-02** — ver [[Sesion-2026-07-02-T08-T15-IVA-proveedores-fantasmas]].
> Alcance ampliado por Victor: fix de productos fantasma inventario/stock (causa raíz: Scan sin COALESCE descartaba filas en silencio + dependencia de inventario_view).

- [x] `go build ./...` pasa
- [x] `go vet ./...` pasa
- [x] `npm run build` pasa
- [x] IVA calculado correctamente (1190 -> IVA 190, sin IVA 1000)
- [x] Sidebar animacion spring fluida
- [x] Ripple visible en sidebar y botones
- [x] Select proveedor visible (vacio, sin errores)
- [x] Tabla Productos muestra P. Sin IVA
- [x] Obsidian vault actualizado
- [x] (extra) Inventario unificado con productos registrados — fantasmas eliminados
- [x] (extra) Deploy frontend a dev :8080 verificado
- [ ] Pendiente: aplicar ALTER a DB dev + rebuild contenedor backend + commits/push (Victor)
