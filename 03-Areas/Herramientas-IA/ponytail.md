---
tags: [concepto, herramienta, ai-agents]
---

# Ponytail

> Makes your AI agent think like the laziest senior dev in the room. The best code is the code you never wrote.

Repo: `https://github.com/DietrichGebert/ponytail`  
Clonado en: `/home/apuru/ponytail`  
Plugin OpenCode: `/home/apuru/ponytail/.opencode/plugins/ponytail.mjs`

## Filosofía

Antes de escribir código, el agente revisa esta escalera y se detiene en el primer peldaño que se cumple:

1. **¿Esto necesita existir?** → no: sáltalo (YAGNI)
2. **¿La stdlib lo hace?** → úsala
3. **¿El navegador/plataforma lo tiene nativo?** → úsalo
4. **¿Una dependencia ya instalada lo cubre?** → úsala
5. **¿Se puede en una línea?** → una línea
6. **Solo entonces: el mínimo que funcione**

Nunca corta validación, manejo de errores, seguridad ni accesibilidad.

## Modos

- `lite` — modo relajado
- `full` — modo normal (default)
- `ultra` — máximo minimalismo
- `off` — desactivado

Se controlan via `/ponytail [lite|full|ultra|off]` en OpenCode, o con `PONYTAIL_DEFAULT_MODE` env var.

## Comandos

| Comando | Qué hace |
|---------|----------|
| `/ponytail` | Muestra nivel actual |
| `/ponytail lite/full/ultra/off` | Cambia intensidad |
| `/ponytail-review` | Revisa diff actual, lista lo que sobra |
| `/ponytail-audit` | Audita todo el repo por sobreingeniería |
| `/ponytail-debt` | Cobra deuda técnica diferida |
| `/ponytail-help` | Referencia rápida |

## Instalación

Para OpenCode: se agregó `plugin` en `~/.config/opencode/opencode.jsonc` apuntando al `.mjs`.

## Referencias

- [[lecciones]]
- [[opencode]]
