---
name: "Luciérnaga App Project"
description: "Use when working with the Luciérnaga app (Flutter + Supabase). Triggers: Luciérnaga, pg_cron, relevo, FCM, flutter_local_notifications, JebsApple. Skip if unrelated to the Luciérnaga prayer/reminder app."
user-invocable: false
---

# Luciérnaga App Project

## Domain
Flutter + Supabase mobile app for prayer scheduling with a "relay" (relevo) architecture. Users check in, and if they miss their window, the next person in the chain is notified server-side.

## Core Concepts
- **Plan 001 — Luciérnaga App**: Project blueprint and sprint planning document
- **Arquitectura del Relevo**: 3-state relay model — server-side trigger via `pg_cron`, no user confirmation needed, no heartbeat polling (avoids interrupting prayer)
- **Flutter**: Cross-platform frontend framework (iOS/Android from single codebase)
- **Supabase**: Backend stack — Auth, Postgres, Realtime, Edge Functions
- **FCM (Firebase Cloud Messaging)**: Push notifications, best-effort delivery
- **flutter_local_notifications**: Exact-time local alarms (reliable fallback for FCM)
- **pg_cron**: Postgres scheduler that fires the relay check without client involvement
- **GitHub repo**: JebsApple/luciernaga-app

## Key Relationships
- pg_cron → triggers → relay evaluation (server-side, no client wake)
- FCM → provides → push notifications (best-effort, may be delayed/killed)
- flutter_local_notifications → provides → exact local alarms (reliable, OS-level)
- Supabase Auth → gates → user identity for relay chain assignment
- Arquitectura del Relevo → depends on → pg_cron for timing + FCM/local for delivery

## Mental Models
- **Relay over polling**: Server decides when to escalate; client doesn't need to be alive
- **Dual notification path**: FCM for reach, local alarms for reliability — belt and suspenders
- **Sprint-based delivery**: Plan 001 → Sprint 0 tracking → incremental feature drops

## When NOT to use
- Skip for general Flutter questions (this is project-specific knowledge)
- Skip for general Supabase usage (only the Luciérnaga-specific patterns apply)
- Skip for other MiNegocio projects (separate stack, separate repo)
