resource "aws_iam_role" "platform_admin" {
  name = "${local.cluster_name}-platform-admin"

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

resource "aws_iam_policy" "platform_admin_describe" {
  name = "${local.cluster_name}-platform-admin-describe"

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

resource "aws_iam_role_policy_attachment" "platform_admin" {
  role       = aws_iam_role.platform_admin.name
  policy_arn = aws_iam_policy.platform_admin_describe.arn
}

resource "aws_iam_group" "platform_admins" {
  name = "platform-admins"
}

resource "aws_iam_policy" "platform_admin_assume_roles" {
  name = "${local.cluster_name}-platform-admin-assume-roles"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = aws_iam_role.platform_admin.arn
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "platform_admin_assume_roles" {
  group      = aws_iam_group.platform_admins.name
  policy_arn = aws_iam_policy.platform_admin_assume_roles.arn
}

resource "aws_iam_user" "john_platform_admin" {
  name = "john-platform-admin"
}

resource "aws_iam_group_membership" "platform_admins" {
  name = "platform-admins"

  users = [
    aws_iam_user.john_platform_admin.name
  ]

  group = aws_iam_group.platform_admins.name
}
