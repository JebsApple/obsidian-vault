---
kanban-plugin: board
tags: [kanban, progreso]
created: 2026-07-11
status: en-progreso
---

# Scan Tracker — Progreso

%% kanban:settings
{"kanban-plugin":"board","list-collapse":[false,false,false]}
%%

## Pendiente
- [ ] 📝 M7: Testing con sheet real (ver sprint-0.md — 13 steps, incluye edge cases)
- [ ] 📝 M8.3/8.4: Drive modifiedTime pre-check + push valida conflicto
- [ ] 📝 M9: Multi-hoja robusto (comillas A1, sheet 2, carpetas separadas)

## En Progreso


## Hecho ✅
- [x] M1: Google Cloud setup (proyecto, OAuth, credenciales) ✅ 2026-07-11
- [x] M2: Scaffold plugin (manifest, esbuild, tsconfig, build limpio) ✅
- [x] M3: OAuth2 loopback flow en auth.ts ✅
- [x] M4: Sheets API read (Drive picker + Sheets read) ✅
- [x] M5: Push to Sheets (pushNote + comando) ✅
- [x] M6: Auto-sync por intervalo + settings tab ✅
- [x] M0: Preflight — build + refresh_token verificados ✅ 2026-07-12
- [x] G1: Fix rango sin nombre de hoja (bug bloqueante, corrupción silenciosa) ✅ 2026-07-12
- [x] G2: Fix pull pisa ediciones locales sin avisar (sync_baseline hash) ✅ 2026-07-12
- [x] M8 (base): conflict detection por contenido implementado junto con G2 ✅ 2026-07-12
