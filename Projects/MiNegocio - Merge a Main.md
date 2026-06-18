---
tags: [proyecto/MiNegocio, estado/bloqueado]
---
# MiNegocio — Smoke Test & Merge a Main

> **LEER Y ELIMINAR** — Esta nota se auto-destruye. Después de leerla, bórrala con `rm` o `trash`.

---

## ⛔ RESULTADO DEL SMOKE TEST (2026-06-18)

**VEREDICTO: NO LISTO — 3 BLOQUEANTES**

---

### 🔴 BUG-001 — Backend container desactualizado
**Componente:** c-devops | **Severidad:** BLOQUEANTE

El contenedor backend en `192.168.50.25:3000` fue construido el **2026-06-15**. Los merges S2-HU04 son del **2026-06-18**. El binario NO tiene:
- `GET /api/productos/buscar` → 404
- `GET /api/inventario` → 404 (ni en routes.go)
- Endpoints de imágenes → 404

**Fix:**
```bash
# En el servidor DEV
cd /ruta/a/MiNegocio-backend
git checkout main
git pull origin main
docker build -t minegocio-backend:latest .
docker stop backend 2>/dev/null ; docker rm backend 2>/dev/null
docker run -d --name backend -p 3000:3000 minegocio-backend:latest
```

---

### 🔴 BUG-002 — BD sin seed data
**Componente:** c-database | **Severidad:** BAJO

El único producto en BD tiene campos vacíos (imagen_url, codigo_barras, etc.). Agregar seed data para validar campos completos en la respuesta JSON.

---

### 🔴 BUG-003 — feat/inventario-endpoints sin mergear + ruta faltante
**Componente:** c-back | **Severidad:** BLOQUEANTE

Dos problemas:
1. La rama `feat/inventario-endpoints` tiene 2 commits que nunca se mergearon a `main`
2. El endpoint `/api/inventario` nunca se registró en `routes.go` — el archivo `inventario_handler.go` existe pero está huérfano

**Fix:**
```bash
cd /ruta/a/MiNegocio-backend
git checkout main
git merge feat/inventario-endpoints
# Luego editar routes.go y agregar:
#   router.HandleFunc("/api/inventario", inventario_handler.GetInventario).Methods("GET")
git add -A && git commit -m "fix: merge inventario-endpoints + registrar ruta /api/inventario"
git push origin main
```

---

### 🔴 BUG-004 — Frontend bundle desactualizado
**Componente:** c-devops | **Severidad:** BLOQUEANTE

El frontend compilado no incluye `GaleriaProductos` ni `BuscadorProductos`. Solo existe el formulario de carga de imágenes. Puerto 8081 caído (sin container/servicio).

**Fix:**
```bash
cd /ruta/a/MiNegocio-frontend
git checkout main
git pull origin main
npm install
npm run build
# Copiar a donde sirva nginx:
sudo cp -r dist/* /var/www/dev/frontend/
# o levantar contenedor:
docker build -t minegocio-frontend:latest .
docker stop frontend 2>/dev/null; docker rm frontend 2>/dev/null
docker run -d --name frontend -p 8081:80 minegocio-frontend:latest
```

---

## 📋 ORDEN DE ACCIÓN RECOMENDADO

```
1. c-back:   Mergear feat/inventario-endpoints → main + routes.go
2. c-database: Agregar seed data a BD (opcional, baja prioridad)
3. c-devops: Rebuild backend container desde main
4. c-devops: Rebuild frontend bundle + levantar servicio
5. QA:       Re-ejecutar smoke test completo
```

---

## 🔍 DETALLE DEL SMOKE TEST

### Endpoints verificados (los que respondieron)
| Endpoint | Método | Status | Response |
|---|---|---|---|
| `/api/productos` | GET | ✅ 200 | Array vacío (sin seed data) |
| `/api/login` | POST | ✅ 200 | Token JWT |
| `/api/productos` | POST | ✅ 201 | Producto creado (admin/admin) |
| `/api/productos/buscar?q=test` | GET | ❌ 404 | No implementado en binario |
| `/api/productos/{id}/imagenes` | GET | ❌ 404 | No implementado en binario |
| `/api/inventario` | GET | ❌ 404 | No implementado en routes.go |

### Estado de repos (Gitea)
- `VHerrera/MiNegocio-backend`: 11 ramas, main OK (pero feat/inventario-endpoints sin mergear)
- `VHerrera/MiNegocio-database`: 5 ramas, main OK
- `VHerrera/MiNegocio-frontend`: 10 ramas, main OK

### Credenciales DEV
- URL Backend: http://192.168.50.25:3000
- URL Frontend: http://192.168.50.25:8081 (CAÍDO)
- Login: admin / admin (comparación texto plano contra password_hash)

---

> **⚠️ INSTRUCCIÓN DE ELIMINACIÓN**
> Después de leer, borra esta nota:
> ```bash
> rm /ruta/al/vault/Projects/MiNegocio\ -\ Merge\ a\ Main.md
> ```
> O desde Obsidian: botón derecho → "Delete file"
