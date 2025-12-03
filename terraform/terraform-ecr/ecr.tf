# Create ECR repositories
resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repositories)

  name = each.value

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Project = "retail-store"
    ManagedBy = "Terraform"
  }
}

# Create IAM user for GitHub Actions
resource "aws_iam_user" "github_actions" {
  name = "github-actions-ecr"
}

# Attach ECR policy to the IAM user
resource "aws_iam_user_policy" "ecr_policy" {
  name = "GitHubActionsECRPolicy"
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

# Optional: create an access key for GitHub Actions
resource "aws_iam_access_key" "github_actions_key" {
  user = aws_iam_user.github_actions.name
}

