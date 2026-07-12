---
tags: [proyecto/luciernaga, tracking, sprint-0]
created: 2026-07-12
updated: 2026-07-12
status: en-progreso
---

# Tracking: Sprint 0 — Luciernaga (Fundación)

> Plan: [[plan-001-luciernaga-app]] (v3, arquitectura de relevo en 3 capas — revisión Opus)
> Repo: [JebsApple/luciernaga-app](https://github.com/JebsApple/luciernaga-app)

## Tareas

- [ ] **Step 0.1 — Spike de confiabilidad OEM** → **MANUAL (usuario)** — requiere 2+ teléfonos reales (Xiaomi/Samsung): probar alarma local exacta + FCM high-priority con pantalla apagada, en Doze, tras 4h sin uso. Base de prueba: scaffolding en `~/proyectos/luciernaga-app` (falta `flutter create .` para completar wrapper Android)
- [ ] **Step 0.2 — Onboarding anti-kill** → pendiente (Sprint 0/1) — pedir `IGNORE_BATTERY_OPTIMIZATIONS` + guía autostart por marca. Depende del spike 0.1
- [ ] **Step 0.3 — FCM HTTP v1 + pg_net + pg_cron** → **MANUAL (usuario)** — requiere crear proyecto Firebase (service account) y proyecto Supabase (habilitar extensiones pg_net/pg_cron en dashboard). Snippet pg_cron de referencia ya incluido en `docs/db/schema.sql`
- [x] **Step 0.4 — Permisos AndroidManifest** → Modelo: Sonnet (subagente scaffolding) → ✅ `android/app/src/main/AndroidManifest.xml` con USE_EXACT_ALARM, SCHEDULE_EXACT_ALARM, RECEIVE_BOOT_COMPLETED, POST_NOTIFICATIONS, WAKE_LOCK + INTERNET/ACCESS_NETWORK_STATE + BootReceiver de flutter_local_notifications
- [x] **Step 0.5 — 4 tablas + RLS** → Modelo: Sonnet (subagente SQL) → ✅ `docs/db/schema.sql` (local + pusheado a GitHub): profiles/turnos/sesiones/checkins, enums, RLS usuario/pastor con `is_pastor()` security definer, índices, query dashboard pastor y snippet pg_cron comentados. **Falta ejecutar contra Supabase real** (Step 0.3)
- [x] **Step 0.6 — Scaffolding Flutter** → Modelo: Sonnet (subagente scaffolding) → ✅ `~/proyectos/luciernaga-app`: pubspec.yaml (supabase_flutter ^2.8.0, firebase_core ^3.8.0, firebase_messaging ^15.1.6, flutter_local_notifications ^18.0.1, timezone ^0.9.4), lib/features/{auth,sesiones,turnos,relevo,heartbeat,pastores}, lib/core/{notifications,supabase,fcm}, README, .gitignore. **Pendiente:** instalar Flutter SDK y correr `flutter create .` para generar wrapper Android completo (gradle, MainActivity)
- [x] **Step 0.7 — CI básico (build Flutter, lint)** → Modelo: Sonnet (subagente) → ✅ `.github/workflows/flutter-ci.yml` (flutter pub get + analyze + test en runner de GitHub, no requiere SDK local; el paso de test se auto-activa cuando exista el primer `*_test.dart`) + `analysis_options.yaml` con flutter_lints. Se valida en el primer push a GitHub
- [x] **Step 0.8 — Wireframes (5-6 pantallas)** → Modelo: Sonnet (subagente) → ✅ `docs/wireframes.md`: 6 pantallas (login/registro, principal con 3 variantes de estado de sesión, sheet "Entrando" con duración + switch relevo, vista pastores, historial, onboarding anti-kill) + tokens de diseño dark/ámbar + mapa de navegación + checklist UI para Sprint 1

## Delegación

| Subagente | Modelo | Tarea | Resultado |
|-----------|--------|-------|-----------|
| a746ea0a71255b25e | Sonnet | Scaffolding Flutter + AndroidManifest (Steps 0.4, 0.6) | ✅ completado |
| ada0c7652657beadb | Sonnet | schema.sql: 4 tablas + RLS + índices (Step 0.5) | ✅ completado |

## Acciones manuales del usuario (bloqueantes)

1. **Spike OEM (Step 0.1)** — probar en teléfonos físicos Xiaomi/Samsung; es la validación GO/NO-GO de la arquitectura
2. Instalar Flutter SDK y correr `flutter create .` en `~/proyectos/luciernaga-app` + `flutter pub get`
3. Crear proyecto Supabase → ejecutar `docs/db/schema.sql` → habilitar pg_net y pg_cron
4. Crear proyecto Firebase (solo FCM) → service account para FCM HTTP v1 → `google-services.json` (NO committear, ya está en .gitignore)
5. ~~`git init` + primer commit del scaffolding local~~ → ✅ hecho (2026-07-12): repo local inicializado sobre `origin/main`, 3 commits locales (`3520176` scaffolding, `507f9b4` wireframes, `6c8c0d7` CI). **Falta `git push origin main`** (decisión del usuario)

## Commits en GitHub (main)

- `c4e8819` — docs: arquitectura de relevo en 3 capas, modelo de datos, Sprint 0 accionable — revisión Opus
- schema.sql — feat: migración inicial 4 tablas + RLS

## Commits locales pendientes de push (main, 2026-07-12)

- `3520176` — chore: scaffolding Flutter inicial (pubspec, lib, AndroidManifest)
- `507f9b4` — docs: wireframes 6 pantallas core (Step 0.8)
- `6c8c0d7` — ci: workflow flutter-ci.yml + analysis_options.yaml (Step 0.7)
