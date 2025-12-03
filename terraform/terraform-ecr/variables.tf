variable "aws_region" {
  description = "AWS region to create ECR repositories in"
  type        = string
  default     = "eu-central-1"
}

variable "repositories" {
  description = "List of ECR repositories to create"
  type        = list(string)
  default = [
    "retail-store-ui",
    "retail-store-catalog",
    "retail-store-cart",
    "retail-store-orders",
    "retail-store-checkout"
  ]
}

