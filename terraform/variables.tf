variable "aws_region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "key_pair" {
  description = "SSH key pair name for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.medium"
}

variable "public_cidr" {
  description = "CIDR for public subnet"
  default     = "0.0.0.0/0"
}
