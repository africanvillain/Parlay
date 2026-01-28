# Canary Rollout Proof — Parlay Analyzer

## Overview
This document proves a live canary deployment using **AWS ALB weighted routing**
with **Kubernetes Services**.

Traffic is split between:
- **Stable** → v1
- **Canary** → v2

Routing is handled at the **Ingress (ALB)** level using weighted target groups.

---

## Architecture
- EKS cluster
- AWS Load Balancer Controller
- One Ingress
- Two Services:
  - `parlay-analyzer-stable`
  - `parlay-analyzer-canary`
- Two Deployments:
  - Stable → image tag `v1`
  - Canary → image tag `v2`

---

## Canary Configuration
```yaml
canary:
  enabled: true
  weight: 10
