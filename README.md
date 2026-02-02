This version is what hiring managers and senior engineers actually read.
No storytelling, no diary tone, just signal.

Parlay Analyzer — Production Deployment Architecture

This repository demonstrates a production-grade deployment system built on AWS EKS using Helm, ALB Ingress, and GitHub Actions.

The focus is on safe rollouts, deterministic traffic control, and failure containment.

Core Capabilities

Canary deployments for application-level changes

Blue/Green deployments for environment-level safety

Deterministic environment cutovers

CI-enforced deployment guardrails

Zero manual kubectl changes in production

Deployment Model

Traffic behavior is controlled via an explicit deployment mode:

deploymentMode: stable | canary | cutover


stable — 100% traffic to the stable service

canary — weighted traffic between stable and canary

cutover — atomic Blue/Green environment switch (canary disabled)

Active environment is controlled via:

activeEnv: blue | green


Rollbacks are instant by reverting values and re-running Helm.

CI Safety Controls

The CI pipeline enforces:

Canary blocked during cutover

ALB ingress annotations JSON-validated before deployment

Deployment intent validated before Helm runs

This prevents partial rollouts and misconfigured ingress rules.

Key Files

charts/parlay-analyzer/ingress.yaml — traffic routing logic

charts/parlay-analyzer/values.yaml — deployment intent

.github/workflows/deploy.yaml — CI/CD and guardrails