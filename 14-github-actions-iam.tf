# ============================================================
# GitHub Actions OIDC Provider
# ============================================================

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name = "github-actions-oidc"
  }
}


# ============================================================
# GitHub Actions IAM Role
#
# Repository:
# hwanhee932-pixel/aws-msa-platform
#
# GitHub Immutable OIDC Subject:
# repo:hwanhee932-pixel@233664142/aws-msa-platform@1418576681:ref:refs/heads/main
# ============================================================

resource "aws_iam_role" "github_actions" {
  name = "github-actions-msa-platform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:hwanhee932-pixel@233664142/aws-msa-platform@1418576681:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Name = "github-actions-msa-platform"
  }
}


# ============================================================
# GitHub Actions -> ECR Push Policy
# ============================================================

resource "aws_iam_policy" "github_actions_ecr" {
  name        = "github-actions-msa-platform-ecr"
  description = "Allow GitHub Actions to push MSA images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      # ------------------------------------------------------
      # ECR Login
      # ------------------------------------------------------
      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      # ------------------------------------------------------
      # Push/Pull MSA Images
      # ------------------------------------------------------
      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]

        Resource = [
          "arn:aws:ecr:ap-northeast-2:088923313316:repository/api-gateway",
          "arn:aws:ecr:ap-northeast-2:088923313316:repository/member-service",
          "arn:aws:ecr:ap-northeast-2:088923313316:repository/product-service",
          "arn:aws:ecr:ap-northeast-2:088923313316:repository/order-service",
          "arn:aws:ecr:ap-northeast-2:088923313316:repository/frontend"
        ]
      }
    ]
  })

  tags = {
    Name = "github-actions-msa-platform-ecr"
  }
}


# ============================================================
# Attach ECR Policy to GitHub Actions Role
# ============================================================

resource "aws_iam_role_policy_attachment" "github_actions_ecr" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions_ecr.arn
}


# ============================================================
# Outputs
# ============================================================

output "github_actions_role_arn" {
  description = "IAM Role used by GitHub Actions OIDC"
  value       = aws_iam_role.github_actions.arn
}