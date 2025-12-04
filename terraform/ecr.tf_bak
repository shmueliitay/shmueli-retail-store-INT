# Create multiple ECR repositories
resource "aws_ecr_repository" "retail_store_repos" {
  for_each = toset([
    "retail-store-ui",
    "retail-store-catalog",
    "retail-store-cart",
    "retail-store-orders",
    "retail-store-checkout"
  ])

  name = each.value

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "dev"
    Project     = "retail-store"
  }
}

# IAM user for GitHub Actions
resource "aws_iam_user" "github_actions" {
  name = "github-actions-ecr"
}

# IAM policy for pushing/pulling images to ECR
resource "aws_iam_user_policy" "github_actions_ecr_policy" {
  name = "ECRPushPolicy"
  user = aws_iam_user.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:CreateRepository",
          "ecr:DescribeRepositories"
        ],
        Resource = "*"
      }
    ]
  })
}

# Access key for GitHub Actions
resource "aws_iam_access_key" "github_actions_key" {
  user = aws_iam_user.github_actions.name
}

output "github_actions_access_key_id" {
  value = aws_iam_access_key.github_actions_key.id
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions_key.secret
  sensitive = true
}

output "ecr_repository_urls" {
  value = [for repo in aws_ecr_repository.retail_store_repos : repo.repository_url]
}

