resource "aws_iam_role" "roles" {
  for_each = toset(local.roles)
  name = "${local.cluster_name}-${each.value}"

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

resource "aws_iam_role_policy_attachment" "describes" {
  for_each   = aws_iam_role.roles
  role       = each.value.name
  policy_arn = aws_iam_policy.describe.arn
}
