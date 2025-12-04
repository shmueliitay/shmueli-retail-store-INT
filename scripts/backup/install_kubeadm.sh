#!/bin/bash
set -e

# Determine if we are root; if not, use sudo
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  SUDO="sudo"
fi

# Update packages
$SUDO apt-get update
$SUDO apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
$SUDO curl -fsSL https://get.docker.com | $SUDO sh
$SUDO usermod -aG docker ubuntu
$SUDO systemctl enable docker
$SUDO systemctl start docker

# Install kubeadm, kubelet, kubectl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | $SUDO apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > $SUDO tee  /etc/apt/sources.list.d/kubernetes.list
$SUDO apt-get update
$SUDO apt-get install -y kubelet kubeadm kubectl
$SUDO apt-mark hold kubelet kubeadm kubectl

# Disable swap
$SUDO swapoff -a
$SUDO sed -i '/ swap / s/^/#/' /etc/fstab

