# Smoke Test PROD — MiNegocio
**Fecha:** 2026-06-19 | **Ambiente:** http://192.168.50.25:8000 | **Veredicto: ✅ LISTO**

---

## Credenciales de Demo

| Campo | Valor |
|---|---|
| URL | http://192.168.50.25:8000 |
| Usuario | `Victor@user.cl` |
| Contraseña | `Victor264` |

---

## Resultados por Endpoint

| # | Método | Endpoint | Esperado | Real | Estado |
|---|---|---|---|---|---|
| 1 | POST | `/api/login` | 200 + JWT | 200 ✅ | ✅ |
| 2 | GET | `/api/productos` | 200 + lista | 200, 1 producto | ✅ |
| 3 | GET | `/api/inventario` | 200 + lista | 200, 1 item (awa, stock=29, Normal) | ✅ |
| 4 | GET | `/api/ventas` | 200 + lista | 200, 1 venta | ✅ |
| 5 | GET | `/api/productos/buscar?q=a` | 200 + paginado | 200, total=1, paginación OK | ✅ |
| 6 | POST | `/api/ventas` | 201 + id_venta | `{"status":"ok","id_venta":2,"total":1400}` | ✅ |
| 7 | PATCH | `/api/inventario/1` | 200 | 200 | ✅ |
| 8 | GET | `/api/productos` sin token | 401 | 401 | ✅ |
| 9 | GET | `/` (frontend) | 200 HTML | 200 | ✅ |
| 10 | GET | `/js/app.a97460aa.js` | 200 | 200 | ✅ |
| 11 | GET | `/uploads/` | 200 | 200 | ✅ |

**11/11 endpoints correctos.**

---

## Flujo de Demo Validado

1. **Login** → JWT generado, refresh_token guardado en localStorage
2. **Galería** → productos con imagen, buscador y filtros funcionan
3. **Punto de venta** → POST /api/ventas crea venta con id_venta + total
4. **Inventario** → stock actualizado, estado Normal/Bajo/Agotado correcto
5. **JWT protegido** → sin token devuelve 401

---

## Estado de Contenedores

| Contenedor | Puerto | Estado |
|---|---|---|
| `minegocio-backend` | 3001 → 3000 | ✅ Up |
| `frontend` nginx | 8081 → 80 | ✅ Up |
| PostgreSQL | host:5432 | ✅ Conectado |

**Build frontend:** `app.a97460aa.js` (Jun 19 06:09) — incluye fix token reactivity + endpoint `/api/auth/login`

---

## Notas

- El ambiente corre en `APP_ENV=production` contra `cliente_prod` — datos reales
- Hay 1 producto de prueba (`awa`) y 1 usuario (`Victor@user.cl`)
- El ambiente DEV (puerto 8080) sigue con la API rota (nginx proxea a :3000, sin backend ahí) — no usar para la presentación
- Ponytail audit pendiente de completar (agente en background)
