---
tags: [iglesia, oracion, app-mobile, plan, luciernaga]
created: 2026-07-12
updated: 2026-07-12
status: confirmed
---

# Plan 001 — Luciernaga App

> **Estado:** Confirmado v4 — relevo rediseñado a 3 estados (entrando/relevo/saliendo), sin heartbeat periódico  
> **Fecha:** 2026-07-12  
> **Skill:** plan-interview  
> **Depth:** Deep (multi-feature, multi-sprint, two user roles)  
> **Repo:** [JebsApple/luciernaga-app](https://github.com/JebsApple/luciernaga-app)

---

## Problema

~20 personas de una iglesia coordinan sesiones de intercesión nocturna de relevo por WhatsApp. Se orna 1-2h+ diario, típicamente en altas horas de la noche ("darle las primeras horas del día a Dios"). Las problematicas principales:

- No hay registro confiable de quién está orando
- Algunos se duermen sin avisar → se rompe la cadena de relevo
- Los pastores no tienen visibilidad sobre quién está activo
- WhatsApp es un workaround, no una herramienta diseñada para esto

## Entrevista — Respuestas

### Dominio 1: Restricciones Tecnicas
| # | Pregunta | Respuesta |
|---|----------|-----------|
| 8 | Plataforma | **Android first**, iOS port futuro |
| 1 | Escala | 20 base → 40 escalabilidad |
| 7 | Nivel tecnico usuarios | Variable — debe ser ultra-intuitiva |
| 9 | Auth | Obligatoria, nombre + teléfono |

### Dominio 2: Limites del Alcance
| # | Pregunta | Respuesta |
|---|----------|-----------|
| 2 | Frecuencia | Diaria, 1-2h+ nocturno |
| 3 | Datos actuales | Solo "entrando"/"saliendo" |
| 5 | Alarmas | Inicio + fin (fin desactivable) + relevo automático |
| 11 | Out of scope | No chat, no redes sociales, no sobrecarga informativa |

### Dominio 3: Tolerancia al Riesgo
| # | Pregunta | Respuesta |
|---|----------|-----------|
| 10 | MVP para dejar WhatsApp | Sentimiento de compañía + stats + rachas + alarmas + registro pastores |
| 6 | Playlist | Local/YouTube/Spotify — **recortado del MVP**, P2 |

### Dominio 4: Criterios de Exito
| # | Pregunta | Respuesta |
|---|----------|-----------|
| 12 | Metrica | Curva de aprendizaje baja, funcional después de 3 sprints |
| Branding | Enfoque | Calidez, compañía, intimidad con Dios, sin ruido |

---

## Branding — Luciernaga

### Nombre
**Luciernaga** (tilde en UI: "Luciérnaga")

### Por que funciona
- Vuela de noche → la app se usa de noche
- Produce luz en la oscuridad → metáfora de oración en horas de quietud
- Diminutivo y cálido → no es intimidante
- Funciona en español e inglés
- Disponible en app stores (no es genérica)

### Direccion visual
- **Fondo oscuro** nativo (modo nocturno permanente)
- **Acentos en ambar/dorado cálido** (luz de luciérnaga)
- **Minimalismo:** poco texto, iconos grandes, gestos simples
- **Animación sutil:** luciérnagas que aparecen cuando hay gente orando
- **Tipografia:** sans-serif redondeada (amigable, no corporativa)

### Elemento motivacional (P1)
- "Estrellas encendidas" o "luciérnagas activas" = personas orando ahora
- El usuario ve cuántas luciérnagas hay → siente que no está solo
- Cada sesión completada = luciérnaga que se "enciende" en su perfil

---

## Arquitectura de Features — Priorizado

### P0 — MVP (Sprints 1-3)
| Feature | Descripcion |
|---------|-------------|
| Auth | Registro/login nombre + teléfono (Supabase Auth) |
| Sesion de oracion — 3 estados | **Entrando** (inicia, define duración opcional), **Relevo** (al cumplirse duración, avisa automático al siguiente sin interrumpir al usuario actual), **Saliendo** (termina manual, en cualquier momento) — ver Arquitectura del Relevo |
| Switch auto-finalizar en relevo | Por sesión: relevo auto-finaliza la sesión, o la deja activa hasta "saliendo" manual — decide el usuario |
| Backup por turno | `backup_usuario_id` en cada turno — quién cubre si el titular no responde (**P0**) |
| Vista de pastores | Dashboard: quién ora, cuándo, duración, estado (activa/en_relevo) — sin compartir con otros usuarios |
| Estado visual | Indicador simple: activo / en_relevo / inactivo |
| Onboarding anti-kill | Exclusión de optimización de batería + guía autostart por marca (MIUI/Huawei/Samsung) — mejora entrega de push, aunque el relevo ya no depende solo de eso |

### P1 — Post-MVP (Sprint 4+)
| Feature | Descripcion |
|---------|-------------|
| Estadisticas personales | Horas oradas, sesiones, promedio diario |
| Rachas | Dias consecutivos de oracion |
| Notificaciones motivacionales | Sugerencias de razones para orar |
| Elemento visual | Estrellas/luciernagas encendidas como motivacion |

### P2 — Futuro
| Feature | Descripcion |
|---------|-------------|
| Playlist | Local, YouTube, Spotify (configurable por usuario) |
| Espacio personal | Detalles TBD |
| Comunidad multi-iglesia | Foro de peticiones anonimas |

---

## Stack Tecnico (Confirmado)

| Capa | Tecnologia | Razon |
|------|-----------|-------|
| Frontend | **Flutter** | Cross-platform, Android first + path a iOS futuro sin rewrite |
| Auth | **Supabase Auth** | Nombre + telefono, RLS por rol (usuario/pastor) |
| Database | **Supabase (Postgres) + Realtime** | SQL real, sin vendor lock-in, subscripciones realtime para estado de sesion |
| Notificaciones locales (alarmas inicio/fin) | **flutter_local_notifications** | Alarmas programadas en el dispositivo, no requieren servidor |
| Push (relevo automatico, app en background/cerrada) | **Firebase Cloud Messaging (FCM)** | Supabase no tiene push nativo — FCM se usa solo para el trigger de relevo, disparado por un Supabase Edge Function o Postgres trigger |
| Backend logic | **Supabase Edge Functions** | Logica de relevo, stats, triggers hacia FCM |

**Nota de arquitectura:** Supabase cubre datos/auth/realtime; FCM se mantiene como pieza minima solo para push cuando la app esta en background (el resto de alarmas son locales). **FCM es best-effort** — la confiabilidad real del relevo viene de la alarma local exacta + pg_cron (ver siguiente sección).

---

## Arquitectura del Relevo — Modelo de 3 Estados (v4, 2026-07-12)

> **Decisión del usuario:** el heartbeat/check-in periódico (Capa 3 de la revisión Opus v3) se descarta — interrumpe la oración. Se reemplaza por un modelo de 3 estados de aviso, más simple y sin ruido, que igual resuelve el caso de alguien dormido a mitad de turno.

### Entrando
Usuario presiona "Entrando" → `sesiones.estado = 'activa'`, `inicio_at = now()`. Opcionalmente define cuánto tiempo piensa orar → se guarda como `duracion_fin_at`. Si no define duración, la sesión queda sin relevo automático (solo manual).

### Relevo
Al cumplirse `duracion_fin_at`, el sistema avisa automáticamente al siguiente en la cadena (`turnos.orden + 1`, misma fecha) vía FCM. **No asume que el usuario actual dejó de orar** — solo garantiza que la cadena no se corta. Disparo server-side vía `pg_cron` (corre cada 1 min, revisa sesiones activas con `duracion_fin_at <= now()` y `relevo_disparado_at` nulo), no depende del dispositivo del usuario actual ni de que su teléfono esté despierto/con batería — resuelve el caso de dormirse sin necesidad de pings periódicos.

Switch `auto_finalizar_en_relevo` (por sesión, decide el usuario):
- **true** → al dispararse el relevo, la sesión pasa directo a `finalizada`
- **false** (default) → la sesión queda en `en_relevo`: el siguiente ya está avisado y puede empezar, pero el usuario actual sigue apareciendo como orando hasta que salga manualmente

### Saliendo
Usuario presiona "Saliendo" en cualquier momento → `estado = 'finalizada'`, `fin_at = now()`. Válido haya habido relevo o no.

### Por qué resuelve el caso de "se durmió" sin heartbeat
El relevo se dispara por tiempo, no por confirmación del usuario. Si alguien se duerme a mitad de su turno, la cadena igual continúa a la hora que esa misma persona predefinió — sin necesidad de que su teléfono reporte nada, sin interrumpir a nadie que sigue orando con notificaciones de "¿sigues despierto?".

### Notificación de inicio de turno (se mantiene de la revisión Opus)
Alarma local exacta (`setExactAndAllowWhileIdle`, atraviesa Doze) programada al asignar el turno, como aviso primario de "te toca" — no depende de red. FCM sigue como canal adicional best-effort. Ver Stack Técnico.

### Cambios concretos al plan (vs v3)
1. Se elimina la tabla `checkins` y el mecanismo de heartbeat/check-in periódico — decisión de producto del usuario (interrumpe la oración)
2. `sesiones` gana `duracion_fin_at`, `auto_finalizar_en_relevo`, `relevo_disparado_at`, y el estado `en_relevo`
3. El relevo se dispara **una sola vez** por sesión, server-side, sin pings repetidos
4. `backup_usuario_id` en turnos se mantiene **P0** (cubre ausencia total, no solo dormirse)
5. Onboarding anti-kill baja de crítico-bloqueante a mejora — el relevo ya no depende de que el dispositivo del usuario dormido esté despierto

---

## Modelo de Datos (Postgres, 3 tablas)

```sql
profiles(id, nombre, telefono, rol[usuario|pastor], fcm_token, updated_at)
turnos(id, fecha, hora_inicio, hora_fin, usuario_id, backup_usuario_id NULL, orden,
       estado[programado|en_curso|completado|ausente|relevado])
sesiones(id, turno_id NULL, usuario_id, inicio_at,
         duracion_fin_at NULL, auto_finalizar_en_relevo bool default false,
         relevo_disparado_at NULL, fin_at NULL,
         estado[activa|en_relevo|finalizada|interrumpida])
```

Ver `docs/db/schema.sql` en el repo para el DDL completo (RLS, índices, función `is_pastor()`, referencia comentada de la query de pastores y del job `pg_cron`).

**RLS:**
- Usuario ve solo lo suyo (`usuario_id = auth.uid()`)
- Pastor tiene SELECT sobre todo vía policy que chequea `profiles.rol = 'pastor'`

---

## Knowledge Audit

| Knowledge | Source | Confidence |
|-----------|--------|------------|
| Android (Kotlin/Compose) | Training data | High |
| Flutter | Training data | High |
| Supabase (Auth, Postgres, Realtime, Edge Functions) | Training data | High |
| Firebase Cloud Messaging (push only) | Training data | High |
| flutter_local_notifications / alarmas locales | Training data | High |
| Spotify API integration | **No reachable** | Unknown |
| YouTube embed API | Training data | Medium |
| UI/UX para usuarios no-tecnicos | Training data | High |
| Arquitectura de relevo nocturno | Context del usuario | High |

### Bloqueos identificados
- **Playlist recortado** del MVP — evita complejidad de APIs de Spotify/YouTube
- **Supabase + FCM hibrido** — validar en Sprint 0 que Edge Function puede disparar FCM push de forma confiable (unico punto no 100% probado)

---

## Sprint Plan

### Sprint 0 — Fundacion (1 semana) — Accionable (revisión Opus)
1. [ ] **Spike de confiabilidad (PRIMERO, antes de cualquier feature):** app mínima que programe alarma local exacta + reciba FCM high-priority; probar en 2+ teléfonos reales de OEM agresivo (Xiaomi/Samsung), con pantalla apagada, en Doze, tras 4h sin uso
2. [ ] **Onboarding anti-kill:** pedir `IGNORE_BATTERY_OPTIMIZATIONS` + guía autostart por marca
3. [ ] **FCM HTTP v1** (service account) en Edge Function + probar `pg_net` desde trigger Postgres + confirmar `pg_cron` habilitado
4. [ ] **Permisos AndroidManifest:** `USE_EXACT_ALARM`/`SCHEDULE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED`, `POST_NOTIFICATIONS`, `WAKE_LOCK`
5. [ ] **Crear 4 tablas + políticas RLS** + validar query del dashboard de pastor
6. [ ] Setup proyecto Flutter + estructura de carpetas
7. [ ] CI basico (build Flutter, lint)
8. [ ] Wireframes de pantallas principales (5-6 pantallas max)

### Sprint 1 — Auth + Sesiones (2 semanas)
- [ ] Auth: registro con nombre + telefono
- [ ] Auth: login
- [ ] Pantalla principal: estado de la sesion actual
- [ ] Registrar entrada de oracion (boton "Estoy orando")
- [ ] Registrar salida de oracion (boton "Terminé")
- [ ] Historial basico de sesiones propias

### Sprint 2 — Relevo (2 semanas)
- [ ] Configurar alarma local de inicio de turno (aviso "te toca")
- [ ] UI de "Entrando" con duración opcional
- [ ] Switch "auto-finalizar en relevo" (activable por sesión)
- [ ] Job `pg_cron` de disparo de relevo + Edge Function → FCM al siguiente en la cadena
- [ ] UI de "Saliendo" manual, disponible en cualquier estado
- [ ] Persistencia y visualización de estado de sesion (activa / en_relevo / finalizada)

### Sprint 3 — Vista Pastores + Pulido (1 semana)
- [ ] Dashboard de pastores: lista de who's praying
- [ ] Vista de historial agregado (quién oró hoy, cuánto)
- [ ] Testing con usuarios reales (5-10 personas)
- [ ] Pulido de UX, errores edge cases
- [ ] **ENTREGABLE MVP**

### Sprint 4+ — P1 Features
- Estadisticas personales
- Sistema de rachas
- Notificaciones motivacionales
- Elemento visual (estrellas/luciernagas)

---

## Decisiones Resueltas (2026-07-12)
1. **Frontend:** Flutter
2. **Backend:** Supabase (Postgres + Auth + Realtime) + FCM solo para push de relevo
3. **Nombre final:** Luciernaga — confirmado
4. **Relevo — modelo de 3 estados (v4):** entrando / relevo (automático, una vez, por tiempo) / saliendo (manual) — reemplaza el heartbeat periódico de la revisión Opus v3, que el usuario descartó por interrumpir la oración. `backup_usuario_id` se mantiene P0

---

## Criterio de Aprobacion
- [x] Entrevista completada con todas las respuestas
- [x] Knowledge audit sin bloqueos criticos
- [x] Sprint plan con dependencias claras
- [x] Out of scope definido explicitamente
- [x] Usuario aprueba el plan
- [x] Stack tecnico confirmado (Flutter + Supabase + FCM hibrido)

---

*Generado con plan-interview skill — 2026-07-12*  
*Actualizado — decisiones de stack resueltas — 2026-07-12*  
*Actualizado v3 — arquitectura de relevo en 3 capas, modelo de datos y Sprint 0 accionable (revisión Opus) — 2026-07-12*  
*Actualizado v4 — relevo simplificado a 3 estados (entrando/relevo/saliendo), sin heartbeat, decisión de producto del usuario — 2026-07-12*
