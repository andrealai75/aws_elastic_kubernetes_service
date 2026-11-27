resource "aws_eks_access_entry" "all" {
  for_each          = aws_iam_role.roles
  cluster_name      = data.aws_eks_cluster.current.name
  principal_arn     = aws_iam_role.all[each.key].arn
  type              = "STANDARD"
  kubernetes_groups = local.roles[each.key].value.kubernetes_groups
}

resource "aws_eks_access_policy_association" "cluster_policies" {
  for_each = local.policy_associations

  cluster_name  = data.aws_eks_cluster.current.name
  principal_arn = each.role_arn
  policy_arn    = each.policy_arn

  access_scope {
    type = "cluster"
  }
}
