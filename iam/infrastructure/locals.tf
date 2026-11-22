locals {
  cluster_name = "eks"
  tags = {
    Name       = local.cluster_name
    Repository = var.project
    ManagedBy  = "Terraform"
  }
}