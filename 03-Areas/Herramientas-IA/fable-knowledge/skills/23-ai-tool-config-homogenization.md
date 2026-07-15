---
name: "AI Tool Config & Homogenization"
description: "Use when configuring opencode, Claude Code, or MCP servers, or troubleshooting config issues. Triggers: opencode config, MCP duplicados, Ponytail plugin, NaraRouter provider, homogenization. Skip for general AI usage questions without config context."
user-invocable: false
---

# AI Tool Config & Homogenization

## Domain
Configuration, troubleshooting, and unification of AI coding tools (opencode, Claude Code, Claude Desktop) including MCP server management, plugin setup, and security hardening.

## Core Concepts
- **Memoria Persistente**: Using the Obsidian vault as persistent MCP context for AI agents
- **opencode**: Open-source terminal AI assistant (comparable to Claude Code)
- **obsidian-mcp**: MCP server exposing vault contents to AI tools
- **Plan de Homogenización**: Unify config across Claude Code + Claude Desktop + opencode for token/skill reuse
- **Ponytail**: Anti-over-engineering philosophy for agent-generated code (YAGNI-first ladder)
- **Bug Ponytail roto**: Plugin path in opencode.json pointed to non-existent `~/ponytail/` directory
- **MCPs duplicados**: Each app had its own MCP version/syntax; unified to `npx obsidian-mcp v1.0.6` + Docker github-mcp-wrapper
- **Credenciales texto plano**: GitHub PAT and PostgreSQL passwords found in config files — security risk; PAT removed in Phase 2
- **NaraRouter config**: OpenAI-compatible provider setup in opencode.jsonc (interactive `opencode auth login` writes to wrong provider fields)

## Key Relationships
- opencode ← compared to → Claude Code (feature parity, different config syntax)
- obsidian-mcp → consumed by → opencode + Claude Code + Claude Desktop
- Plan de Homogenización → targets → MCP dedup + credential cleanup + plugin path fix
- Ponytail philosophy → governs → code generation quality (anti-scaffold, stdlib-first)
- NaraRouter → provides → local OpenAI-compatible API endpoint

## Mental Models
- **Config as code**: All AI tool configs should be version-controlled and diffable
- **Single MCP source**: One obsidian-mcp binary, referenced by all tools, never duplicated
- **Credential hygiene**: Never store PATs/passwords in config files; use env vars or secret managers
- **Ponytail ladder**: YAGNI → stdlib → native → existing dep → one line → minimum code

## When NOT to use
- Skip for pure AI prompting questions (no config involvement)
- Skip for MCP server development (use mcp-builder skill instead)
- Skip for general security review without config context
