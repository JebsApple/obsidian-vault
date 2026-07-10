---
tags: [herramientas-ia, claude, automatizacion, cron, server]
created: 2026-07-10
---

# Programar Claude para ejecutar tareas automáticas

> **Objetivo:** Que Claude lea un archivo "pedido" de un repo de GitHub y ejecute lo que pida, automáticamente a las 2:30 AM (o cuando tú quieras).

---

## REQUISITOS

- [ ] Claude CLI instalado (`claude` funciona en terminal)
- [ ] Acceso SSH al server
- [ ] El repo `jebsapple/obsidian-vault` tiene un archivo llamado `pedido.md` (o `pedido`)

---

## PASO 1: Crear el script

Copia y pega **tal cual** esto en la terminal del server:

```bash
mkdir -p /home/apuru/.local/bin
mkdir -p /home/apuru/logs

cat > /home/apuru/.local/bin/run-claude-pedido.sh << 'FINSCRIPT'
#!/bin/bash

REPO_URL="https://github.com/jebsapple/obsidian-vault.git"
REPO_DIR="/tmp/obsidian-vault-pedido"
LOG_FILE="/home/apuru/logs/pedido-$(date +%Y-%m-%d).log"

echo "=== $(date) === Iniciando ejecución del pedido ===" >> "$LOG_FILE"

# Paso 1: Actualizar repo
if [ -d "$REPO_DIR" ]; then
    git -C "$REPO_DIR" pull --quiet >> "$LOG_FILE" 2>&1
else
    git clone "$REPO_URL" "$REPO_DIR" --quiet >> "$LOG_FILE" 2>&1
fi

# Paso 2: Leer el pedido
PEDIDO=""
if [ -f "$REPO_DIR/pedido.md" ]; then
    PEDIDO=$(cat "$REPO_DIR/pedido.md")
elif [ -f "$REPO_DIR/pedido" ]; then
    PEDIDO=$(cat "$REPO_DIR/pedido")
else
    echo "ERROR: No se encontró pedido.md ni pedido" >> "$LOG_FILE"
    exit 1
fi

# Paso 3: Ejecutar Claude
echo "$PEDIDO" | claude -p --dangerously-skip-permissions >> "$LOG_FILE" 2>&1

echo "=== $(date) === Pedido completado ===" >> "$LOG_FILE"
FINSCRIPT

chmod +x /home/apuru/.local/bin/run-claude-pedido.sh

echo "✅ Script creado en /home/apuru/.local/bin/run-claude-pedido.sh"
```

---

## PASO 2: Probar que funciona (ANTES de programar)

### Opción A: Ejecutar ahora mismo

```bash
/home/apuru/.local/bin/run-claude-pedido.sh
```

Después revisa el log:

```bash
cat /home/apuru/logs/pedido-$(date +%Y-%m-%d).log
```

### Opción B: Ejecutar en 2 minutos (prueba rápida)

```bash
echo "/home/apuru/.local/bin/run-claude-pedido.sh" | at now + 2 minutes
```

Espera 2 minutos y revisa el log arriba.

### Si falla, verifica:

1. `claude` funciona: escribe `claude --version`
2. Git funciona: escribe `git --version`
3. El repo tiene el archivo: `ls /tmp/obsidian-vault-pedido/pedido*`

---

## PASO 3: Programar para las 2:30 AM (diario)

```bash
crontab -e
```

Agrega **esta línea al final** del archivo que se abre:

```
30 2 * * * /home/apuru/.local/bin/run-claude-pedido.sh
```

Guarda y sal (en vim: `:wq`, en nano: `Ctrl+X`, `Y`, `Enter`).

Verifica que quedó:

```bash
crontab -l
```

Deberías ver la línea de arriba.

---

## PASO 4: Programar para una hora específica (una vez)

Si quieres que se ejecute **una vez** a las 11:00 PM de hoy:

```bash
echo "/home/apuru/.local/bin/run-claude-pedido.sh" | at 23:00
```

O para **dentro de 1 hora y 50 minutos** desde ahora:

```bash
echo "/home/apuru/.local/bin/run-claude-pedido.sh" | at now + 1 hour 50 minutes
```

---

## COMANDOS ÚTILES

| Qué quiero hacer | Comando |
|---|---|
| Ver si el cron está programado | `crontab -l` |
| Ver el log de hoy | `cat /home/apuru/logs/pedido-$(date +%Y-%m-%d).log` |
| Ver logs en tiempo real | `tail -f /home/apuru/logs/pedido-$(date +%Y-%m-%d).log` |
| Ejecutar ahora manualmente | `/home/apuru/.local/bin/run-claude-pedido.sh` |
| Cancelar un `at` programado | `atq` (ver IDs) → `atrm <ID>` |
| Eliminar todos los crons | `crontab -r` |
| Verificar que el repo se clonó | `ls /tmp/obsidian-vault-pedido/` |

---

## SOLUCIÓN DE PROBLEMAS

### "claude: command not found"

```bash
# Buscar dónde está
which claude
# Si no aparece, reinstalar o agregar al PATH
export PATH="$HOME/.local/bin:$PATH"
# Para que sea permanente, agregar a ~/.bashrc:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

### "Permission denied" al ejecutar el script

```bash
chmod +x /home/apuru/.local/bin/run-claude-pedido.sh
```

### "No se encontró pedido.md"

1. Verificar que el repo existe: `ls /tmp/obsidian-vault-pedido/`
2. Verificar el nombre exacto del archivo: `ls /tmp/obsidian-vault-pedido/pedido*`
3. Si el archivo tiene otro nombre, editar el script y cambiar `pedido.md` por el nombre correcto

### El log está vacío o no se crea

```bash
# Crear directorio de logs manualmente
mkdir -p /home/apuru/logs
# Verificar permisos
ls -la /home/apuru/logs/
```

---

## ¿QUÉ HACE `--dangerously-skip-permissions`?

Le dice a Claude que **no pregunte** antes de ejecutar comandos. Es necesario para modo automático. **Solo úsalo en:**

- ✅ Servidores donde tú eres el único usuario
- ✅ Scripts que tú controlas
- ❌ Servidores compartidos con otros usuarios
- ❌ Cuando no sabes qué contiene el "pedido"

---

## FLUJO COMPLETO

```
2:30 AM (cron)
    ↓
run-claude-pedido.sh
    ↓
git pull (actualiza repo)
    ↓
lee pedido.md
    ↓
echo "contenido" | claude -p --dangerously-skip-permissions
    ↓
Claude ejecuta lo que pida el pedido
    ↓
guarda log en /home/apuru/logs/
```

---

## VERIFICACIÓN FINAL

Después de todo, confirma con estos 3 comandos:

```bash
# 1. Script existe y es ejecutable
ls -la /home/apuru/.local/bin/run-claude-pedido.sh

# 2. Cron está programado
crontab -l

# 3. Log se creó (después de ejecutar manualmente)
ls /home/apuru/logs/
```

Si los 3 funcionan → **todo listo**. Claude se ejecutará solo a las 2:30 AM.
