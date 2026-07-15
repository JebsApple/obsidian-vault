---
kanban-plugin: board
tags: [kanban, tracking, proyecto/servicio-pc]
created: 2026-07-14
status: pendiente
---

# Servicio Limpieza PC — Steps

%% kanban:settings
{"kanban-plugin":"board","list-collapse":[false,false,false]}
%%

## Pendiente
- [ ] 📝 1.1: audit-win.ps1 → Sonnet → checks solo-lectura (disco, inicio, Defender, updates, eventos, HW)
- [ ] 📝 1.2: Probar audit-win.ps1 en VM/PC Windows → manual
- [ ] 📝 2.1: Armar pendrive → manual → playbook + scripts + opencode-portable + herramientas offline
- [ ] 📝 3.1: API key límite de gasto bajo → manual
- [ ] 📝 3.2: Publicar playbook en repo GitHub → Haiku → solo carpeta servicio-limpieza-pc
- [ ] 📝 4.1: Piloto con primer vecino → manual → medir tiempos, definir precios

## En Progreso


## Hecho ✅

---

## Decisiones

- **Linux**: solo Mint/Zorin, solo si encaja (criterios en [[plan-servicio]]) — no evangelizar
- **opencode en terreno**: requiere internet + key limitada; fallback = checklist manual
