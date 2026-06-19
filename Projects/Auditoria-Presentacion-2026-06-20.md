# Auditoría Pre-Presentación — MiNegocio
**Fecha:** 2026-06-19 | **Presentación:** 2026-06-20

---

## Veredicto General: ⚠️ CONDICIONALMENTE LISTO

El sistema está **corriendo** pero tiene **3 acciones obligatorias** antes de presentar.

---

## Estado de Contenedores

| Contenedor | Puerto | Estado |
|---|---|---|
| `minegocio-backend` | 3001 → 3000 | ✅ Up |
| `frontend` (nginx) | 8081 → 80 | ✅ Up |
| PostgreSQL | host:5432 | ✅ Conectado |

---

## Estado Git — Los 3 repos NO están pusheados a Gitea

| Repo | Rama | Commits locales sin push | Cambios sin commit |
|---|---|---|---|
| minegocio-frontend | main | **+4** | ⚠️ App.vue + LoginPage.vue modificados |
| minegocio-backend | main | **+8** | ✅ limpio |
| minegocio-database | main | **+2** | ✅ limpio |

### Cambios sin commitear en Frontend
- `App.vue`: Fix de reactividad del token (computed → data + watch + token=null al cerrar sesión)
- `LoginPage.vue`: Cambia endpoint `/api/login` → `/api/auth/login` + guarda refresh_token

---

## Estado de Ambientes

### PROD (192.168.50.25:8000) ✅ FUNCIONAL
- Nginx host → `/var/www/prod/frontend` + proxy `/api/` → localhost:3001
- Build actualizado: Jun 19 05:08
- Backend en 3001 responde correctamente

### DEV (192.168.50.25:8080) ❌ API ROTA
- Nginx DEV hace proxy `/api/` → localhost:3000
- **Nada escucha en puerto 3000** — connection refused en todas las llamadas API
- Build: Jun 19 02:39

**Para la demo usar PROD (puerto 8000), NO el DEV.**

---

## PRs Abiertos en Gitea

| PR | Rama | Descripción |
|---|---|---|
| PR#11 | S2-STL-Frontend-Redesign | Rediseño UI (NavBar, SideBar, Dashboard) |
| PR#10 | S2-HU04-Frontend-CargaImagenes | FormularioProducto con drag&drop |

No bloquean la demo pero quedan pendientes.

---

## Checklist Pre-Presentación

### 🔴 Obligatorio (hacer ANTES de la demo)
- [ ] Commitear cambios de `App.vue` y `LoginPage.vue`
- [ ] Rebuildar frontend y actualizar `/var/www/prod/frontend`
- [ ] Confirmar credenciales de un usuario en `cliente_prod` para hacer login en demo

### 🟡 Recomendado
- [ ] Push de los 3 repos a Gitea (frontend +4, backend +8, DB +2)
- [ ] Smoke test en `http://192.168.50.25:8000`: login → galería → venta → inventario
- [ ] Decidir PR#11 y PR#10 (mergear o cerrar)

### 🟢 Deuda técnica (post-presentación)
- [ ] Reparar nginx DEV (cambiar proxy de localhost:3000 → localhost:3001)
- [ ] Resolver conflicto git en `Knowledge/lecciones.md`
- [ ] Completar `Knowledge/decisiones.md` con ADRs

---

## Mapa de URLs

| Ambiente | URL | Estado |
|---|---|---|
| **Demo (usar esta)** | http://192.168.50.25:8000 | ✅ |
| DEV | http://192.168.50.25:8080 | ❌ API rota |
| Frontend Docker | http://192.168.50.25:8081 | ⚠️ sin proxy API |
| Backend directo | http://192.168.50.25:3001 | ✅ |
| Gitea | http://192.168.50.28:3000 | ✅ |

---

## Funcionalidades Listas para Demo

✅ Login con JWT + bcrypt  
✅ Galería de productos con buscador y filtros  
✅ Carga de imágenes drag&drop  
✅ Punto de venta (carrito)  
✅ Inventario con estados Normal/Bajo/Agotado  
✅ Registro de ventas  
✅ CRUD productos  
✅ Navbar de navegación  
