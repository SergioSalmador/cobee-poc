# ADR-02: Latency Strategy (< 100 ms)

Date: 2026-03-07
Status: Accepted

## Goal
Keep end-user API latency below 100 ms for common requests.

## Strategy

## 1. Place compute close to users
- ES traffic in EU region.
- MX traffic in a region close to Mexico.

Reason:
Network distance is one of the biggest latency factors.

## 2. Keep traffic inside private network
- App in private subnets.
- Database in private subnets.
- Direct VPC path from app to RDS.

Reason:
Fewer hops and better performance.

## 3. Scale before overload
- HPA based on CPU and memory.
- Minimum replicas to avoid cold starts after spikes.

Reason:
When pods are overloaded, response time grows fast.

## 4. Use readiness/liveness probes
- Send traffic only to healthy pods.
- Restart broken pods fast.

Reason:
Avoid slow or broken backends in the load balancer target set.

## 5. Optimize DB usage
- Keep indexes updated.
- Avoid N+1 queries.
- Use connection pooling for PostgreSQL.

Reason:
Database calls are often the main source of latency.

## 6. Observe and improve continuously
- Track p50, p95, p99 latency.
- Track DB query time and saturation.
- Use alerting on latency SLO breaches.

Reason:
Without metrics, we cannot control latency over time.

## Target Budget Diagram

<img src="./diagrams/latency-budget.svg" alt="Latency budget diagram" width="1200" />
