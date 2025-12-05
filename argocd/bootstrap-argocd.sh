#!/bin/bash
set -e

AWS_REGION="eu-central-1"
AWS_ACCOUNT_ID="630019796862"
ECR_SERVER="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "=== 🟦 STEP 1: Create ArgoCD namespace ==="
kubectl create namespace argocd || true

echo "=== 🟦 STEP 2: Install ArgoCD ==="
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "=== 🟦 STEP 3: Patch ArgoCD API server to NodePort ==="
kubectl patch svc argocd-server -n argocd \
  -p '{"spec": {"type": "NodePort"}}'

echo "=== 🟦 STEP 4: Install Ingress-NGINX ==="
kubectl apply \
  -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/cloud/deploy.yaml

echo "=== 🟦 STEP 5: Create ECR pull secret ==="
aws ecr get-login-password --region ${AWS_REGION} \
  | kubectl create secret docker-registry ecr-reg \
      --docker-server="${ECR_SERVER}" \
      --docker-username=AWS \
      --docker-password-stdin \
      --namespace default || true

echo "=== 🟦 STEP 6: Patch default service account to use imagePullSecrets ==="
kubectl patch serviceaccount default \
  -p '{"imagePullSecrets": [{"name": "ecr-reg"}]}' \
  -n default || true

echo "=== 🟦 STEP 7: Apply ArgoCD Applications from your repo ==="
# Clone the Git repo to read ArgoCD manifests locally
rm -rf /tmp/shmueli-retail-store-INT || true
git clone https://github.com/shmueliitay/shmueli-retail-store-INT.git /tmp/shmueli-retail-store-INT

echo "Applying all ArgoCD applications from argocd/applications/ ..."
kubectl apply -n argocd -f /tmp/shmueli-retail-store-INT/argocd/applications/

echo "=== 🟩 INSTALLATION COMPLETE ==="
echo "=== 🟦 ArgoCD UI NodePort ==="
kubectl -n argocd get svc argocd-server

echo ""
echo "=== 🟦 Initial admin password ==="
kubectl -n argocd \
  get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo

