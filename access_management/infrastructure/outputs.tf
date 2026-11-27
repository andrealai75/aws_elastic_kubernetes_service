output "cluster_creator_set_context" {
  value = "aws eks update-kubeconfig --name ${local.cluster_name}"
}

output "access_context_entries" {
  value = [
    for name, config in local.roles : {
      role_arn = aws_iam_role.all[name].arn
      set_context_command = "aws eks update-kubeconfig --name ${local.cluster_name} --profile ${name} --alias ${name} --user-alias ${name}"
    }
  ]
}
