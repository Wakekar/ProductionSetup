#!/bin/bash
set -xe

# -----------------------
# BASIC SETUP
# -----------------------
apt update -y
apt install -y containerd curl apt-transport-https

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# -----------------------
# INSTALL KUBERNETES
# -----------------------
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/k8s.gpg

echo "deb [signed-by=/etc/apt/keyrings/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" > /etc/apt/sources.list.d/k8s.list

apt update -y
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# -----------------------
# INIT CLUSTER
# -----------------------
kubeadm init --pod-network-cidr=192.168.0.0/16

# -----------------------
# KUBECTL SETUP
# -----------------------
mkdir -p /home/ubuntu/.kube
cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
chown ubuntu:ubuntu /home/ubuntu/.kube/config

# -----------------------
# CALICO NETWORK
# -----------------------
su - ubuntu -c "kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml"

# -----------------------
# INSTALL HELM
# -----------------------
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# -----------------------
# INGRESS CONTROLLER
# -----------------------
su - ubuntu -c "kubectl create namespace ingress-nginx"

su - ubuntu -c "helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx"
su - ubuntu -c "helm repo update"

su - ubuntu -c "helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx"

# -----------------------
# SAVE JOIN COMMAND
# -----------------------
kubeadm token create --print-join-command > /home/ubuntu/join.sh
chown ubuntu:ubuntu /home/ubuntu/join.sh
