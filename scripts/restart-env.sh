#!/usr/bin/env bash
set -e

echo "=== RESTART ENVIRONMENT ==="

# -----------------------------
# Recreate infra via Terraform
# -----------------------------
echo "Rehydrating infrastructure with Terraform..."
terraform -chdir=infra/envs/dev apply -auto-approve

# -----------------------------
# Restart EC2 instances
# -----------------------------
echo "Starting STOPPED EC2 instances..."
INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters Name=instance-state-name,Values=stopped \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [ -n "$INSTANCE_IDS" ]; then
  aws ec2 start-instances --instance-ids $INSTANCE_IDS
else
  echo "No stopped EC2 instances found."
fi

# -----------------------------
# Restore Kubernetes workloads
# -----------------------------
echo "Restoring Kubernetes deployments..."
kubectl scale deployment --all --replicas=1 -n default 2>/dev/null || echo "No k8s deployments found."

echo "=== ENVIRONMENT RESTORED ✅ ==="
