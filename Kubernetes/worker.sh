#!/bin/bash
set -xe

apt update -y
apt install -y containerd curl apt-transport-https

swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/k8s.gpg

echo "deb [signed-by=/etc/apt/keyrings/k8s.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" > /etc/apt/sources.list.d/k8s.list

apt update -y
apt install -y kubelet kubeadm
apt-mark hold kubelet kubeadm
