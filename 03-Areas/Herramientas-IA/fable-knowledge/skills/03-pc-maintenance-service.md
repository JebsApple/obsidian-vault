---
name: "PC Maintenance Service"
description: "Use when working with PC cleanup service playbooks, AI coding tooling setup, or MCP server configuration. Triggers: servicio limpieza PC, BleachBit cleanup, ECC framework, Claude Code CLI setup, opencode config, MCP ecosystem, headroom-ai. Skip if unrelated to PC maintenance or AI dev tooling."
user-invocable: false
---

# PC Maintenance Service

## Domain
PC maintenance service business plan (vecinal/on-site) and the AI developer tooling stack (Claude Code, opencode, ECC framework, MCP servers). Two intertwined topics: service delivery playbook and personal dev environment setup.

## Core Concepts
- **Service Playbook**: Audit → Clean (BleachBit) → Optimize (Autoruns) → Optional Linux install (Mint/Zorin) → Report
- **AI Tooling Stack**: Claude Code CLI + Claude Desktop + opencode + ECC framework + MCP ecosystem
- **MCP Protocol**: Model Context Protocol for extending AI assistants with external tools (n8n, Dagu, Packet Tracer, GitHub)
- **ECC Framework**: Engineering Code Companion — skills, hooks, and agent patterns for Claude Code
- **Context Management**: headroom-ai (compression), claude-mem (persistent memory), opencode-dcp (context pruning)

## Key Relationships
- `opencode` → executes → service playbook scripts on-site via terminal
- `ECC framework` → provides → skills/hooks/agents that extend Claude Code capabilities
- `MCP ecosystem` → connects → external services (n8n automation, Dagu workflows, Packet Tracer labs)
- `disk-full (95-96%)` → causes → MCP failures and system lag (root cause analysis lesson)
- `CLAUDE.md` + `AGENTS.md` → configure → per-project AI assistant behavior

## Mental Models
- **Tool-augmented service delivery**: AI assistant with MCP tools can run audits and generate reports on-site, reducing manual steps
- **Config sprawl risk**: Multiple AI tools (Claude Code, Desktop, opencode) need unified config — homogenization prevents drift
- **Disk space as systemic root cause**: Full disk silently breaks MCP servers, git operations, and Docker — check first when diagnosing lag

## When NOT to use
- Skip for MiNegocio development tasks (use sprint-specific knowledge instead)
- Skip for general Linux system administration (use distro docs instead)
