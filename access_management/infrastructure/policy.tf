resource "aws_iam_policy" "describe" {
  name = "${local.cluster_name}-describe"

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
