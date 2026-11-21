locals {
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
  project  = "eks"
  tags = {
    Name       = local.project
    Repository = var.project
    ManagedBy  = "Terraform"
  }
}