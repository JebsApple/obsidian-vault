---
tags: [configuracion, sincronizacion, obsidian, setup]
---

# Setup de sincronización en máquina nueva

Instrucciones para que cualquier computadora pueda leer y escribir en el vault.

---

## Paso 0 — Conectarse a GitHub

El vault se sincroniza via GitHub. Cada máquina necesita permiso para subir cambios.

### Opción A: SSH (recomendada, más limpia)

**En la terminal de la máquina nueva:**
```bash
# 1. Generar llave SSH
ssh-keygen -t ed25519 -C "Vherrera756@gmail.com"
# Presionar Enter 3 veces (dejar todo por defecto)

# 2. Mostrar la llave (copiar el resultado)
cat ~/.ssh/id_ed25519.pub
```

**Luego en GitHub (una sola vez por máquina):**
1. Ir a https://github.com/settings/keys
2. Clic en **New SSH key**
3. Pegar la llave que copiaste, poner nombre (ej: "Laptop Juli")
4. Clic en **Add SSH key**

### Opción B: Token (más rápido)

En https://github.com/settings/tokens → Generate new token → clásico, marcar `repo`, copiar el token.

Luego en la terminal:
```bash
git remote set-url origin https://TOKEN@github.com/JebsApple/obsidian-vault.git
```

---

## Paso 1 — Clonar el vault en la máquina

```bash
git clone git@github.com:JebsApple/obsidian-vault.git ~/obsidian-vault
```

Si usaste token en vez de SSH:
```bash
git clone https://TOKEN@github.com/JebsApple/obsidian-vault.git ~/obsidian-vault
```

Esto descarga todo el vault a la carpeta `obsidian-vault` en tu home.

---

## Paso 2 — Abrir el vault en Obsidian

1. Abrir Obsidian
2. Clic en **Abrir bóveda** (Open folder as vault)
3. Elegir la carpeta `obsidian-vault` (está en `/home/tu-usuario/obsidian-vault/`)
4. Si pregunta si confías en el autor, clic en **Confiar**

---

## Paso 3 — Activar los plugins

En Obsidian:
1. Ir a **Configuración** (Settings) → **Community plugins**
2. Desactivar **Modo seguro** (Safe mode) — sí, confías
3. Clic en **Recargar** (Reload)
4. Activar **Git** y **Automatic Linker** desde la lista

Listo. El plugin **Git** sincronizará automáticamente: cada 10 min hace commit, cada 30 min sube a GitHub.
El plugin **Automatic Linker** crea enlaces entre notas automáticamente al guardar.

---

## Paso 4 (solo Linux) — Auto-sync via systemd (cada 30 min)

Esto hace sync automático aunque Obsidian esté cerrado:

```bash
# Crear el script de sync
cat > ~/.local/bin/obsidian-sync.sh << 'EOF'
#!/bin/bash
VAULT="$HOME/obsidian-vault"
cd "$VAULT" || exit 1
git pull --rebase --autostash origin main 2>/dev/null || true
git add -A
if ! git diff --cached --quiet; then
  git commit -m "auto-sync $(date '+%Y-%m-%d %H:%M')"
fi
git push origin main 2>/dev/null || true
EOF
chmod +x ~/.local/bin/obsidian-sync.sh

# Crear el timer de systemd
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/obsidian-sync.service << 'SVC'
[Unit]
Description=Obsidian vault auto-sync
[Service]
Type=oneshot
ExecStart=%h/.local/bin/obsidian-sync.sh
SVC

cat > ~/.config/systemd/user/obsidian-sync.timer << 'TMR'
[Unit]
Description=Sync Obsidian vault cada 30 minutos
[Timer]
OnBootSec=5min
OnUnitActiveSec=30min
[Install]
WantedBy=timers.target
TMR

# Activar
systemctl --user daemon-reload
systemctl --user enable --now obsidian-sync.timer
```

Verificar que está activo:
```bash
systemctl --user status obsidian-sync.timer
```

---

## Paso 5 (solo Linux) — Comando manual `vsync`

Para forzar un sync cuando quieras:

```bash
# Crear el comando
cat > ~/.local/bin/vault-sync << 'VS'
#!/bin/bash
VAULT="$HOME/obsidian-vault"
cd "$VAULT" || exit 1
echo "→ Bajar cambios de GitHub..."
git pull --rebase --autostash origin main 2>&1 || {
  echo "⚠ Conflicto. Revisar y resolver manualmente."
  exit 1
}
echo "→ Subir cambios locales..."
git add -A
if ! git diff --cached --quiet; then
  git commit -m "sync $(date '+%Y-%m-%d %H:%M')"
fi
git push origin main 2>&1 || echo "⚠ Sin conexión"
echo "✓ Listo"
VS
chmod +x ~/.local/bin/vault-sync

# Agregar al .zshrc (para que exista el alias vsync)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
echo 'alias vsync="vault-sync"' >> ~/.zshrc
source ~/.zshrc
```

Ahora puedes escribir `vsync` en la terminal para sincronizar al instante.

---

## Cómo funciona todo junto

| Situación | Qué pasa | Quién lo hace |
|---|---|---|
| Editas una nota en Obsidian | Cada 10 min se guarda localmente | Plugin Git |
| Cada 30 min | Se sube a GitHub | Plugin Git |
| Abres Obsidian en otra máquina | Baja los cambios nuevos | Plugin Git |
| La PC está encendida pero Obsidian cerrado | Cada 30 min se sincroniza | systemd timer |
| Quieres forzar sync ahora | Escribe `vsync` en terminal | Script manual |

---

## Para Windows / Mac

En Windows y Mac no existe systemd, así que solo funciona con el **plugin Git** dentro de Obsidian.
Es suficiente: mientras Obsidian esté abierto, sincroniza solo.

---

## Notas importantes

- **No modifiques** `.obsidian/workspace.json` ni `.obsidian/graph.json` — son de cada máquina
- Si hay un conflicto (dos máquinas editaron la misma línea), Obsidian Git mostrará un mensaje. Resuélvelo manualmente o pregunta
- Cualquier máquina nueva: repetir Pasos 0, 1, 2, 3

---

## Links útiles

- GitHub del vault: https://github.com/JebsApple/obsidian-vault
- Plugin Obsidian Git: https://github.com/Vinzent03/obsidian-git
- Plugin Automatic Linker: https://github.com/kdnk/obsidian-automatic-linker

---

## Auto-sync del SERVER (2026-06-29)

El server (`192.168.50.25`) ahora sube/baja solo, sin pedírselo a la IA.

- **Script:** `~/.local/bin/vault-sync.sh` — commit local + `pull --rebase` + push.
- **Cron:** `*/5 * * * *` (cada 5 min). Ver con `crontab -l`.
- **Log:** `~/.local/share/vault-sync.log`.
- **Conflictos:** si `pull --rebase` choca, aborta y lo anota en el log para resolución manual (no rompe nada).

Flujo completo: **Server** (cron 5 min) ⇄ **GitHub** ⇄ **PC** (plugin Obsidian Git). Editar en cualquiera de los dos lados se propaga al otro en ~5-10 min.
