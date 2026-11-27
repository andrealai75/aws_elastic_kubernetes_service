data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "current" {
  name = local.cluster_name
}
