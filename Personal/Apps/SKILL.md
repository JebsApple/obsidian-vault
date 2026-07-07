---
name: manhwa-translator
description: Traductor especializado de manhwa y manga al español. Usa este skill cuando el usuario envíe imágenes de páginas de manhwa/manga para traducir, especialmente si están en coreano o japonés, o cuando pida traducir paneles, globos de diálogo, efectos de sonido o texto de viñetas. También úsalo cuando el usuario mencione "cap", "capítulo", "traducir paneles", "traducir imágenes" o cuando quiera subir la traducción a Google Drive. Este skill define el formato de símbolos exacto y el formato de presentación que debe seguirse siempre. SIEMPRE úsalo cuando lleguen imágenes de manhwa/manga, incluso si el usuario solo dice "traduce esto". También úsalo cuando el usuario entregue archivos .docx con traducciones para revisar, perfeccionar o subir a Google Drive.
---

# Traductor de Manhwa al Español — Manzana

## Objetivo

Traducir páginas de manhwa (o manga) al español con precisión, respetando el sistema de símbolos del equipo de scanlation y subiendo el resultado a Google Drive cuando se solicite.

---

## ¿Para qué sirven los símbolos?

Los símbolos **no describen el contenido emocional del texto**: le indican al **editor qué fuente tipográfica aplicar** en cada globo o recuadro. Cada símbolo corresponde a un tipo visual de globo, y el editor sabe qué fuente usar para cada uno.

**Regla fundamental:** el símbolo se asigna según la **forma visual del globo en el panel**, no según lo que dice ni cómo suena.

---

## Tabla de símbolos

| Símbolo | Tipo de globo / recuadro visual | Ejemplo correcto |
|---------|----------------------------------|------------------|
| `-` (guión) | Globo de diálogo estándar — primera línea después de un cambio de fuente/símbolo | `-¿Estás bien?` |
| *(sin símbolo ni guión)* | Continuación del mismo tipo de globo — líneas que siguen al guión dentro del mismo bloque de diálogo | `Uhm… no lo sé.` |
| `()` | Pensamiento interno — globo con contorno ondulado o de nube | `()No puede ser...` |
| `**` | Grito — globo con picos o forma de explosión o borde dentado irregular | `**¡¡¡Increíble!!!` |
| `//` | Dos globos físicamente fusionados en el panel — segunda parte del globo unido | `//¿No me escuchaste?` |
| `[]` | Recuadro rectangular — cuadro de sistema, narración encuadrada, o pensamiento de narrador externo | `[]Como era de esperar…` |
| `/` | Texto flotante sin recuadro — narración suelta, títulos de capítulo, comparaciones entre paneles | `/Hace un año` |
| `<>` | Ventana de sistema flotante — interfaces de videojuego/isekai con estética digital (status, nivel, habilidades, análisis de objetos). Visualmente suelen ser recuadros con fondo celeste translúcido o estética de UI digital | `<>Análisis de objeto` |
| `##` | Texto secundario pequeño al borde de un globo | `##¿De qué hablas?` |
| `sfx:` | Onomatopeyas y efectos de sonido — **NO van al archivo Drive** | `sfx: ゴゴゴ` |
| `Ot:` | Texto en objetos físicos (carteles, camisetas, armas, letreros) | `Ot: Espada del Rey` |
| `$$` | Texto visible en pantallas digitales dentro del panel | `$$Cargando...` |
| `&&` | Globo tecnológico — llamadas, radio, megáfono, anuncio por altavoz | `&&¿Me escuchas?` |


---

## La regla del guión `-` — CRÍTICA

El guión **marca el primer texto de un tipo de globo** cada vez que la fuente cambia. No se repite en las líneas que continúan dentro del mismo bloque.

```
// Cambio desde () → primer diálogo lleva guión
()pensamiento anterior

-Primera línea del diálogo
Segunda línea del mismo diálogo    ← sin guión, misma fuente continúa
Tercera línea del mismo diálogo    ← sin guión

()Otro pensamiento    ← cambio de fuente, () marca el cambio

-Retoma el diálogo    ← cambio de fuente de vuelta, guión de nuevo
```

**Regla precisa:** el guión aparece en la primera línea de cada "bloque de diálogo" nuevo, definido como el primer texto sin símbolo especial que aparece luego de un texto con símbolo distinto ((), **, //, [], /, etc.).

- ✅ Bloque de solo diálogos seguidos → solo el primero lleva guión
- ✅ Después de un `()`, `**`, `[]`, `/`, etc. → el siguiente diálogo lleva guión
- ❌ Poner guión en cada línea de diálogo indiscriminadamente
- ❌ Omitir el guión cuando hay un cambio real de fuente

---

## Reglas de formato de símbolos

### Sin espacio entre símbolo y texto
El símbolo va pegado al texto, sin espacio. Sin excepciones.

- ✅ `**¡¡¡Increíble!!!`
- ❌ `** ¡¡¡Increíble!!!`
- ✅ `()No puede ser...`
- ❌ `() No puede ser...`
- ✅ `-¿Estás bien?`
- ❌ `- ¿Estás bien?`

### El símbolo no cierra al final
Los símbolos solo aparecen al **inicio** de la línea. Nunca se repiten al final.

- ✅ `**¡¡¡Increíble!!!`
- ❌ `**¡¡¡Increíble!!!**`

### Signos de exclamación e interrogación en español
El español requiere signo de apertura. Siempre corregir aunque el original no lo tenga.

**Regla de simetría:** la cantidad de signos de apertura debe coincidir con la de cierre para cada tipo.

- ✅ `**¡¡¡Increíble!!!`
- ❌ `**¡Increíble!!!` — apertura y cierre deben ser simétricos

**Signos mixtos `?!` o `!?`:** cuando se combinan, el signo de cierre dominante va al final y la apertura lo replica invertido.

- Cierra con `?!!` → abre con `¡¡¿` → ✅ `**¡¡¿Los dos primeros... creo?!!`
- Cierra con `!?` → abre con `¿¡` → ✅ `**¿¡No puede ser!?`

### El símbolo `//` — dos globos fusionados (telofase)
Se usa **únicamente** cuando dos globos distintos están físicamente unidos en el panel — como una célula en telofase: dos núcleos que comparten la misma membrana. Son globos separados que se tocan o fusionan visualmente.

```
-No lo habrá dicho con mala intención
//deberías estar agradecido
```

- ✅ Dos globos físicamente unidos/fusionados en el panel → usar `//` en el segundo
- ❌ Texto con salto de línea dentro de un **mismo globo** → NO usar `//`, es una sola línea continua o se une en una sola línea
- ❌ Dos globos separados que no se tocan → cada uno es independiente, sin `//`

### Combinación de símbolos en un mismo globo
Si un globo de grito tiene dos líneas separadas, cada línea lleva `**`:

```
**¡¡¡No
**...huiré ni me esconderé!!!
```

### El símbolo `<>` — ventanas de sistema flotantes
Se usa para **todo el texto dentro de una ventana de sistema** — esas interfaces flotantes de estética digital (fondo celeste translúcido, bordes luminosos) típicas de manhwa isekai y de videojuego. Incluye títulos, estadísticas, nombres de habilidades, descripciones, opciones y cualquier texto que aparezca dentro de esa UI.

```
<>Análisis de lanzamiento
<>Velocidad: 137 km/h
<>Revoluciones: 2210rpm

<>Bola Serpiente
<>Una bola rápida que se retuerce como una serpiente

<>Misión Sorpresa
<>Condiciones de victoria:
<>1. Victoria de tu equipo en el partido
<>Aceptar        <>Cerrar
```

- ✅ Cualquier texto dentro de una ventana de sistema flotante → `<>`
- ❌ Diálogos normales o narración aunque hablen de habilidades → no usan `<>`
- ❌ Recuadros de narración rectangular sin estética de UI → esos van con `[]`

### El símbolo `[]` — recuadros y pensamientos de narrador externo
Para recuadros de datos/análisis y también para cuadros de narración del narrador externo (no del personaje):

```
[]Análisis de lanzamiento
[]Velocidad: 137 km/h

[]Como era de esperar, hay instructores e instructores.
[]Bueno, no todos pueden ser un líder formidable.
```

### El símbolo `/` — texto flotante, títulos, comparaciones
```
/Capítulo 105
/Hace un año. Otoño.
/Recta normal          /Recta Serpiente
/El tardón
```

---

## Formato de presentación por imagen — OBLIGATORIO

Cuando el usuario envía imágenes, presentar **cada imagen por separado** en este orden:

```
**Imagen N**
[texto original en coreano — fuera del bloque de código]

```
[traducción con símbolos — dentro del bloque de código]
```
```

Separar imágenes con `---`.

**Ejemplo completo:**

**Imagen 1**
굉장해!!!
공이 꿈틀거렸어!
마..마치

```
**¡¡¡Increíble!!!
**¡¡¡La bola se retorció!!!

Es..es como
```

---

**Imagen 2**
뱀직구..!
곧게 뻗어 나오는 일반적인 패스트볼과 달리

```
()Recta Serpiente..!
//A diferencia de una recta normal que sale en línea recta,
```

---

- El texto coreano va **fuera** del bloque de código, en texto plano.
- La traducción va **dentro** del bloque de código, lista para copiar.
- Si hay múltiples globos en una imagen, listarlos todos en el coreano y todos en el bloque de código, en orden de lectura.

---

## Reglas de traducción

1. **Coreano → español directo.** No mostrar el original coreano en el archivo Drive.
2. **Inglés → español directo.** No mostrar el original inglés.
3. **sfx no van en el archivo Drive.** Solo en el bloque copiable para referencia del equipo.
4. **Páginas de aviso del equipo de scanlation:** omitir sin comentario.
5. **Nombres propios:** conservar en romanización coreana (Baek Sin-seung, Go Min-young). Si el nombre tiene significado relevante para la trama, traducirlo y poner el original entre paréntesis. Los términos de parentesco y tratamiento se romanizan: **noona** (누나), oppa (오빠), hyung (형), unnie (언니).
6. **Términos culturales sin equivalente exacto:** buscar el equivalente más cercano en español latino. Ejemplo: 낙하산 → "fichaje por enchufe" o "palanca especial" según contexto.
7. **Tono:** respetar la intensidad emocional del original — dramático, casual o técnico según contexto.
8. **Orden de lectura:** mantener el orden natural de los globos por panel (izquierda a derecha en manhwa; derecha a izquierda en manga).
9. **Términos técnicos deportivos:** usar la terminología estándar en español latino (jonrón, boleto, recta, curva, strike, jab, uppercut, cross, guardia, etc.).
10. **Líneas de `/` y `&&`:** preferir una sola línea cuando el texto forma una oración continua, aunque visualmente esté dividido en el panel.
11. **Signos `!!` solos como línea propia:** conservarlos como línea independiente si en el original son un globo propio — `**¡¡`
12. **Variación ortográfica del sfx:** tanto `sfx:` como `sfx` (sin dos puntos) son válidos — usar el que aparezca en el documento de referencia de la serie.

---

## Flujo de trabajo

### 1. Recibir imágenes o archivos .docx
El usuario envía imágenes o archivos .docx con traducciones ya realizadas. Procesar en orden.

### 2. Entregar traducción
Usar el **formato de presentación por imagen** definido arriba. Incluir `sfx:` en el bloque de código para referencia del equipo, aunque no vayan al Drive.

### 3. Subir a Google Drive
Cuando el usuario lo pida, usar `Google Drive:create_file` con `contentMimeType: text/plain`.

El archivo **no debe contener** texto en coreano ni líneas `sfx:`.

Incluir el siguiente encabezado de referencia para el editor al inicio del archivo:

```
Traductor Formato:
- Diálogos normales — guión en primera línea tras cambio de fuente
(sin símbolo/guión) Continuación del mismo diálogo
() Pensamientos internos — fuente cursiva o de pensamiento
** Gritos — fuente bold/impactante
// Dos globos fusionados — segunda parte del globo unido
[] Recuadros rectangulares — fuente de sistema o narración encuadrada
/ Texto flotante / títulos — fuente de narración suelta
<> Ventana de sistema flotante — UI de videojuego/isekai (status, habilidades, análisis)
## Texto secundario pequeño — fuente reducida
Ot: Texto en objetos físicos
$$ Texto en pantalla digital
&& Globo tecnológico / llamadas / megáfono
```

---

## Errores comunes a evitar

| ❌ Error | ✅ Corrección |
|----------|--------------|
| `() Así que lo sabías...` | `()Así que lo sabías...` — sin espacio |
| `**¡Increíble!!!**` | `**¡¡¡Increíble!!!` — sin cierre; apertura simétrica |
| `**¡Increíble!!!` | `**¡¡¡Increíble!!!` — apertura debe ser simétrica al cierre |
| `**¡¡Los dos primeros... creo?!!` | `**¡¡¿Los dos primeros... creo?!!` — el `?` de cierre necesita su `¿` de apertura |
| Poner guión en cada línea de diálogo | Solo en la primera línea después de un cambio de fuente |
| Omitir guión cuando cambió la fuente | Agregar `-` al primer diálogo tras un bloque con símbolo |
| Poner texto coreano en el archivo Drive | Solo español en el Drive |
| Usar `<>` para diálogos que mencionan habilidades | `<>` es solo para texto dentro de ventanas de sistema flotantes con estética UI |
| Olvidar `//` cuando hay dos globos fusionados en el panel | Agregar `//` en la segunda parte del globo unido |
| Usar `//` para un salto de línea dentro de un mismo globo | Unir en una sola línea o dejar sin `//` |
| Usar `[]` para globos hexagonales de megáfono/anuncio | Esos van con `&&` |
| Asignar símbolo por emoción del diálogo | Asignar por **forma visual del globo** |
| Presentar todas las imágenes en un solo bloque | Una sección por imagen, separadas con `---` |
| Escribir "nuna" | La forma correcta es **noona** |
