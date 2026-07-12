---
tags:
  - referencia/claude
  - referencia/fable
  - referencia/skills
fuente: https://www.tododeia.com/community/fragmento-de-fable
fecha: 2026-07-12
---

# Fragmento de Fable: 5 manuales para que su forma de trabajar se quede en tu proyecto

Fable 5 llegó a Claude Code de regalo por una ventana corta. La jugada es pedirle un manual de cómo él haría las cosas en tu proyecto, para que cuando se vaya, Opus y Sonnet sigan su paso a paso.

## Los 5 manuales + el bonus

| # | Manual | Qué hace |
|---|--------|----------|
| 1 | **Chequeo de seguridad** | Auditoría con hallazgos archivados, línea y cómo se explota — evidencia, no opiniones |
| 2 | **El arranque** | Cómo empieza Fable un proyecto para que no se caiga en un mes: día 1 no negociable y cero sobre-ingeniería |
| 3 | **Fable Plan** | Las preguntas que Fable hace antes de construir — para que Opus y Sonnet también las hagan |
| 4 | **Abogado del diablo** | Steelman, ataque con cuatro preguntas, riesgos rankeados y veredicto. Sin "qué buena idea" |
| 5 | **El fixer** | Arreglar con prueba en mano — no aceptar un "ya quedó" sin evidencia |
| Bonus | **Crea el tuyo** | Fable te entrevista — máximo 5 preguntas — y escribe el manual que solo tú necesitas |

## Preparación

1. Abre Claude Code en el proyecto donde quieres los manuales
2. Verifica que el modelo activo sea Fable 5: `/model`
3. Un manual por conversación: pega un prompt, deja que explore y escriba, revisa, abre chat nuevo
4. Cada prompt termina pidiendo una demostración — no te la saltes

Si Fable ya no aparece en `/model`, los prompts funcionan con Opus 4.8.

---

## Manual 1: Chequeo de seguridad

### Prompt adaptativo (tu proyecto)

```
Piensa profundo. Quiero quedarme con un manual tuyo antes de que cambies de
modelo.

1. Explora este proyecto primero: el stack, la estructura, cómo se corre y
   qué es lo delicado AQUÍ (logins, pagos, datos de usuarios, llaves de API —
   lo que aplique en este código, no en teoría).

2. Con eso, crea una skill en .claude/skills/chequeo-seguridad/SKILL.md
   (frontmatter: name igual a la carpeta, y una description que diga cuándo
   usarla — sus disparadores — para que se cargue sola) que le enseñe a
   cualquier modelo futuro a hacer el chequeo de seguridad de ESTE proyecto
   exactamente como lo harías tú:
   - El orden en que revisarías: secretos expuestos o committeados,
     validación de lo que entra por cada formulario o endpoint, quién puede
     tocar qué dato (no solo quién puede entrar), inyección, datos sensibles
     en logs o respuestas, y dependencias con hoyos conocidos.
   - La regla de oro: cada hallazgo con su archivo y línea, su severidad y
     cómo se explota en una frase. Si no se puede decir cómo se explota, es
     opinión, no hallazgo.
   - Antes de reportar, intentar tumbar cada hallazgo propio; solo
     sobreviven los que resisten.
   - El formato de salida: hallazgos por severidad, el arreglo concreto de
     cada uno, y la lista honesta de lo que NO se revisó.

3. Sé concreto: comandos reales de este proyecto, archivos reales, rutas
   reales. Nada genérico. Si algo depende de mi contexto y no lo sabes,
   pregúntame antes de escribirlo.

4. Al final dime cómo invoco la skill y hazme una demostración corta de que
   funciona.
```

### Instalador general (cualquier proyecto)

```
Crea una skill global en ~/.claude/skills/fable-chequeo-seguridad/SKILL.md
con EXACTAMENTE el contenido de abajo, tal cual, sin resumirlo ni cambiarlo.
Cuando la termines de crear, confírmame la ruta del archivo y dime cómo la
invoco la próxima vez. El contenido del archivo empieza en la línea que
sigue y llega hasta el final de este mensaje:
```

Contenido del SKILL.md:

```markdown
---
name: fable-chequeo-seguridad
description: Chequeo de seguridad al estilo Fable 5. Usar cuando pidan revisar la seguridad del proyecto, antes de publicar, o después de agregar logins, pagos o manejo de datos de usuarios.
---

# Chequeo de seguridad — como lo haría Fable 5

Eres el auditor, no el porrista. Tu trabajo es encontrar lo que sí se puede
explotar, probarlo y explicar cómo arreglarlo — no llenar una lista de
recomendaciones genéricas.

## Paso 0 — Mapea la superficie
Antes de buscar problemas, entiende qué está expuesto:
- Rutas y endpoints que reciben datos de afuera.
- Todo lugar donde entra texto del usuario (formularios, APIs, webhooks).
- Dónde viven los secretos (variables de entorno, archivos de config).
- Qué dependencias externas carga el proyecto.

## El orden de revisión (no lo cambies)
1. Secretos: llaves o contraseñas escritas en el código o committeadas en
   git — revisa también el historial, no solo el estado actual.
2. Validación de entrada: por cada endpoint o formulario, ¿qué pasa si llega
   algo inesperado, enorme o malicioso?
3. Autorización, no solo autenticación: no basta con saber quién entró.
   ¿Puede el usuario A leer o cambiar los datos del usuario B con solo
   cambiar un id en la URL o en la petición?
4. Inyección: SQL, comandos del sistema, HTML/JS (XSS) — todo lugar donde
   texto del usuario termina dentro de una consulta, un comando o la página.
5. Fugas: datos sensibles en logs, en mensajes de error, o respuestas de API
   que devuelven más campos de los necesarios.
6. Dependencias: paquetes con vulnerabilidades conocidas (corre el audit del
   gestor de paquetes que use el proyecto).

## Las reglas de Fable
- Cada hallazgo lleva: archivo y línea, severidad (crítico / alto / medio /
  bajo) y cómo se explota, en una frase. Si no puedes decir cómo se explota,
  es una opinión, no un hallazgo — no va al reporte.
- Verificación adversarial: antes de entregar, intenta refutar cada hallazgo
  tuyo. El que sobrevive se reporta; el que no, se descarta.
- Nada de relleno: cero genéricos ("considera usar HTTPS") que no salgan del
  código real de este proyecto.

## Formato de salida
1. Hallazgos ordenados por severidad, cada uno con evidencia y explotación.
2. El arreglo concreto de cada uno — el cambio exacto, no "mejorar la
   validación".
3. Lo que NO se revisó y por qué: la honestidad sobre la cobertura vale
   tanto como los hallazgos.
```

---

## Manual 2: El arranque

### Prompt adaptativo

```
Piensa profundo. Quiero quedarme con un manual tuyo antes de que cambies de
modelo.

1. Explora este proyecto y haz una autopsia honesta de su arranque: ¿qué
   decisiones tempranas ayudaron? ¿Qué faltó al inicio y dolió después
   (deploy tardío, sin CLAUDE.md, estructura confusa, alcance que creció
   solo)? Dímelo directo, sin suavizar.

2. Con eso, crea una skill en .claude/skills/arranque/SKILL.md (frontmatter:
   name igual a la carpeta, y una description que diga cuándo usarla — sus
   disparadores — para que se cargue sola) que le enseñe a cualquier modelo
   futuro a arrancar mi PRÓXIMO proyecto exactamente como lo harías tú:
   - Antes de escribir código: qué problema resuelve, quién lo usa, y cuál
     es la primera cosa visible que demuestra que funciona.
   - Stack mínimo y aburrido; una decisión reversible vale más que la
     "perfecta". Anotar el porqué de cada elección.
   - El día 1 no negociable: git con primer commit, un CLAUDE.md con
     comandos y convenciones, estructura explicada y deploy temprano aunque
     sea un "hola".
   - Cero sobre-ingeniería: nada de capas para problemas que todavía no
     existen.
   - Un checklist de salida del arranque, incluyendo los puntos que salen
     de las cicatrices de ESTE proyecto.

3. Sé concreto: si mi stack de siempre es el de este proyecto, el manual lo
   nombra con comandos reales. Si algo no lo sabes, pregúntame antes de
   escribirlo.

4. Al final dime cómo invoco la skill y demuéstrame en tres líneas cómo
   arrancaría mi próximo proyecto siguiéndola.
```

### Instalador general

```
Crea una skill global en ~/.claude/skills/fable-arranque/SKILL.md
con EXACTAMENTE el contenido de abajo, tal cual, sin resumirlo ni cambiarlo.
Cuando la termines de crear, confírmame la ruta del archivo y dime cómo la
invoco la próxima vez. El contenido del archivo empieza en la línea que
sigue y llega hasta el final de este mensaje:
```

Contenido del SKILL.md:

```markdown
---
name: fable-arranque
description: Arranque de proyectos al estilo Fable 5. Usar cuando se empiece un proyecto nuevo desde cero o cuando pidan ayuda para estructurar los primeros días de una idea.
---

# El arranque — como Fable 5 empieza un proyecto que no se caiga en un mes

## Antes de escribir una sola línea
Responde (o pregúntale al dueño) estas tres cosas:
1. ¿Qué problema resuelve esto y para quién?
2. ¿Cuál es la PRIMERA cosa visible que demuestra que funciona? Esa es la
   meta de la semana uno — no el producto completo.
3. ¿Qué NO va a hacer la versión uno? Escríbelo: el alcance que no se
   escribe, crece solo.

## Decisiones de stack
- Elige lo mínimo y lo aburrido: tecnología probada que el dueño (o el
  modelo que lo acompañe) pueda mantener — no la novedad del mes.
- Una decisión reversible hoy vale más que la decisión "perfecta" la próxima
  semana. Si dudas entre dos opciones parecidas, toma la más fácil de
  deshacer y anota por qué.

## El día 1 no es negociable
- git init y un primer commit que corre.
- Un CLAUDE.md desde el inicio: cómo se corre el proyecto, cómo se prueba y
  las convenciones a seguir. Es el manual del proyecto para cualquier modelo
  que llegue después.
- Estructura de carpetas explicada: una línea por carpeta.
- Deploy temprano: publica un "hola" el primer día. Publicar tarde es donde
  los proyectos mueren.

## Las reglas de Fable
- Cero sobre-ingeniería: nada de capas, patrones ni abstracciones para
  problemas que todavía no existen. Cada abstracción se gana su lugar
  apareciendo tres veces.
- Verticales, no horizontales: un flujo completo funcionando (aunque feo)
  antes que diez piezas perfectas que no se conectan.
- Cada sesión de trabajo termina con el proyecto corriendo y committeado.

## Checklist de salida del arranque
- Repo con historial limpio y primer deploy en línea.
- CLAUDE.md con comandos, convenciones y estructura.
- Un flujo de punta a punta funcionando.
- La lista de lo que NO hace la v1, escrita.
```

---

## Manual 3: Fable Plan

### Prompt adaptativo

```
Piensa profundo. Quiero quedarme con un manual tuyo antes de que cambies de
modelo.

1. Explora este proyecto: cómo está organizado, qué convenciones sigue, cómo
   se corre y cómo se verifica que un cambio quedó bien (build, pruebas, ojo
   humano — lo que exista aquí de verdad).

2. Con eso, crea una skill en .claude/skills/fable-plan/SKILL.md
   (frontmatter: name igual a la carpeta, y una description que diga cuándo
   usarla — sus disparadores — para que se cargue sola) que le enseñe a
   cualquier modelo futuro a planear una función nueva en ESTE proyecto
   exactamente como lo harías tú:
   - Nunca proponer sin explorar: qué archivos leer primero según la zona
     del proyecto que se va a tocar.
   - Las preguntas obligatorias: ¿cuál es el problema real detrás del
     pedido? ¿Qué es lo más pequeño que lo resuelve? ¿Qué se rompe con este
     cambio AQUÍ? ¿Qué casos límite aplican? ¿Cómo verificamos que quedó —
     con los comandos reales de este proyecto? ¿Qué NO vamos a hacer y por
     qué?
   - Plan en pasos pequeños y reversibles, cada uno con su verificación.
   - La regla: si una pregunta puede cambiar el plan, se hace ANTES de
     escribirlo; si no lo cambia, se decide y se anota la decisión.

3. Sé concreto: comandos, rutas y convenciones reales de este proyecto.
   Nada genérico. Pregúntame lo que no sepas antes de escribirlo.

4. Al final dime cómo invoco la skill y pruébala planeando una mejora
   chiquita de este proyecto, para ver el formato en acción.
```

### Instalador general

```
Crea una skill global en ~/.claude/skills/fable-plan/SKILL.md
con EXACTAMENTE el contenido de abajo, tal cual, sin resumirlo ni cambiarlo.
Cuando la termines de crear, confírmame la ruta del archivo y dime cómo la
invoco la próxima vez. El contenido del archivo empieza en la línea que
sigue y llega hasta el final de este mensaje:
```

Contenido del SKILL.md:

```markdown
---
name: fable-plan
description: Planeación al estilo Fable 5. Usar antes de construir una función nueva, hacer un cambio grande, o cuando pidan un plan para cualquier desarrollo.
---

# Fable Plan — las preguntas antes de construir

Nunca propongas sin explorar. El plan que se escribe sin leer el código es
ficción con formato.

## Paso 1 — Explora primero
Lee el código relevante antes de opinar: cómo está hecho lo que ya existe,
qué convenciones sigue el proyecto y qué se puede reutilizar. Si vas a
proponer algo nuevo, primero demuestra que no existe ya.

## Paso 2 — Las preguntas de Fable (respóndelas todas)
1. ¿Cuál es el problema REAL detrás del pedido? Lo que piden y lo que
   necesitan no siempre coinciden.
2. ¿Qué es lo más pequeño que resuelve ese problema?
3. ¿Qué se rompe con este cambio? Busca los lugares que dependen de lo que
   vas a tocar — no asumas que ninguno.
4. ¿Cuáles son los casos límite? Vacío, enorme, duplicado, sin conexión,
   usuario sin permiso.
5. ¿Cómo verificamos que quedó? Nombra el comando, la prueba o el ojo humano
   que lo confirma. Un paso sin verificación no es un paso.
6. ¿Qué NO vamos a hacer, y por qué? Dejarlo escrito evita que regrese.

## Paso 3 — El plan
- Pasos pequeños y reversibles; cada paso con su verificación.
- Si una pregunta abierta CAMBIA el plan, se hace antes de escribirlo. Si no
  lo cambia, se decide y se anota la decisión tomada.
- El plan dice qué archivos se tocan y qué se reutiliza de lo existente.

## Regla de cierre
Presenta el plan y espera el OK antes de tocar código. Un plan aprobado a
medias es un malentendido con cronograma.
```

---

## Manual 4: Abogado del diablo

### Prompt adaptativo

```
Piensa profundo. Quiero quedarme con un manual tuyo antes de que cambies de
modelo.

1. Explora este proyecto y entiende su realidad: quién lo usa, de qué
   depende, dónde está frágil, qué deuda técnica carga y cuánto tiempo real
   tengo yo para mantenerlo.

2. Con eso, crea una skill en .claude/skills/abogado-del-diablo/SKILL.md
   (frontmatter: name igual a la carpeta, y una description que diga cuándo
   usarla — sus disparadores — para que se cargue sola) que le enseñe a
   cualquier modelo futuro a criticar mis planes e ideas para ESTE proyecto
   exactamente como lo harías tú:
   - Modo crítica encendido: prohibido "buena idea", "excelente enfoque" y
     cualquier forma de acompañarme al barranco.
   - Primero el steelman: la mejor versión de mi idea, escrita en serio.
   - Luego el ataque: ¿qué la haría fallar en un mes AQUÍ? ¿Quién de mis
     usuarios reales no la usaría? ¿Cuál es la alternativa más barata que
     logra el 80%? ¿Qué costo oculto trae para este proyecto en concreto
     (mantenimiento, dependencias, mi tiempo)?
   - Riesgos rankeados por probabilidad e impacto.
   - Veredicto obligatorio: seguir, cambiar o matar — y si es seguir, los 3
     cambios que más lo mejoran.
   - La regla: una crítica que no cambiaría nada del plan no cuenta.

3. Ancla el manual a la realidad de este proyecto: que nombre sus
   dependencias, sus usuarios y sus puntos frágiles reales. Pregúntame lo
   que no sepas.

4. Al final dime cómo invoco la skill y estrénala criticando la última idea
   que te haya contado (o pídeme una).
```

### Instalador general

```
Crea una skill global en ~/.claude/skills/fable-abogado-del-diablo/SKILL.md
con EXACTAMENTE el contenido de abajo, tal cual, sin resumirlo ni cambiarlo.
Cuando la termines de crear, confírmame la ruta del archivo y dime cómo la
invoco la próxima vez. El contenido del archivo empieza en la línea que
sigue y llega hasta el final de este mensaje:
```

Contenido del SKILL.md:

```markdown
---
name: fable-abogado-del-diablo
description: Crítica constructiva al estilo Fable 5. Usar cuando pidan opinión sobre un plan, una idea o un proyecto, o cuando pidan jugar al abogado del diablo.
---

# Abogado del diablo — la crítica como la haría Fable 5

Apaga el modo porrista. Prohibido "buena idea", "excelente enfoque" y
"me encanta". El dueño no necesita compañía: necesita saber dónde se rompe
su plan antes de apostarle tiempo y dinero.

## Paso 1 — Steelman
Antes de atacar, escribe la MEJOR versión del plan: qué tendría que ser
cierto para que funcione de maravilla. Criticar una caricatura no le sirve
a nadie.

## Paso 2 — El ataque (las cuatro preguntas)
1. ¿Qué haría que esto falle en un mes? Sé específico: no "podría no
   funcionar", sino la cadena exacta de eventos.
2. ¿Quién NO lo usaría, y por qué? El cliente imaginado que dice "no" enseña
   más que el que dice "sí".
3. ¿Cuál es la alternativa más barata que logra el 80% del resultado? Si
   existe y no se consideró, el plan tiene que justificar la diferencia.
4. ¿Qué costo oculto trae? Mantenimiento, dependencias nuevas, tiempo del
   dueño, complejidad que se queda a vivir.

## Paso 3 — Riesgos rankeados
Lista los riesgos por probabilidad e impacto, de mayor a menor. Los dos de
arriba merecen un plan B escrito; el resto, vigilancia.

## Paso 4 — Veredicto (obligatorio)
Cierra con una de tres: SEGUIR (más los 3 cambios que más lo mejoran),
CAMBIAR (qué exactamente), o MATAR (y a dónde mover esa energía). Sin
veredicto, la crítica fue entretenimiento.

## Las reglas de Fable
- Una crítica que no cambiaría nada del plan no cuenta como crítica.
- Critica el plan, no acompañes al dueño: nada de suavizar el final para
  quedar bien.
- Si el plan resiste el ataque completo, dilo también: la aprobación que
  sobrevive al abogado del diablo sí vale.
```

---

## Manual 5: Fixer

### Prompt adaptativo

```
Piensa profundo. Quiero quedarme con un manual tuyo antes de que cambies de
modelo.

1. Explora este proyecto y documenta cómo se verifica aquí que algo
   funciona: cómo se corre, cómo se prueba, dónde se ven los logs y los
   errores, y qué comando confirma que el proyecto sigue sano.

2. Con eso, crea una skill en .claude/skills/fixer/SKILL.md (frontmatter:
   name igual a la carpeta, y una description que diga cuándo usarla — sus
   disparadores — para que se cargue sola) que le enseñe a cualquier modelo
   futuro a arreglar bugs en ESTE proyecto exactamente como lo harías tú:
   - Reproducir primero: hacer que el bug pase frente a ti antes de tocar
     nada; si no se puede reproducir, todavía no se entiende.
   - Causa raíz, no síntoma: preguntar "por qué" hacia atrás hasta el código
     que decide, no el que muestra el error.
   - Arreglo mínimo: sin refactors oportunistas de "ya que estamos aquí".
   - Probar con evidencia: correr el caso exacto que fallaba con los
     comandos reales de este proyecto y mostrar el output. "Debería
     funcionar" está prohibido.
   - La regla contra el "ya quedó": si otro modelo o una sesión anterior
     dice que algo está arreglado, se le pide la evidencia; sin output que
     lo demuestre, se trata como no arreglado.
   - Reporte fiel: si la prueba falla, se dice con el output completo.

3. Sé concreto: los comandos de verificación reales de este proyecto, sus
   rutas de logs, sus pruebas. Nada genérico. Pregúntame lo que no sepas.

4. Al final dime cómo invoco la skill y hazme una demostración corta con
   cualquier detalle menor que encuentres.
```

### Instalador general

```
Crea una skill global en ~/.claude/skills/fable-fixer/SKILL.md
con EXACTAMENTE el contenido de abajo, tal cual, sin resumirlo ni cambiarlo.
Cuando la termines de crear, confírmame la ruta del archivo y dime cómo la
invoco la próxima vez. El contenido del archivo empieza en la línea que
sigue y llega hasta el final de este mensaje:
```

Contenido del SKILL.md:

```markdown
---
name: fable-fixer
description: Arreglo de bugs al estilo Fable 5. Usar cuando haya un bug o error que arreglar, cuando algo "arreglado" siga fallando, o cuando pidan verificar que un arreglo de verdad quedó.
---

# Fixer — arreglar como Fable 5 (con prueba en mano)

"Debería funcionar" está prohibido. Un bug está arreglado cuando hay
evidencia de que ya no pasa — no cuando el código "se ve bien".

## Paso 1 — Reproduce primero
Antes de tocar nada, haz que el bug pase frente a ti: el comando, el click,
el dato exacto que lo dispara. Si no puedes reproducirlo, todavía no lo
entiendes — y arreglar lo que no entiendes es reacomodar el problema.

## Paso 2 — Causa raíz, no síntoma
Pregunta "¿por qué?" hacia atrás hasta llegar al código que DECIDE, no al
que muestra el error. El error visible casi nunca vive donde nació.
Verifica la causa: predice qué pasaría si tu teoría es cierta, y compruébalo
antes de escribir el arreglo.

## Paso 3 — El arreglo mínimo
Arregla la causa, no maquilles el síntoma. Y nada de refactors oportunistas:
el "ya que estamos aquí" es la forma clásica en que un arreglo rompe otras
dos cosas.

## Paso 4 — Prueba con evidencia
- Corre el caso exacto que fallaba y muestra el output de que ya pasa.
- Corre también lo vecino: lo que tocaste puede haber roto al lado.
- Si el proyecto tiene pruebas, córrelas; si no las tiene, deja escrita la
  receta manual de verificación que usaste.

## Contra el "ya quedó"
Cuando otro modelo (o una sesión anterior) diga que algo ya está arreglado:
pide la evidencia. ¿Qué comando corrió? ¿Qué output dio? ¿Se ejercitó el
caso que fallaba? Sin evidencia, trátalo como no arreglado y verifícalo tú.

## Las reglas de Fable
- Reporte fiel: si la prueba falla, se dice con el output completo — no se
  esconde, no se suaviza, no se promete que "es un detalle".
- Un arreglo sin caso de verificación es una hipótesis con buen marketing.
- Si después de dos intentos serios la causa sigue sin aparecer, se dice
  honestamente y se documenta lo que ya se descartó — eso también es avance.
```

---

## Bonus: El manual que solo tú necesitas

### Meta-prompt

```
Quiero dejarme un manual tuyo sobre [TEMA — describe aquí eso que hagas
seguido: redactar propuestas, revisar el copy de mis posts, cotizar
proyectos, responder clientes difíciles...].

1. Hazme máximo 5 preguntas, UNA POR UNA (espera mi respuesta antes de la
   siguiente), para entender exactamente qué hago, cómo lo hago, qué me
   funciona y dónde me equivoco.

2. Con mis respuestas, crea una skill GLOBAL en ~/.claude/skills/ — así me
   sirve en todos mis proyectos; solo si te digo que es únicamente para
   este, ponla en .claude/skills/ del proyecto. Tú decide el nombre de la
   carpeta (frontmatter: name igual a la carpeta, y una description que
   diga cuándo usarla — sus disparadores — para que se cargue sola). La
   skill debe enseñarle a cualquier modelo futuro a hacer esto conmigo como
   lo harías tú:
   - Los pasos en orden, como los seguirías tú.
   - Las reglas de decisión: cuándo elegir un camino u otro, y los errores
     que hay que evitar (incluyendo los que yo te conté).
   - Cómo se ve un buen resultado y cómo verificarlo antes de darlo por
     terminado.

3. Usa lo que te conté, con mis palabras donde ayude. Nada genérico: si el
   manual podría servirle igual a un desconocido, le faltó entrevista.

4. Al final dime cómo invoco la skill y hazme una prueba corta con un caso
   real mío.
```

---

## Después de Fable

Las skills no se "activan": cuando una tarea coincide con la descripción del manual, Claude lo carga solo. Para forzarlo, nómbrala en el chat.

**En tu proyecto:** `.claude/skills/` — van con el repo
**Globales:** `~/.claude/skills/` — disponibles en cualquier proyecto

Uso: `Usa la skill fable-fixer para arreglar este bug`

Cuando Opus o Sonnet tomen el volante: "sigue el manual fable-plan antes de construir esto". Y cuando alguno anuncie que un bug ya quedó, el manual del fixer les recuerda: sin evidencia, no está arreglado.
