---
tags: [proyecto/minegocio, sprint-3, plan, hu05]
---

# S3-HU05: Cierre y QA — Cobertura Rúbrica

> **UX:** 1 | **Design:** 1 | **Front:** 6 | **Back:** 6 | **DevOps:** 10 | **Total:** 24

> **Como** equipo, **quiero** cubrir los puntos faltantes de la rúbrica y preparar la presentación final **para** maximizar la nota del Sprint 3.

**Dependencias:** HU01-T03 (Docker/Jenkins back), HU01-T04 (SonarQube), HU02-T03 (Dashboard con KPIs)

---

## Tareas

### S3-HU05-T01: Frontend CI/CD — Jenkinsfile + build + deploy (Nicolás) — 5 jul → 8 jul `[devops]` `[frontend]`
**Peso rúbrica:** ~15 pts (DevOps frontend: pipeline + compilación + automatización)

Crear `Jenkinsfile` en la raíz del frontend con stages:
- **Checkout:** `checkout scm`
- **Build:** `npm ci && npm run build`
- **Deploy:** copiar `dist/*` al servidor de producción (`/var/www/prod/frontend/`) vía SSH

Configurar webhook en Gitea → Jenkins para el repo frontend. El pipeline se dispara automáticamente al hacer push a `main`. Archivos: `Jenkinsfile` (raíz frontend).

### S3-HU05-T02: Validaciones + mensajes de error globales frontend (Victor) — 5 jul → 8 jul `[frontend]`
**Peso rúbrica:** 6 pts (validaciones 3→2 + mensajes error 3→2 + navegación 3→2)

Revisar **todas** las páginas del frontend y asegurar que:
- Todo formulario tenga validaciones visibles antes de enviar (campos requeridos marcados, formato email, longitud password, etc.)
- Toda llamada API tenga manejo de error con mensaje visible al usuario (no console.log, no alert() genérico)
- Botones de acción tengan texto descriptivo (no solo iconos sin label)
- Mensajes de error en español y específicos ("El email ya está registrado" y no "Error 500")

### S3-HU05-T03: Usuario BD dedicado (Ignacio) — 5 jul → 7 jul `[database]` `[devops]`
**Peso rúbrica:** 3 pts (aislamiento entornos 3→2, seguridad)

Crear un usuario de PostgreSQL dedicado para la aplicación en vez de usar `postgres` directo:
```sql
CREATE USER minegocio WITH PASSWORD '...';
GRANT CONNECT ON DATABASE minegocio TO minegocio;
GRANT USAGE, SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO minegocio;
```
Actualizar variables de entorno en dev y Jenkins. Documentar en README.

### S3-HU05-T04: Usuario Jenkins con permisos mínimos (Nicolás) — 5 jul → 8 jul `[devops]`
**Peso rúbrica:** 2 pts (pipeline front 5→4, pipeline back 5→4)

Crear un usuario `jenkins-deploy` en el servidor de producción con permisos restringidos:
- Solo acceso SSH por clave (no password)
- Solo puede ejecutar `docker pull/run` y copiar archivos al directorio de la app
- No tiene sudo, no puede modificar otros directorios

Actualizar los Jenkinsfiles para usar este usuario en vez de `icin`.

### S3-HU05-T05: Preparar presentación final (Todo el equipo) — 8 jul → 10 jul `[presentacion]`
**Peso rúbrica:** 5 pts (presentación 18→13)

Coordinar y ensayar la presentación del Sprint 3. Cada integrante prepara su parte:
- **Victor:** HU02 (rediseño frontend) + limpieza código
- **Ignacio:** HU03 (dashboard ventas) + endpoints documentados
- **Gabriel:** HU01 seguridad (bcrypt, JWT) + reportes + logs
- **Nicolás:** HU04 (gestión usuarios) + CI/CD + SonarQube

Preparar demo en vivo de cada funcionalidad. Tener el entorno dev listo y funcionando.

---

## Tabla cronológica

| Tarea | Asignado | Fechas | Prioridad |
|-------|----------|--------|-----------|
| HU05-T03: Usuario BD dedicado | Ignacio | 5 jul → 7 jul | 🟡 Alta |
| HU05-T01: Frontend CI/CD | Nicolás | 5 jul → 8 jul | 🔴 Crítica |
| HU05-T02: Validaciones globales | Victor | 5 jul → 8 jul | 🟡 Alta |
| HU05-T04: Usuario Jenkins mínimos | Nicolás | 5 jul → 8 jul | 🟢 Media |
| HU05-T05: Preparar presentación | Todos | 8 jul → 10 jul | 🔴 Crítica |

---

## Enlaces

- [[Sprint 3 - Plan de Trabajo]]
- [[Rúbrica Evaluación]]
