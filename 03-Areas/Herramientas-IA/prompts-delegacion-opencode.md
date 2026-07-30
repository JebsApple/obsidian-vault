# Prompts de delegación para OpenCode

Estos prompts son para copiar/pegar en una sesión de OpenCode cuando Claude Code delegue tareas mecánicas. Pega el prompt tal cual y OpenCode lo ejecutará.

## Template genérico

```
[Contexto: proyecto, ruta absoluta, rama]
[Tarea precisa y determinística]
[Opcional: comando de verificación]

Criterio de éxito: [resultado binario, ej: "typecheck pasa"]
```

## Cómo funciona

Claude Code te dirá algo como: "Esto es mecánico — copia esto en OpenCode:" seguido de un prompt con contexto y tarea. Lo pegas acá y OpenCode lo ejecuta. Si falta contexto, pídelo antes de empezar.

## Ejemplos

### Renombrado masivo

```
En ~/proyecto-x, renombra todas las ocurrencias de getUserData a fetchUserData en archivos .ts y .tsx. Salta node_modules y dist.
Luego corre npm run typecheck.
Criterio: typecheck pasa sin errores.
```

### Formateo

```
En ~/proyecto-x, corre npx prettier --write "src/**/*.{ts,tsx,css}" y luego npm run lint --fix.
Criterio: lint pasa limpio.
```

### Migración de imports

```
En ~/proyecto-x, cambia imports de '@/lib/utils' a '@/shared/utils' en .ts y .tsx. Salta node_modules.
Criterio: npm run typecheck pasa.
```
