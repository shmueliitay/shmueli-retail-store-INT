output "control_plane_public_ip" {
  value = aws_instance.control_plane.public_ip
}

output "worker_public_ips" {
  value = [for w in aws_instance.workers : w.public_ip]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

