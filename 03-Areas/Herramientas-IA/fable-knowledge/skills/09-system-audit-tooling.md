---
name: "System Audit & Tooling"
description: "Use when configuring AI assistants, custom scripts, or system tooling. Triggers: Hyprland scripts, Waybar daemon, OpenCode config, OpenCode sandbox, Claude Code, CLAUDE.md, subagents, parallel worktrees, Plan Mode. Skip for general Linux system admin."
user-invocable: false
---

# System Audit & Tooling

## Domain
Custom system tooling (Hyprland scripts, Waybar hover daemon), AI assistant configuration (Claude Code, OpenCode, CLAUDE.md), and workflow patterns (plan mode, subagents, parallel worktrees, plugins/skills marketplace).

## Core Concepts
- **Hyprland Scripts**: custom keybinding scripts for Wayland compositor automation
- **Waybar Hover Daemon**: custom daemon for Waybar module hover-expand behavior
- **OpenCode Sandbox**: isolated testing environment for MCP servers and plugins before production deployment
- **Backup OpenCode Config**: automated backup/restore for OpenCode configuration files
- **Claude Code Workflows**: Plan Mode (think before act), Subagents (decomposed tasks), Parallel Worktrees (concurrent branches)

## Key Relationships
- CLAUDE.md → defines → agent behavior, project conventions, skill triggers
- OpenCode Sandbox → protects → production config from experimental MCP/plugin failures
- Parallel Worktrees → enable → concurrent subagent execution without merge conflicts
- Plan Mode → gates → implementation (explore → plan → execute)
- Claude Plugins Marketplace + Superpowers + claude-mem → extend → base Claude Code capabilities

## Mental Models
- **Sandbox before production**: always test MCP/plugin changes in sandbox first, then promote
- **Plan → Execute**: plan mode forces exploration before committing to implementation approach
- **Config as code**: CLAUDE.md, opencode.json, and custom scripts are version-controlled system state
- **Plugin discovery**: skill-repos + marketplace + skill-creator form a plugin ecosystem pipeline

## When NOT to use
- Skip for homelab infrastructure patterns (see Homelab Infrastructure skill)
- Skip for MiNegocio project-specific tooling (see MiNegocio Team & Knowledge skill)
