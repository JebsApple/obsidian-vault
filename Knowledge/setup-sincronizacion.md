# Setup de sincronización en máquina nueva

> **Importante:** `.obsidian/workspace.json` y `.obsidian/graph.json` están en `.gitignore`
> porque son específicos de cada máquina. Si los modificas localmente, no se suben al remoto.
> Para evitar conflictos: no hagas commit de esos archivos manualmente.

## 1. Clonar vault

```bash
git clone https://github.com/JebsApple/obsidian-vault.git ~/obsidian-vault
```

## 2. Auto-sync via systemd timer (c/30 min)

```bash
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
Description=Sync Obsidian vault every 30 minutes
[Timer]
OnBootSec=5min
OnUnitActiveSec=30min
[Install]
WantedBy=timers.target
TMR

systemctl --user daemon-reload
systemctl --user enable --now obsidian-sync.timer
```

## 3. Comando manual (0 tokens)

```bash
cat > ~/.local/bin/vault-sync << 'VS'
#!/bin/bash
VAULT="$HOME/obsidian-vault"
cd "$VAULT" || exit 1
echo "→ Pull..."
git pull --rebase --autostash origin main 2>&1 || {
  echo "⚠ Conflicto. Resolver manualmente y reintentar."
  exit 1
}
echo "→ Commit..."
git add -A
if ! git diff --cached --quiet; then
  git commit -m "sync $(date '+%Y-%m-%d %H:%M')"
fi
echo "→ Push..."
git push origin main 2>&1 || echo "⚠ Push falló"
echo "✓ Listo"
VS
chmod +x ~/.local/bin/vault-sync
alias vsync="vault-sync"  # agregar al .zshrc
```

## 4. Plugin Obsidian Git (sync desde la UI)

```bash
mkdir -p ~/obsidian-vault/.obsidian/plugins/obsidian-git
```

Descargar de https://github.com/Vinzent03/obsidian-git/releases/latest:
- `main.js`
- `manifest.json`
- `styles.css`

Colocarlos en `~/.obsidian-vault/.obsidian/plugins/obsidian-git/`.

Luego editar `~/.obsidian-vault/.obsidian/community-plugins.json`:
```json
["obsidian-git"]
```

Abrir Obsidian → Settings → Community plugins → activar Git.

## 5. Plugin Automatic Linker (links automáticos entre notas)

```bash
mkdir -p ~/obsidian-vault/.obsidian/plugins/automatic-linker
```

Descargar de https://github.com/kdnk/obsidian-automatic-linker/releases/latest:
- `main.js`
- `manifest.json`
- `styles.css`

Colocarlos en `~/.obsidian-vault/.obsidian/plugins/automatic-linker/`.

Editar `~/.obsidian-vault/.obsidian/community-plugins.json`:
```json
["obsidian-git", "automatic-linker"]
```

Abrir Obsidian → Settings → Community plugins → activar Automatic Linker.
Convierte automáticamente texto que coincida con títulos de notas en `[[links]]` al guardar.

## 6. PATH

Agregar al `~/.zshrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```
