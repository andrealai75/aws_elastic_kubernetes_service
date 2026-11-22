locals {
  vpc_cidr     = "10.0.0.0/16"
  azs          = slice(data.aws_availability_zones.available.names, 0, 2)
  cluster_name = "eks"
  tags = {
    Name        = local.cluster_name
    ClusterName = local.cluster_name
    Repository  = var.project
    ManagedBy   = "Terraform"
  }
}