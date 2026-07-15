---
name: "Hermes Agent Project"
description: "Use when working with the Hermes autonomous agent runtime, LLM routing, Telegram bots, or serverless agent deployment. Triggers: Hermes agent, Nous Research, Gemini API, Groq fallback, Oracle Cloud, Modal serverless, Claude Code bridge. Skip if unrelated to autonomous agents."
user-invocable: false
---

# Hermes Agent Project

## Domain
Autonomous agent runtime project using Nous Research models with multi-provider LLM fallback (Gemini → Groq), Telegram bot interface, deployed on Oracle Cloud Free Tier with Modal serverless backend and Claude Code CLI bridge.

## Core Concepts
- **Hermes Agent Runtime**: Core autonomous agent process. Planned architecture documented in blueprint and README.
- **Nous Research**: MIT-licensed models powering the agent. Primary model provider.
- **Multi-provider fallback**: Gemini API (primary) → Groq (fallback). Cost and availability redundancy.
- **Telegram Bot**: User interaction channel. Agent receives commands and responds via Telegram.
- **Oracle Cloud Free Tier**: ARM 2 OCPU / 12GB RAM. Hosting the agent runtime at zero cost.
- **Modal serverless**: Backend compute with $30/mo credit. Used for bursty or GPU tasks.
- **hermes-code-bridge**: Bridge between Hermes agent and Claude Code CLI. Enables Claude Code as a subagent.
- **Claude Code CLI**: Pro subscription. Invoked via bridge for complex coding tasks the agent delegates.

## Key Relationships
- Plan de Instalación → references → all infrastructure components (Gemini, Groq, Oracle, Modal, Telegram, Claude Code)
- Hermes Agent → references → Nous Research (model dependency)
- hermes-code-bridge → conceptually_related_to → Claude Code CLI (bridge wraps CLI)
- Backlog → implements → Plan de Instalación (work items track the plan)
- README → references → Plan de Instalación (docs reference architecture)

## Mental Models
- **Provider fallback chain**: Primary (Gemini) fails → fallback (Groq) picks up. Agent never stops responding.
- **Free-tier-first**: Oracle Cloud for always-on, Modal for bursts. Zero cost until scale demands otherwise.
- **Bridge pattern**: Agent doesn't run Claude Code directly — a bridge mediates, keeping concerns separated.

## When NOT to use
- Skip for simple chatbot projects (Hermes is autonomous, not request-response only).
- Skip for projects using only one LLM provider (the multi-provider pattern is central).
- Skip for projects without agent autonomy requirements.
