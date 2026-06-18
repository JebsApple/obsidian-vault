---
tags: [guia, configuracion, remoto, sync, linux, vpn]
---

# Conectar al vault desde otros equipos / sesiones remotas

El vault está en `C:\Users\Victor\ObsidianVault` (Windows). Para usarlo desde Linux (otra partición) y servidor remoto via VPN:

## Opción recomendada: Git + GitHub privado

### Setup inicial (Windows, ya hecho)
```bash
cd /mnt/c/Users/Victor/ObsidianVault
git init
git add -A
git commit -m "init vault"
gh repo create obsidian-vault --private --push --source=.
```

### Linux (otra partición)
```bash
cd ~
git clone https://github.com/<tu>/obsidian-vault.git ObsidianVault
# Configurar MCP apuntando a ~/ObsidianVault
```

### Servidor remoto (via VPN)
```bash
git clone https://github.com/<tu>/obsidian-vault.git ObsidianVault
# Misma config MCP, ruta local del clon
```

### Sincronizar cambios después
```bash
cd ObsidianVault
git add -A && git commit -m "update" && git push
# En la otra máquina:
git pull
```

## Alternativa: Syncthing (P2P, sin nube, multiplataforma)
1. Instala Syncthing en Windows, Linux, y el servidor remoto
2. Crea una carpeta compartida apuntando a `ObsidianVault`
3. Los 3 equipos se sincronizan en tiempo real cuando están conectados (via VPN para el remoto)
4. En cada máquina, configura el MCP server apuntando a su copia local

## Alternativa: Partición compartida (Windows ↔ Linux dual boot)
Si tienes una partición NTFS compartida entre Windows y Linux:
```bash
# En Windows: C:\Users\Victor\ObsidianVault
# En Linux: /mnt/windows/Users/Victor/ObsidianVault
# Ambos apuntan al MISMO disco físico, sin sync necesario
```

## SSH a Gitea (para agentes AI)

Gitea corre en `192.168.50.28:22`. Hay una clave SSH dedicada sin passphrase para que agentes (opencode, Claude Code) hagan git push/pull/clone.

### Setup (una sola vez)
```bash
# 1. Generar clave sin passphrase
ssh-keygen -t ed25519 -f ~/.ssh/id_gitea -N "" -C "opencode-gitea"

# 2. Configurar ~/.ssh/config
cat >> ~/.ssh/config << 'EOF'

Host gitea
    HostName 192.168.50.28
    Port 22
    User git
    IdentityFile ~/.ssh/id_gitea
    IdentitiesOnly yes
EOF

# 3. Mostrar clave pública para agregar en Gitea
cat ~/.ssh/id_gitea.pub
```

### Agregar clave en Gitea
1. Ir a http://192.168.50.28:3000/user/settings/keys
2. "Add Key" → pegar `id_gitea.pub`
3. Si pide firma, copiar el token y ejecutar:
   ```bash
   echo -n "<TOKEN>" | ssh-keygen -Y sign -f ~/.ssh/id_gitea -n "gitea"
   ```
   Pegar la firma en Gitea.

### Verificar conexión
```bash
ssh -T git@gitea
# Debería responder: "Hi there, VHerrera! You've successfully authenticated..."
```

### Usar SSH en remotos git
```bash
# Ejemplo para cambiar un repo de HTTP a SSH:
git remote set-url origin git@gitea:VHerrera/MiNegocio-frontend.git
```

### Notas
- La clave `~/.ssh/id_gitea` **no tiene passphrase** — puede usarse desde scripts y agentes sin TTY
- El host `gitea` en SSH config resuelve a `192.168.50.28`
- Los agentes AI pueden usar `git@gitea` como remote en lugar de HTTP+token

## Config MCP en cada máquina

### [[opencode]].jsonc (~/.config/[[opencode]]/[[opencode]].jsonc)
```jsonc
{
  "mcp": {
    "obsidian": {
      "type": "local",
      "command": ["npx", "-y", "obsidian-mcp", "/ruta/al/vault"],
      "enabled": true
    }
  }
}
```

### Claude Code (settings.json o claude mcp add)
```bash
claude mcp add obsidian -- npx -y obsidian-mcp /ruta/al/vault
```

## Nota importante
El MCP server `obsidian-mcp` accede al vault directamente desde el disco local en cada máquina. No hay servidor central. Cada equipo necesita su copia local del vault + su propia config MCP. Usa git o Syncthing para mantener las copias sincronizadas.
