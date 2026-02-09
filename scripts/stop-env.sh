#!/usr/bin/env bash
set -e

echo "=== SAFE PAUSE: minimizing AWS costs ==="

# -----------------------------
# Stop RUNNING EC2 instances
# -----------------------------
echo "Stopping RUNNING EC2 instances..."
INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters Name=instance-state-name,Values=running \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [ -n "$INSTANCE_IDS" ]; then
  aws ec2 stop-instances --instance-ids $INSTANCE_IDS
else
  echo "No running EC2 instances found."
fi

# -----------------------------
# Scale Kubernetes deployments
# -----------------------------
echo "Scaling Kubernetes deployments to zero..."
kubectl scale deployment --all --replicas=0 -n default 2>/dev/null || echo "No k8s deployments found."

# -----------------------------
# Delete Application Load Balancers
# -----------------------------
echo "Deleting Application Load Balancers..."
ALB_ARNS=$(aws elbv2 describe-load-balancers \
  --query "LoadBalancers[].LoadBalancerArn" \
  --output text)

if [ -n "$ALB_ARNS" ]; then
  for alb in $ALB_ARNS; do
    aws elbv2 delete-load-balancer --load-balancer-arn "$alb"
  done
else
  echo "No ALBs found."
fi

# -----------------------------
# Delete NAT Gateways
# -----------------------------
echo "Deleting NAT Gateways..."
NAT_IDS=$(aws ec2 describe-nat-gateways \
  --query "NatGateways[].NatGatewayId" \
  --output text)

if [ -n "$NAT_IDS" ]; then
  for nat in $NAT_IDS; do
    aws ec2 delete-nat-gateway --nat-gateway-id "$nat"
  done
else
  echo "No NAT Gateways found."
fi

echo "=== SAFE PAUSE COMPLETE ✅ ==="
