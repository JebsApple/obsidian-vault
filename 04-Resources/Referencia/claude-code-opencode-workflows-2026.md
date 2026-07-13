---
tags:
  - claude-code
  - ai-agents
  - opencode
  - productivity
  - Referencia
created: 2026-07-12
---

# Claude Code — Tips & Workflows 2026

## The 5 Highest-ROI Changes

1. **CLAUDE.md real** — Stack, commands, architecture, gotchas, conventions
2. **Custom slash commands** — Repeated prompts → reusable
3. **Plan mode** — Anything touching >2 files
4. **Subagents** — Parallel independent work
5. **Diff review** — Every diff before commit

## CLAUDE.md Mastery

### 10-Section Template

```markdown
## Project Overview
[What this project does in 2 sentences]

## Architecture
[Key directories, why they exist]

## Build & Run Commands
npm run dev          # start dev server (port 3000)
npm test             # run unit tests
npm run lint         # ESLint check

## Tech Stack
- Next.js 15 + TypeScript
- Postgres via Prisma
- Tailwind CSS

## Code Conventions
- Components: PascalCase, one per file
- Functions: camelCase
- Files: kebab-case

## Gotchas
- Migrations auto-generated — never hand-edit
- Secrets in .env (gitignored)

## Testing
- Unit: Vitest
- E2E: Playwright
- Coverage minimum: 80%

## Git Workflow
- Branches: feature/*, fix/*, chore/*
- Commits: conventional commits
- PR: require 1 review

## Performance
- API responses < 200ms target
- Lazy load below fold

## External References
@docs/api-spec.md
@docs/deployment.md
```

### Tips avanzados

- **Imports**: `@path/to/file` para mantener CLAUDE.md < 100 palabras
- **Subdirectory CLAUDE.md**: `src/api/CLAUDE.md` para convenciones específicas
- **Global**: `~/.claude/CLAUDE.md` para preferencias personales
- **Update immediately** when Claude makes the same mistake twice

## Plan Mode

```
Shift+Tab → Plan mode
# Claude analiza, propone approach
# Tú revisas, ajustas
# Then build mode implements
```

- Opus 4.5 + thinking para problemas difíciles
- `/effort max` para debugging complejo
- Un Claude planifica, otro revisa (dual-agent pattern)

## Parallel Sessions con Git Worktrees

```bash
# Create worktree
git worktree add ../feature-a feature-a
git worktree add ../feature-b feature-b

# Session 1
cd ../feature-a && opencode

# Session 2
cd ../feature-b && opencode
```

- 3-5 sesiones en paralelo
- `/batch` para migraciones grandes
- `/branch` para fork de sesión

## Session Management

- **Compact early**: context degradado = 18 min vs 4.5 min fresh
- **/compact** antes de que auto-compact dispare
- **Checkpoints**: revert with `/rewind`
- **Resume**: `opencode --resume` para continuar sesión anterior

## Hooks & Automation

```json
// .claude/settings.json
{
  "hooks": {
    "post-edit": "npm run lint --fix",
    "pre-commit": "npm test",
    "post-command": "echo 'Command completed'"
  }
}
```

## Subagents

- Delegar investigación a subagentes en paralelo
- Investigator: busca código
- Builder: edita archivos
- Reviewer: revisa diffs
- Contract-first spawning para manejar dependencias

## Cost Control

| Modelo | Uso | Costo relativo |
|--------|-----|----------------|
| Haiku | Exploration, simple edits | $ |
| Sonnet | General coding | $$ |
| Opus | Hard problems, architecture | $$$ |

- Use cheap models for exploration
- Reserve Opus para problemas que lo requieren
- Monitor token usage

## OpenCode — El Alternativo Open Source

- 120K+ GitHub stars, 7.5M monthly active devs
- Terminal-first, 75+ model providers
- LSP integration (type-safe refactoring)
- Parallel agents
- Plan/Build modes
- BYOK (Bring Your Own Key) — Ollama for local models

### Setup rápido

```bash
curl -fsSL https://opencode.ai/install | bash
opencode auth login
opencode
```

### OpenCode vs Claude Code

| Feature | OpenCode | Claude Code |
|---------|----------|-------------|
| Price | Free (pay API) | $20-200/mo |
| Models | Any provider | Claude only |
| LSP | Deep integration | No |
| Parallel agents | Yes | Yes |
| Privacy | Local-first | Cloud |
| Git integration | Good | Basic |
| TUI | Polished | Basic |

## Anti-patterns

- "Implement the whole feature" → break into steps
- Fixing bugs yourself → let Claude learn context
- Skipping plan mode on multi-file changes
- Not reading diffs before commit
- Ignoring CLAUDE.md updates
