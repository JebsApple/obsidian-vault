---
name: "Fable 5 Prompting Methodology"
description: "Use when applying Fable 5 prompting methodology for AI interactions. Triggers: Fable prompting, Fable skills, abogado del diablo, chequeo seguridad, fable arranque, fable plan. Skip if unrelated to structured AI prompting."
user-invocable: false
---

# Fable 5 Prompting Methodology

## Domain
Structured prompting methodology (Fable 5) for AI-assisted development, providing repeatable workflows for common tasks like security checks, project kickoff, planning, and code review.

## Core Concepts
- **Fable 5 Skills**: Reusable prompting patterns for specific AI-assisted tasks
- **Fable 5 Prompting Principles**: Core design principles behind effective Fable prompts
- **Fable 5 Manuals**: Reference documentation for Fable 5 methodology and usage
- **Fable Chequeo de Seguridad**: Security review workflow — systematic security audit prompting pattern
- **Fable Arranque**: Project kickoff workflow — structured project initialization prompts
- **Fable Plan**: Planning workflow — step-by-step project planning prompting pattern
- **Fable Abogado del Diablo**: Devil's advocate workflow — critical review and challenge prompts
- **Fable Fixer**: Bug fixing workflow — systematic debugging and repair prompts

## Key Relationships
- Fable 5 Prompting Principles → guides → all Fable skills (foundational)
- Fable 5 Skills → referenced_by → Fable 5 Manuals (documentation)
- Fable Arranque → precedes → Fable Plan (project lifecycle order)
- Fable Plan → followed_by → Fable Fixer (planning to implementation)
- Fable Abogado del Diablo → validates → Fable Plan (review gate)

## Mental Models
- **Workflow selection**: Match task type to specific Fable skill (security→Chequeo, startup→Arranque, planning→Plan, review→Abogado, bugs→Fixer)
- **Composable prompts**: Skills can be combined — Arranque+Plan for new projects, Abogado+Fixer for review cycles
- **Principles-first**: Always ground in Fable 5 principles before applying specific skills

## When NOT to use
- Skip for ad-hoc questions that don't need structured workflow
- Skip for tasks outside software development scope
- Skip when simple direct prompting suffices (one-shot tasks)
