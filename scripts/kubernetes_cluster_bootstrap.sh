#!/bin/bash
set -e

NODE_ROLE="$1"        # control-plane or worker
CONTROL_PLANE_IP="$2" # required for worker nodes

# ----------------------------
# Install prerequisites
# ----------------------------
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker

# Install kubeadm, kubelet, kubectl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# ----------------------------
# Control Plane
# ----------------------------
if [ "$NODE_ROLE" == "control-plane" ]; then
    echo "Initializing Kubernetes control-plane..."
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 > /tmp/kubeadm_init.log

    # Set up kubeconfig for ubuntu user
    mkdir -p /home/ubuntu/.kube
    sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
    sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config

    # Apply Flannel CNI
    sudo -u ubuntu kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

    # Save join command to file
    JOIN_CMD=$(grep "kubeadm join" /tmp/kubeadm_init.log | tail -1)
    echo "$JOIN_CMD --ignore-preflight-errors=all" | sudo tee /tmp/join_command.sh
    sudo chmod +x /tmp/join_command.sh

    echo "Control-plane ready!"
fi

# ----------------------------
# Worker Node
# ----------------------------
if [ "$NODE_ROLE" == "worker" ]; then
    echo "Waiting for control-plane to be ready..."

    # wait for join command to exist on control-plane
    while ! nc -zv $CONTROL_PLANE_IP 22 >/dev/null 2>&1; do
        echo "Control-plane SSH not ready yet..."
        sleep 5
    done

    # Copy join command from control-plane via SSH
    sudo scp -o StrictHostKeyChecking=no ubuntu@$CONTROL_PLANE_IP:/tmp/join_command.sh /tmp/join_command.sh

    # Join the cluster
    sudo bash /tmp/join_command.sh
    echo "Worker joined the cluster!"
fi

