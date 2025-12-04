locals {
  resource_prefix = "shmueli"
  common_tags = {
    Owner = "shmueli"
    Project = "kubeadm-cluster"
  }
  bootstrap_script = file("${path.module}/../scripts/kubernetes_cluster_bootstrap.sh")
}

