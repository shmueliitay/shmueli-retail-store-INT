# Control Plane
resource "aws_instance" "control_plane" {
  ami                    = "ami-0699c78c4486e5f1e"
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k8s.id]
  associate_public_ip_address = true

  user_data = file("../scripts/install_kubeadm.sh")

  tags = merge(local.common_tags, { Name = "${local.resource_prefix}-control-plane" })
}

# Worker Nodes
resource "aws_instance" "workers" {
  count                  = 2
  ami                    = "ami-0699c78c4486e5f1e"
  instance_type          = var.instance_type
  key_name               = var.key_pair
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.k8s.id]
  associate_public_ip_address = true

  user_data = file("../scripts/install_kubeadm.sh")

  tags = merge(local.common_tags, { Name = "${local.resource_prefix}-worker-${count.index + 1}" })
}

