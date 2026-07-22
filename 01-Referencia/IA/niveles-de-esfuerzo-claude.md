---
tags: [ia/claude, model-routing, referencia]
fuente: https://www.tododeia.com/community/niveles-de-esfuerzo
---

# Niveles de esfuerzo en Claude

> Regla fundamental: "Lo simple en bajo, lo que de verdad estás construyendo en alto, y guardar el máximo para lo que de verdad lo amerita, que es casi nunca."

Ver también: [[../../guides/model-routing|model-routing.md]] (tabla propia de escalación de modelos).

## Los 5 niveles

| Nivel | Cuándo usar |
|-------|-------------|
| Bajo | Chat casual, preguntas rápidas, buscar un dato, reescribir texto corto, clasificar/resumir |
| Medio | Razonamiento moderado, balance rapidez/calidad |
| Alto | Trabajo real: código, análisis, decisiones que importan |
| Extra-alto | Trabajo agéntico, programación difícil, sesiones largas — **default de Claude Code** |
| Máximo | Casi nunca. Solo problemas de frontera donde acertar > costo/tiempo |

Advertencia: "poner todo al máximo no te da mejores respuestas: te vacía la cuenta y a veces te la entrega peor."

## Comportamiento por modelo

| Modelo | Niveles | Nota |
|--------|---------|------|
| Fable 5 | Bajo→Máximo | Tope, máximo costo |
| Opus 4.8 | Bajo→Máximo | Control completo + fast mode |
| Sonnet 5 | Bajo→Máximo | Default recomendado |
| Haiku 4.5 | Sin niveles | Velocidad fija; cambiar de modelo si se necesita más pensamiento |

## Dónde cambiarlo

- **Chat (claude.com)**: nombre del modelo junto a enviar → "Esfuerzo"
- **Cowork**: mismo menú que chat
- **Claude Code**: `/effort` (menú), `/effort ultracode` (workflows paralelos), `/fast` (acelera Opus sin bajar inteligencia)

## Prompts copia-pega

**Bajar pensamiento:**
> "Esto es una tarea sencilla. Respóndeme directo y al grano, sin analizarlo de más ni darle mil vueltas."

**Subir pensamiento:**
> "Esto importa y prefiero que aciertes a que vayas rápido. Tómate tu tiempo: piénsalo paso a paso, considera los casos que se pueden romper."

**Auto-calibración (varias tareas seguidas):**
> "Te voy a pedir varias cosas seguidas. Antes de resolver cada una, dime si la ves como esfuerzo bajo, medio o alto y por qué."
