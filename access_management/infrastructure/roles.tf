resource "aws_iam_role" "all" {
  for_each = local.roles
  name     = "${local.cluster_name}-${each.key}"

  assume_role_policy = data.aws_iam_policy_document.payments_developer_trust.json
}

data "aws_iam_policy_document" "payments_developer_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "read_only" {
  for_each   = aws_iam_role.all
  role       = each.value.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
