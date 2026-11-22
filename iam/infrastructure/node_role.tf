resource "aws_iam_role" "node" {
  name = "${local.cluster_name}-node"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "node_policies" {
  for_each = toset(local.node_role_policies)
  name     = each.value
}

resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each   = toset(local.node_role_policies)
  role       = aws_iam_role.control_plane.name
  policy_arn = data.aws_iam_policy.node_policies[each.key].arn
}
