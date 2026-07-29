# Self-Diagnostic Skill

Auto-diagnóstico del agente. Ejecutar cuando el usuario pida "diagnóstico", "self-check", "revisate", o cuando el agente detecte patrones de error.

## Workflow

### 1. Estado del sistema

```bash
# Verificar opencode version y config
opencode --version 2>/dev/null || echo "version desconocida"
cat ~/.config/opencode/opencode.json 2>/dev/null | head -20

# Verificar logs recientes por errores
tail -100 ~/.local/share/opencode/log/opencode.log 2>/dev/null | grep -i "error\|fail\|not found" | tail -10

# Verificar plugins instalados
ls ~/.config/opencode/plugins/ 2>/dev/null
ls ~/.cache/opencode/packages/ 2>/dev/null

# Verificar agents y skills
ls ~/.config/opencode/agents/ 2>/dev/null
ls ~/.config/opencode/skills/ 2>/dev/null
```

### 2. Configuración del agente

Verificar:
- [ ] `model` en opencode.json es válido (correr `opencode model list`)
- [ ] No hay doble prefijo `opencode/opencode/` en ningún modelo
- [ ] Plugins tienen `main` o `exports` en package.json (los que no son bin)
- [ ] Agents instalados tienen `mode` válido (primary/secondary/subagent)
- [ ] Skills instalados tienen SKILL.md válido
- [ ] `compaction.auto` está en `false` (evita ProviderModelNotFoundError)

### 3. Patrones de error en logs

```bash
# Buscar errores recurrentes
grep -c "ProviderModelNotFoundError" ~/.local/share/opencode/log/opencode.log 2>/dev/null
grep -c "share subscriber failed" ~/.local/share/opencode/log/opencode.log 2>/dev/null
grep -c "auto-capture" ~/.local/share/opencode/log/opencode.log 2>/dev/null

# Últimos errores únicos
grep "ERROR" ~/.local/share/opencode/log/opencode.log 2>/dev/null | tail -20 | sort -u
```

### 4. Salud de plugins

Para cada plugin en opencode.json:
- Verificar que el path/PAquete existe
- Verificar que tiene export válido
- Verificar que no produce errores en logs

### 5. Verificación de AGENTS.md

Leer `~/CLAUDE.md` y verificar:
- [ ] Instrucciones de idioma presentes
- [ ] Reglas de comportamiento presentes
- [ ] Instrucciones de self-check presentes
- [ ] No hay contradicciones entre secciones

### 6. Output esperado

Generar reporte conciso:
```
## Diagnóstico [fecha]
- Opencode: v[X] ✓/✗
- Config: ✓/✗ (problemas: [lista])
- Plugins: [N] instalados, [N] activos, [N] con errores
- Agents: [N] configurados
- Skills: [N] instalados
- Errores en log: [N] últimos [periodo]
- Último error: [描述]
- Salud general: BUENA/REGULAR/MALA
```

## Auto-diagnóstico (para el agente)

El agente debe correr este diagnóstico:
1. **Al inicio de cada sesión** — verificar que todo está OK
2. **Después de un error** — buscar si es problema recurrente
3. **Cada 20 turnos** — check rápido de salud
4. **Cuando el usuario pregunte** sobre problemas del sistema

## Comandos rápidos

| Comando | Qué hace |
|---------|----------|
| `self-check` | Diagnóstico completo |
| `check-logs` | Solo revisar errores en logs |
| `check-config` | Solo verificar configuración |
| `check-plugins` | Solo verificar plugins |
