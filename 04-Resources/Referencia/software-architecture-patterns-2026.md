---
tags:
  - arquitectura
  - software
  - microservices
  - event-driven
  - Referencia
created: 2026-07-12
---

# Software Architecture Patterns 2026

## Patrones Principales

### 1. Monolito Modular
- **Cuándo**: MVP, equipos pequeños (<5 devs), domain no clarificado
- **Ventaja**: Deploy simple, debug directo, low ops overhead
- **Riesgo**: Acoplamiento si no se separan módulos por domain

### 2. Microservices
- **Cuándo**: Equipos múltiples, scaling independiente, tech heterogéneo
- **Ventaja**: Deployment independiente, fault isolation
- **Riesgo**: Complejidad operacional, distributed transactions, network failures

### 3. Event-Driven Architecture (EDA) — El patrón dominante de 2026

```mermaid
Producer → Broker (Kafka/NATS/SQS) → Consumer 1
                                    → Consumer 2
                                    → Consumer 3
```

**Componentes:**
- **Producers**: publican eventos (OrderPlaced, UserSignedUp)
- **Brokers**: Kafka, NATS, AWS SNS+SQS, GCP Pub/Sub, EventBridge
- **Consumers**: suscriben y reaccionan independientemente

**Cuándo usar EDA:**
- Sistema con múltiples consumidores independientes
- Reactions asincrónicas (email después de signup, analytics, billing)
- High throughput, need replay/audit
- Decoupling entre domains

**Cuándo NO usar EDA:**
- Request-response simple (frontend asking user profile)
- Sistema pequeño (<5 services)
- Consistency strong requerida (finanzas core)

**Patterns dentro de EDA:**

| Pattern | Descripción |
|---------|-------------|
| Event Sourcing | State = secuencia de eventos, no snapshots |
| CQRS | Separate read/write models |
| Choreography | Services react to events, no central orchestrator |
| Saga | Distributed transactions via event chains |
| Outbox | Guarantee event publication with DB transaction |
| Dead Letter Queue | Failed messages go for investigation |

**Brokers comparison (2026):**

| Broker | Mejor para | Throughput |
|--------|------------|------------|
| Kafka | High throughput, replay, analytics | Millions/sec |
| NATS | Low latency, edge, IoT | Millions/sec |
| AWS SNS+SQS | Managed, AWS ecosystem | Auto-scaled |
| EventBridge | Serverless, routing rules | Moderate |
| Pulsar | Multi-tenant, geo-replication | Millions/sec |

**Key insight:** EDA shifts complexity rather than eliminates it.
From sync coordination → async reasoning.
From API contracts → event semantics.

### 4. CQRS + Event Sourcing
```typescript
// Command side
class OrderCommandHandler {
  placeOrder(cmd: PlaceOrder) {
    const order = Order.place(cmd);  // Creates event
    this.eventStore.append(order.uncommittedEvents);
  }
}

// Query side
class OrderQueryService {
  getOrder(id: string): OrderView {
    return this.projection.get(id);  // Pre-computed view
  }
}
```

### 5. Hexagonal / Ports & Adapters
- Core business logic puro, sin dependencias externas
- Ports = interfaces, Adapters = implementaciones
- Testing fácil: mock adapters
- Ideal para domain-heavy apps

## Decision Framework

```
Team size < 5 && Domain unclear? → Monolito modular
Team size > 5 && scaling needed? → Microservices
Multiple consumers of same events? → EDA
Need audit/replay? → Event Sourcing
Read/write patterns differ? → CQRS
Domain is the star? → Hexagonal
```

## Event Design Rules

1. Name events in past tense: `OrderPlaced` not `PlaceOrder`
2. Events say "this happened" — not "do this"
3. Schema registry essential (Avro, Protobuf, JSON Schema)
4. Partition key matters for ordering
5. Idempotent consumers (at-least-once delivery)
6. Global ordering is a trap — order within partition

## Anti-patterns

- **Distributed monolith**: microservices coupled by sync calls
- **Nano services**: too granular, ops overhead > value
- **Event soup**: too many events, no clear ownership
- **God service**: one service knows everything
