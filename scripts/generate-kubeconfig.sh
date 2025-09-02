#!/bin/bash
# Генерация kubeconfig для GitLab Runner

SERVER="https://$(terraform -chdir=terraform output -raw k8s_master_public_ip):6443"
NAMESPACE=${1:-default}

kubectl create serviceaccount gitlab-ci -n $NAMESPACE 2>/dev/null || true
kubectl create clusterrolebinding gitlab-ci-$NAMESPACE \
  --clusterrole=edit \
  --serviceaccount=$NAMESPACE:gitlab-ci 2>/dev/null || true

SECRET_NAME=$(kubectl get serviceaccount gitlab-ci -n $NAMESPACE -o jsonpath='{.secrets[0].name}')
TOKEN=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath='{.data.token}' | base64 -d)
CA_CERT=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o jsonpath='{.data.ca\.crt}')

cat <<EOF >gitlab-kubeconfig.yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: $CA_CERT
    server: $SERVER
  name: k8s-cluster
contexts:
- context:
    cluster: k8s-cluster
    namespace: $NAMESPACE
    user: gitlab-ci
  name: k8s-context
current-context: k8s-context
kind: Config
users:
- name: gitlab-ci
  user:
    token: $TOKEN
EOF

echo "Kubeconfig generated: gitlab-kubeconfig.yaml"
echo "Base64 for GitLab variable:"
cat gitlab-kubeconfig.yaml | base64 -w0
echo ""
