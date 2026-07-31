---
aliases: [pregunta-claude-bloqueantes, scan-tracker-decisiones]
tags: [tl2edit, scan-tracker, decision, preguntar-claude]
created: 2026-07-31
---

# Pregunta a Claude — Bloqueantes de la integración TL2EDIT ↔ Scan Tracker

> Contexto: revisé el plan de conexión con sub-agentes (auditores) y encontraron
> 4 bloqueantes. Acá están explicados sin tecnicismos para decidir.

---

## 1. La app no podrá leer la hoja cuando esté en internet (Render)

La app necesita hablar con el servidor de Google que maneja las hojas (Sheets),
pero el sitio tiene un candado de seguridad (CSP) que solo permite hablar con
ciertos servidores de Google — y el de hojas no está en la lista.

En local funciona porque el candado está apagado en desarrollo, pero en Render
cada lectura de la hoja será bloqueada por el navegador sin explicación.

**Arreglo**: agregar el servidor de hojas a la lista de permitidos (1 línea).
Sin esto la función muere en producción.

---

## 2. El permiso nuevo de Google puede dejar al usuario atrapado en un error

Hoy la app pide permiso para el Drive. Para leer la hoja necesita un permiso
adicional (de hojas). Si alguien ya tenía la sesión con el permiso viejo, el
popup de Google **no aparece solo** — la app sigue con el permiso viejo y al
leer la hoja Google responde "no tienes permiso" (403).

El usuario ve un error críptico sin saber que debe volver a iniciar sesión. Y si
reinicia sesión sin forzar el popup, el permiso nuevo puede que nunca se guarde.

**Arreglo**: detectar ese error específico y mostrar "Necesitas volver a
iniciar sesión para permitir el acceso a hojas", con un botón que abra el popup
correctamente.

---

## 3. Escribir el apodo podría romper la hoja compartida con fórmulas

Al marcar una etapa, la app escribe el apodo en la celda "quién". Google Sheets
interpreta cualquier texto que empiece con `=`, `+`, `-` o `@` como una
**fórmula**, no texto. Un apodo raro tipo `=ALGO(...)` ejecutaría una fórmula
en la hoja compartida y podría afectar datos del equipo.

**Arreglo**: escribir el apodo como texto puro siempre (nunca como fórmula).

---

## 4. El auto-marcado de "Typeo" al exportar no se puede hacer como está pensado

El plan tenía un extra: al exportar un capítulo, ofrecer marcar la etapa
"Typeo" como hecha. El problema: TL2EDIT **no sabe qué capítulo** estás
traduciendo — solo sabe que hay páginas y globos. El capítulo no existe como
dato.

**Opciones**:
- **A)** Agregar un campo "¿qué capítulo es este?" por serie (se escribe a
  mano), y entonces sí se puede ofrecer el auto-marcado.
- **B)** Quitar esa función extra y dejar solo el marcado manual (click en la
  etapa).

---

## Otras cosas importantes (no bloqueantes, a decidir/avisar)

- **Confirmar la hoja antes de marcarla**: al pegar la URL, pedir confirmación
  de que es la hoja correcta antes de poder marcar etapas.
- **No marcar sin apodo**: si la serie no tiene apodo configurado, avisar antes
  de marcar para no dejar la etapa "hecha por nadie".
- **Mostrar "quién" lleva cada etapa**: el tracker original muestra quién está
  en cada etapa; el plan no lo mostraba.
- **Sin sesión iniciada**: el panel debe decir "inicia sesión con Google" en vez
  de mostrarse vacío.
- **Doble click en un chip**: proteger para que no se marque y desmarque de
  golpe.
