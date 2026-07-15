---
name: "MiNegocio Team & Knowledge"
description: "Use when working with the MiNegocio project — team roles, tech stack, sprint history, or deployment. Triggers: MiNegocio, Sprint 2, Sprint 3, Victor Herrera, Gabriel Flores, Ignacio Varela, Nicolás Valdés, Gitea SSH, Jenkins CI. Skip if unrelated to MiNegocio project."
user-invocable: false
---

# MiNegocio Team & Knowledge

## Domain
University project: point-of-sale/inventory system. Go backend, Vue 3 frontend, PostgreSQL 16, deployed via Docker on 192.168.50.25 with nginx reverse proxy and Jenkins CI/CD.

## Core Concepts
- **Team Roles**: c-back (Go backend), c-front (Vue frontend), c-db (PostgreSQL) — each agent owns their layer
- **Tech Stack**: Vue.js 3 + Vite frontend, Go (Golang) backend, PostgreSQL 16, nginx, Docker, Gitea, Jenkins
- **Auth Lessons**: bcrypt password hashing, JWT_SECRET env separation (dev/prod), sesiones table for token revocation
- **Deployment**: Docker multi-arch builds, Jenkins pipeline, Gitea SSH for AI agent access, SonarQube static analysis

## Key Relationships
- Victor Herrera → assigned → bcrypt migration (HU01-T01) + JWT_SECRET (HU01-T02)
- Gabriel Flores → assigned → HU01 bcrypt + JWT tasks
- Nicolás Valdés → assigned → Docker multi-arch + Jenkins pipeline (HU01-T03)
- Ignacio Varela → Sprint 3 contribution + venta FK fix
- Gitea SSH → enables → AI agent remote access (air-verse hot-reload)

## Mental Models
- **Layer ownership**: each agent (c-back/c-front/c-db) owns one stack layer, reducing merge conflicts
- **Dev/Prod parity**: same Docker images, different env vars (JWT_SECRET, DB URLs) — nginx proxies both on same server
- **bcrypt migration path**: plaintext → bcrypt script → verify → deploy — done as HU01 technical debt

## When NOT to use
- Skip for Sprint 3 procedure documents (see MiNegocio S3 Procedures skill)
- Skip for pure architecture patterns unrelated to MiNegocio (see Homelab Infrastructure)
