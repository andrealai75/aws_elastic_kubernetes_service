resource "aws_iam_role" "developer" {
  name = "${local.cluster_name}-developer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS : "arn:aws:iam::${local.account_id}:root"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "developer" {
  name = "${local.cluster_name}-developer"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "eks:DescribeCluster*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "developer" {
  role       = aws_iam_role.developer.name
  policy_arn = aws_iam_policy.developer.arn
}

resource "aws_iam_group" "developers" {
  name = "developers"
}

resource "aws_iam_policy" "developer_assume_roles" {
  name = "${local.cluster_name}-developer-assume-roles"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.developer.arn
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "developer_assume_roles" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_assume_roles.arn
}

resource "aws_iam_user" "john_developer" {
  name = "luke-developer"
}

resource "aws_iam_group_membership" "developer" {
  name = "developers"

  users = [
    aws_iam_user.john_developer.name
  ]

  group = aws_iam_group.developers.name
}
