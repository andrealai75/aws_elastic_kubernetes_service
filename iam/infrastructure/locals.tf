locals {
  cluster_name = "eks"
  tags = {
    Name        = local.cluster_name
    ClusterName = local.cluster_name
    Repository  = var.project
    ManagedBy   = "Terraform"
  }

  node_role_policies = [
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryPullOnly"
  ]
}