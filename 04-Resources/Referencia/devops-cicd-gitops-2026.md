---
tags:
  - devops
  - cicd
  - gitops
  - iac
  - Referencia
created: 2026-07-12
---

# DevOps — CI/CD, GitOps, IaC 2026

## DevOps en 2026

Tres cosas simultáneamente:
1. **Cultura**: devs own what they ship, no wall between dev/ops
2. **Toolchain**: Linux → Git → CI/CD → Docker → K8s → Cloud → Terraform → Observability
3. **Práctica**: continuous delivery con feedback loops

## CI/CD Pipeline

```
Code Push → Lint → Test → Build → Security Scan → Deploy (staging) → Smoke Test → Deploy (prod)
```

### Best Practices

- **Small batches**: deploy frequency > batch size
- **Feature flags** over feature branches
- **Rolling/Canary/Blue-Green** deploys
- **Automated rollback** on health check failure
- **SLOs + Error Budgets**: halt deploys when budget exhausted

### Progressive Delivery

```yaml
# Canary deploy example
apiVersion: flagger.app/v1beta1
kind: Canary
spec:
  analysis:
    interval: 1m
    threshold: 5
    maxWeight: 50
    stepWeight: 10
```

## GitOps

**Git = single source of truth.** Controller watches Git, reconciles live state.

```
Developer → Git Push → Controller (ArgoCD/Flux) → Apply to Cluster
```

### IaC vs GitOps

| Aspecto | IaC | GitOps |
|---------|-----|--------|
| Define | Infrastructure | Operational model |
| Applies | Manual or CI | Continuous reconciliation |
| Rollback | Manual | Automatic from Git |
| Audit | Logs | Git history |
| Recovery | Re-run scripts | Re-apply Git state |

### MTTR Improvement

- Traditional: 44 min avg
- GitOps: 11 min avg (with reconciliation)

### Tools

| Tool | Type | Mejor para |
|------|------|------------|
| Terraform | IaC provisioning | Cloud infrastructure |
| Pulumi | IaC (code) | Teams that prefer real languages |
| Ansible | Config management | Server provisioning |
| ArgoCD | GitOps controller | Kubernetes |
| Flux | GitOps controller | Lightweight K8s |
| Crossplane | GitOps infra | K8s-native provisioning |

## Infrastructure as Code

```hcl
# Terraform example
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "app-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

### IaC Rules

1. Everything in version control
2. Modular code: reusable modules
3. State management: remote state (S3 + DynamoDB)
4. Plan before apply
5. Policy as code: OPA/Conftest
6. Automated testing for infra

## Platform Engineering (2026)

El nivel más maduro de DevOps:
- **Internal Developer Platforms (IDPs)**
- Golden paths para deploy, DB provisioning, monitoring
- Self-service via config files o UI
- Abstraction de infra complexity

## Observability

```
Metrics (Prometheus) + Logs (Loki/ELK) + Traces (Jaeger/Tempo)
```

- Structured logging: JSON con correlation IDs
- Distributed tracing across microservices
- Dashboards que muestren cost + velocity
- Alerting basado en SLOs, no thresholds arbitrarios

## DORA Metrics

| Métrico | Elite | High | Medium | Low |
|---------|-------|------|--------|-----|
| Deploy frequency | On demand | Weekly | Monthly | < monthly |
| Lead time | < 1 day | 1 day - 1 week | 1 week - 1 month | > 1 month |
| MTTR | < 1 hour | < 1 day | 1 day - 1 week | > 1 week |
| Change failure rate | 0-15% | 16-30% | 16-30% | > 30% |

## Security (Shift-Left)

- SAST/DAST en CI pipeline
- Container scanning (Trivy, Snyk)
- Secret scanning (gitleaks, trufflehog)
- SBOM generation
- Supply chain security (SLSA framework)
