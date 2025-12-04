# Create multiple ECR repositories
resource "aws_ecr_repository" "retail_store_repos" {
  for_each = toset([
    "retail-store-ui",
    "retail-store-catalog",
    "retail-store-cart",
    "retail-store-orders",
    "retail-store-checkout"
  ])

 # name = each.value
name = "${local.resource_prefix}-${each.value}"

  image_scanning_configuration {
    scan_on_push = true
  }

tags = merge(local.common_tags, { Name = "${local.resource_prefix}-${each.value}" })

#  tags = {
#    Environment = "dev"
#    Project     = "retail-store"
#  }
}
