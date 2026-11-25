locals {
  cluster_name = "eks"
  account_id   = data.aws_caller_identity.current.account_id
  tags = {
    Name        = local.cluster_name
    ClusterName = local.cluster_name
    Repository  = var.project
    ManagedBy   = "Terraform"
  }
}