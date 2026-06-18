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
