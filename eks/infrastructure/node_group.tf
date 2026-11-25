resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.cluster_name}-default"
  node_role_arn   = data.aws_iam_role.node.arn
  subnet_ids      = data.aws_subnets.privates.ids

  instance_types = ["t3.small", "t3a.small", "t3.medium", "t3a.medium"]
  capacity_type  = "SPOT"

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
