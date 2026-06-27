---
tags: [herramienta, ecc, claude-code, configuracion, ia]
updated: 2026-06-27
---

# ECC — Engineering Code Companion (Instalado)

ECC es un framework de harness para agentes IA. Provee reglas, skills, agentes y hooks que se inyectan en Claude Code para mejorar la calidad del trabajo de desarrollo.

- **Repositorio:** https://github.com/affaan-m/ECC.git
- **Docs:** https://ecc.tools
- **Instalado:** 2026-06-27
- **Ubicacion local del repo:** `/home/icin/ECC/`
- **Target:** `claude` (global, `~/.claude/`)
- **Perfil:** `full` (todos los modulos)

---

## Como se instalo

```bash
git clone https://github.com/affaan-m/ECC.git ~/ECC
cd ~/ECC
npm install --no-audit --no-fund
bash install.sh --target claude --profile full
```

El instalador copio 827 archivos a `~/.claude/` organizados en:
- `~/.claude/rules/ecc/` — reglas de codigo por lenguaje
- `~/.claude/skills/ecc/` — skills invocables con `/nombre-skill`
- `~/.claude/agents/` — agentes especializados adicionales
- `~/.claude/hooks/` — hooks de runtime
- `~/.claude/ecc/install-state.json` — estado de instalacion

---

## Como actualizar

```bash
cd ~/ECC
git pull
bash install.sh --target claude --profile full
```

---

## Skills destacados instalados (167 total)

### Lenguajes y frameworks
`golang-patterns`, `python-patterns`, `rust-patterns`, `vue-patterns`, `react-patterns`, `django-patterns`, `fastapi-patterns`, `springboot-patterns`, `kotlin-patterns`

### Testing y calidad
`tdd-workflow`, `e2e-testing`, `golang-testing`, `react-testing`, `verification-loop`, `eval-harness`, `ai-regression-testing`

### Seguridad
`security-review`, `security-scan`, `security-bounty-hunter`, `django-security`, `laravel-security`

### Agentes y orquestacion
`team-agent-orchestration`, `autonomous-loops`, `continuous-agent-loop`, `council`, `claude-devfleet`

### DevOps
`docker-patterns`, `deployment-patterns`, `github-ops`, `dmux-workflows`

### IA / LLMs
`cost-aware-llm-pipeline`, `cost-tracking`, `prompt-optimizer`, `deep-research`, `token-budget-advisor`

### Bases de datos
`postgres-patterns`, `database-migrations`, `prisma-patterns`, `mysql-patterns`

---

## Como usar un skill

En cualquier sesion de Claude Code:

```
/nombre-del-skill
```

Ejemplo:
```
/golang-patterns
/security-review
/tdd-workflow
```

---

## Nota para instancias AI

Al iniciar una sesion en esta maquina (`/home/icin/`), ECC ya esta activo globalmente. Las reglas y skills estan disponibles automaticamente. No es necesario instalar nada adicional.

Si el MCP de Obsidian no responde, clonar el vault directamente:
```bash
git clone https://github.com/jebsapple/obsidian-vault.git /tmp/obsidian-vault
```
Y leer los archivos desde `/tmp/obsidian-vault/Projects/MiNegocio/Registro/` para el estado actual del proyecto.

## Ver tambien
- [[agentes]] — Agentes del proyecto MiNegocio (c-back, c-front, c-db, etc.)
- [[conexion-remota]] — SSH a Gitea, config MCP
- [[MiNegocio]] — Estado actual del proyecto
