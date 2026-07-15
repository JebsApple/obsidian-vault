---
name: "Archived Sprints"
description: "Use when reviewing MiNegocio sprint history, audit findings, or post-mortem analysis. Triggers: sprint audit, Ponytail audit, STL revert, smoke test, deuda técnica, sprint 2 retrospective. Skip if working on current features."
user-invocable: false
---

# Archived Sprints

## Domain
Historical sprint archives for MiNegocio: per-developer deliverables (S2), audit reports, a post-disaster revert plan, and accumulated technical debt documentation. Read-only reference for lessons learned.

## Core Concepts
- **Sprint 2 deliverables**: Ignacio → POS (S2-HU02), Nicolás → Barcode+Inventory (S2-HU01), Victor → Images+Gallery (S2-HU04).
- **Ponytail Audit S2/S3**: Line-by-line code reviews. S3 audit references and expands on S2 findings.
- **STL Revert Plan**: Post-deployment rollback plan after STL-Redesign caused prod issues. Includes execution report.
- **Smoke Test PROD**: Production verification checklist run 2026-06-19. Semantically similar to Sprint 2 client presentation.
- **Deuda Técnica**: Accumulated technical debt register. Shares data with both Ponytail audits (debt identified during reviews).
- **JWT Analysis**: Gabriel's JWT + frontend session analysis. Feeds into the JWT refactor work in Community 16.
- **Dev-Prod Parity Fixes**: Environment parity issues discovered and resolved.
- **Jenkins CI/CD Setup**: Build pipeline configuration for the project.

## Key Relationships
- Ponytail Audit S3 → references → Ponytail Audit S2 (sequential audits, S3 builds on S2)
- Deuda Técnica → shares_data_with → both Ponytail Audits (debt discovered in audits)
- Sprint 2 deliverables → all reference → STL Revert Plan (post-merge consequences)
- Presentación Sprint 2 → references → all three developer deliverables (client demo compiled from S2 work)
- Smoke Test PROD → semantically_similar_to → Presentación Sprint 2 (both verify S2 output)

## Mental Models
- **Audit → debt → fix cycle**: Ponytail audit finds issues → deuda técnica registers them → sprints prioritize fixes.
- **Revert = learning**: The STL revert plan isn't failure documentation — it's the process for safe recovery when deploys go wrong.
- **Smoke test as gate**: Production smoke test is the final checkpoint before declaring a sprint shippable.

## When NOT to use
- Skip for active development on new features (these are historical records).
- Skip unless doing a retrospective, post-mortem, or debt planning session.
- Skip for projects other than MiNegocio.
