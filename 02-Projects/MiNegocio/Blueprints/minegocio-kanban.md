# Kanban Board — MiNegocio

> Copiar este tablero a tu sistema de gestión (Obsidian, Notion, Trello, etc.)

---

## 📋 Pendiente

### Sprint 4 — Seguridad + Roles
- [ ] Roles de usuario (admin, cajero, bodeguero) `P0` `sprint-4`
- [ ] Autenticación JWT (login, refresh tokens) `P0` `sprint-4`
- [ ] Rate limiting (anti-abuso) `P0` `sprint-4`
- [ ] CORS configurado para producción `P0` `sprint-4`
- [ ] Validación de inputs (sanitización) `P0` `sprint-4`

### Sprint 5 — Producción
- [ ] Deploy backend (Railway/Render) `P0` `sprint-5`
- [ ] Deploy frontend (Vercel/Netlify) `P0` `sprint-5`
- [ ] Variables de entorno para producción `P0` `sprint-5`
- [ ] Health checks y monitoreo básico `P0` `sprint-5`
- [ ] Backup automático de DB `P0` `sprint-5`

### Sprint 6 — Features Finales
- [ ] Historial de ventas con filtros `P0` `sprint-6`
- [ ] Exportar reportes a PDF/Excel `P0` `sprint-6`
- [ ] Gestión de clientes (fidelización) `P1` `sprint-6`
- [ ] Sistema de notificaciones (bajo stock, vencimiento) `P1` `sprint-6`

### P1 — Post-MVP
- [ ] App móvil (React Native) `P1` `sprint-7+`
- [ ] Integración con POS físico `P1` `sprint-7+`
- [ ] Múltiples sucursales `P1` `sprint-7+`
- [ ] API pública para terceros `P1` `sprint-7+`

### P2 — Futuro
- [ ] IA para predicción de demanda `P2` `backlog`
- [ ] Integración con bancos (pagos electrónicos) `P2` `backlog`
- [ ] Marketplace para proveedores `P2` `backlog`

---

## 🔧 En Progreso

*Vacío al inicio*

---

## 👀 En Revisión

*Vacío al inicio*

---

## ✅ Hecho

- [x] Sprint 1: Setup + Modelo de datos `P0` `sprint-1`
- [x] Sprint 2: CRUD Productos + Categorías `P0` `sprint-2`
- [x] Sprint 3: Dashboard + Ventas básico `P0` `sprint-3`

---

## Labels

| Label | Color | Uso |
|-------|-------|-----|
| `P0` | 🔴 Rojo | MVP — obligatorio |
| `P1` | 🟡 Amarillo | Post-MVP — importante |
| `P2` | 🟢 Verde | Futuro — nice-to-have |
| `feature` | 🔵 Azul | Nueva funcionalidad |
| `bug` | 🟠 Naranja | Corrección |
| `tech-debt` | ⚫ Gris | Deuda técnica |
| `docs` | 🟣 Púrpura | Documentación |
| `sprint-4` | — | Sprint 4 — Seguridad |
| `sprint-5` | — | Sprint 5 — Producción |
| `sprint-6` | — | Sprint 6 — Features Finales |
| `sprint-7+` | — | Sprints futuros |
| `backlog` | — | Backlog general |

---

## Dependencias

| Card | Depende de | Notas |
|------|-----------|-------|
| Roles de usuario | Sprint 3 completado | Necesita auth funcional |
| Autenticación JWT | Roles de usuario | Sistema de permisos |
| Rate limiting | JWT | Protección contra abuso |
| CORS | JWT | Configuración de seguridad |
| Validación inputs | JWT | Sanitización de datos |
| Deploy backend | Sprint 4 completado | Requiere seguridad lista |
| Deploy frontend | Deploy backend | Frontend necesita backend |
| Variables entorno | Deploy backend | Configuración de producción |
| Health checks | Deploy backend | Monitoreo básico |
| Backup DB | Deploy backend | Persistencia de datos |
| Historial ventas | Sprint 3 completado | Datos de ventas existentes |
| Exportar PDF | Historial ventas | Requiere datos formateados |
| Clientes | Historial ventas | Extiende sistema de ventas |
| Notificaciones | Inventario existente | Alertas automáticas |

---

## Métricas de Progreso

| Sprint | Total | Hecho | En Progreso | Pendiente |
|--------|-------|-------|-------------|-----------|
| Sprint 4 | 5 | 0 | 0 | 5 |
| Sprint 5 | 5 | 0 | 0 | 5 |
| Sprint 6 | 4 | 0 | 0 | 4 |
| P1 | 4 | 0 | 0 | 4 |
| P2 | 3 | 0 | 0 | 3 |
| **Total** | **21** | **3** | **0** | **18** |

---

*Generado con project-planner skill — 2026-07-12*
