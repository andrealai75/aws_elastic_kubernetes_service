output "subnet_id" {
  value = data.aws_subnets.all.ids
}

output "public_access_cidrs" {
  value = var.public_access_cidrs
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  value = aws_eks_cluster.main.version
}

output "node_group_name" {
  value = aws_eks_node_group.default.node_group_name
}

output "update_kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${local.cluster_name}"
}
