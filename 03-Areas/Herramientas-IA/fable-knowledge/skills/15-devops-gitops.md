---
name: "DevOps & GitOps"
description: "Use when working with CI/CD, deployment pipelines, infrastructure automation, or agile methodologies. Triggers: CI/CD, GitOps, Terraform, ArgoCD, Scrum, DORA metrics. Skip if unrelated to DevOps or software delivery."
user-invocable: false
---

# DevOps & GitOps

## Domain
DevOps practices covering CI/CD pipelines, infrastructure as code, GitOps workflows, and agile delivery frameworks. References the DORA four-key metrics model for measuring software delivery performance.

## Core Concepts
- **CI/CD Pipeline**: Automated build → test → deploy flow. DORA metrics measure its effectiveness (deploy frequency, lead time, MTTR, change failure rate).
- **GitOps**: Git as single source of truth for infrastructure. ArgoCD syncs cluster state from Git repos.
- **Infrastructure as Code (IaC)**: Terraform for declarative infra provisioning. State files are the critical artifact.
- **Shift-Left Security**: Security checks integrated early in pipeline, not at deploy gate.
- **Platform Engineering**: Internal developer platforms that abstract infra complexity from product teams.
- **Agile/Scrum**: Sprint-based delivery. MoSCoW prioritization for backlog. User stories as atomic work units.
- **Nielsen Heuristics**: 10 usability principles for UI quality gates alongside technical quality.

## Key Relationships
- CI/CD Pipeline → conceptually_related_to → DORA Metrics (pipeline health = DORA scores)
- GitOps → references → ArgoCD (GitOps implementation)
- Infrastructure as Code → references → Terraform (IaC tool)
- GitOps → conceptually_related_to → Infrastructure as Code (IaC enables GitOps)
- Platform Engineering → references → GitOps (platform team owns GitOps workflow)
- Shift-Left Security → references → CI/CD Pipeline (security in pipeline)
- Scrum → references → Agile Manifesto (framework derives from manifesto)
- User Stories → references → Scrum + MoSCoW (story sizing and prioritization)

## Mental Models
- **DORA metrics as vitals**: Deploy frequency + lead time + MTTR + change failure rate = pipeline health dashboard.
- **Git as control plane**: Infrastructure changes flow through PRs → review → merge → auto-sync. No manual kubectl.
- **Shift-left = cheaper**: Fixing security at commit is 100x cheaper than fixing in production.

## When NOT to use
- Skip for pure frontend work without deployment concerns.
- Skip for data science notebooks or one-off scripts (CI/CD overhead not justified).
- Skip for hardware/embedded projects where IaC doesn't apply.
