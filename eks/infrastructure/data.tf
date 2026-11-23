data "aws_caller_identity" "current" {}

data "aws_iam_role" "control" {
  name = "${local.cluster_name}-control-plane"
}

data "aws_iam_role" "node" {
  name = "${local.cluster_name}-node"
}

data "aws_subnets" "all" {
  filter {
    name   = "tag:ClusterName"
    values = [local.cluster_name]
  }
}

data "aws_subnets" "privates" {
  filter {
    name   = "tag:ClusterName"
    values = [local.cluster_name]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}