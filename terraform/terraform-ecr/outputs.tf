output "ecr_repository_urls" {
  value = { for name, repo in aws_ecr_repository.repos : name => repo.repository_url }
}

output "github_actions_access_key_id" {
  value     = aws_iam_access_key.github_actions_key.id
  sensitive = true
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions_key.secret
  sensitive = true
}

