---
tags: [minegocio, devops, configuracion]
---

# Dev-Prod Parity Fixes

## Date
2026-06-19

## Issues Found and Fixed

### 1. `registro_ventas` Schema Mismatch
- **Prod** had old: `id SERIAL PK, items JSONB, monto INTEGER, fecha TIMESTAMP`
- **Dev** has normalized: `id_venta SERIAL PK, id_producto FK, precio_producto, cantidad, fecha_venta, id_vendedor FK`
- **Fix**: Dropped old table in prod, created new one matching dev. Updated `esquema.sql`.

### 2. `inventario_view` Missing in Prod
- **Fix**: Created `CREATE OR REPLACE VIEW inventario_view` in prod

### 3. Carrito: Missing Product Images
- `CarritoCompras.vue` didn't display images; `VentasPage.vue` didn't include `imagen_url` in cart items
- **Fix**: Added image thumbnail + included `imagen_url` in cart item objects

### 4. CORS Missing PATCH Method
- **Fix**: Added `PATCH` to allowed methods in `main.go`

### 5. `PATCH /api/inventario/{id}` Route Not Wired
- Handler existed but no route in `routes.go`
- **Fix**: Added route registration

## Changes Deployed (via Jenkins)
- **MiNegocio-database** #1 ✅
- **MiNegocio-backend** #8 ✅
- **MiNegocio-Front** #3 ✅

All 3 pipelines green. Ready for tomorrow.
