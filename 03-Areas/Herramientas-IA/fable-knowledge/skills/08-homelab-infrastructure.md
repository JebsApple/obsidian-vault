---
name: "Homelab Infrastructure"
description: "Use when planning self-hosted services, infrastructure architecture, or security hardening. Triggers: homelab, Proxmox, self-hosted, backup rule, hardening, hexagonal architecture, event sourcing, CQRS, microservices. Skip for application-specific bugs or Obsidian vault topics."
user-invocable: false
---

# Homelab Infrastructure

## Domain
Self-hosted infrastructure patterns: Proxmox VE virtualization, 3-2-1 backup strategy, Linux hardening, and software architecture patterns (EDA, CQRS, hexagonal, event sourcing, saga, microservices) plus UI/UX design principles.

## Core Concepts
- **3-2-1 Backup Rule**: 3 copies, 2 media types, 1 offsite — foundation of homelab data safety
- **Proxmox VE**: type-1 hypervisor for running VMs/containers on homelab hardware
- **Linux Hardening**: security checklist for exposed services (firewall, SSH, updates, audit logs)
- **Architecture Patterns**: Hexagonal (ports/adapters), CQRS (read/write separation), Event Sourcing (audit trail), Saga (distributed transactions), Event-Driven (loose coupling)
- **Software Quality**: SOLID principles (SRP, OCP, DIP), maintainability, reliability, security (CIA), scalability, usability

## Key Relationships
- Proxmox VE → hosts → Minecraft Server Docker + other self-hosted services
- 3-2-1 Rule → guides → backup strategy for all homelab data
- Hexagonal Architecture → enables → testing ports independently from adapters
- CQRS + Event Sourcing → complement → each other for audit-heavy domains
- SOLID → constrains → code quality across all services

## Mental Models
- **Defense in depth**: hardening layers (network → OS → app → data) — each layer independent
- **Pattern selection**: hexagonal for new services, CQRS when read/write ratios diverge, event sourcing when audit matters, saga when spanning multiple services
- **Quality attributes trade-off**: you can't maximize all six (maintainability, reliability, security, scalability, usability, performance) — pick what your domain demands

## When NOT to use
- Skip for MiNegocio-specific deployment (that's project infra, not homelab patterns)
- Skip for AI assistant configuration (see System Audit & Tooling skill)
