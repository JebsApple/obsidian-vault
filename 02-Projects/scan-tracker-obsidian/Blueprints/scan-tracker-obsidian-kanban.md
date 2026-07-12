# Kanban Board — Scan Tracker Obsidian

> Copiar este tablero a tu sistema de gestión (Obsidian, Notion, Trello, etc.)

---

## 📋 Pendiente

### M7 — Testing
- [ ] Test flujo completo: sheets → lectura → UI `P0` `m7`
- [ ] Test multi-usuario: 2+ editando en paralelo `P0` `m7`
- [ ] Test edge cases: red lenta, sheet vacío, columnas faltantes `P0` `m7`
- [ ] Fix: conflictos de concurrencia (merge strategy) `P0` `m7`
- [ ] Documentación: README con instrucciones de uso `P0` `m7`
- [ ] **ENTREGABLE v1.0** `P0` `m7`

### P1 — Post-MVP
- [ ] Modo offline: caché de datos previos `P1` `p1`
- [ ] Notificaciones: alerta cuando cambia el sheet `P1` `p1`
- [ ] Métricas: tiempo por capítulo, productividad `P1` `p1`
- [ ] Búsqueda avanzada: por título, autor, fecha `P1` `p1`

### P2 — Futuro
- [ ] Integración con其他herramientas de scanlation `P2` `backlog`
- [ ] Exportar datos a CSV/Excel `P2` `backlog`
- [ ] Dashboard de productividad `P2` `backlog`

---

## 🔧 En Progreso

*Vacío al inicio*

---

## 👀 En Revisión

*Vacío al inicio*

---

## ✅ Hecho

- [x] M1: Arquitectura base + scaffolding `P0` `m1`
- [x] M2: Google Sheets reader (lectura) `P0` `m2`
- [x] M3: UI de comandos (modal) `P0` `m3`
- [x] M4: Escritura a sheets (batch) `P0` `m4`
- [x] M5: Búsqueda y filtrado `P0` `m5`
- [x] M6: Sync y caché `P0` `m6`

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
| `m7` | — | M7 — Testing |
| `p1` | — | Post-MVP |
| `backlog` | — | Backlog general |

---

## Dependencias

| Card | Depende de | Notas |
|------|-----------|-------|
| Test flujo completo | M6 completado | Requiere features funcionando |
| Test multi-usuario | Test flujo | Escenario avanzado |
| Test edge cases | Test flujo | Cobertura de errores |
| Fix conflictos | Test multi-usuario | Solución a problemas detectados |
| Documentación | Fix conflictos | Para usuarios finales |
| Modo offline | — | Independiente |
| Notificaciones | — | Independiente |
| Métricas | Test flujo | Requiere datos existentes |

---

## Métricas de Progreso

| Sprint | Total | Hecho | En Progreso | Pendiente |
|--------|-------|-------|-------------|-----------|
| M7 | 6 | 6 | 0 | 0 |
| P1 | 4 | 0 | 0 | 4 |
| P2 | 3 | 0 | 0 | 3 |
| **Total** | **13** | **6** | **0** | **7** |

---

*Generado con project-planner skill — 2026-07-12*
