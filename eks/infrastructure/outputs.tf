output "subnet_id" {
  value = data.aws_subnets.all.ids
}

output "public_access_cidrs" {
  value = var.public_access_cidrs
}

output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "next_step" {
  value = "aws eks update-kubeconfig --name ${local.cluster_name}"
}
