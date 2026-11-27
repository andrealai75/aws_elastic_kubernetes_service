locals {
  cluster_name = "eks"
  account_id   = data.aws_caller_identity.current.account_id
  tags = {
    Name        = local.cluster_name
    ClusterName = local.cluster_name
    Repository  = var.project
    ManagedBy   = "Terraform"
  }
  roles = {
    "PaymentsDeveloper" = {
      cluster_policies_arns  = []
      kubernetes_groups = ["PaymentsDeveloper"]
    }
    "SecurityAuditor" = {
      cluster_policies_arns = ["arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"]
      kubernetes_groups     = []
    }
    "GitHubActionsDeploy" = {
      cluster_policies_arns = ["arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"]
      kubernetes_groups     = []
    }
    "FullAdministrator" = {
      cluster_policies_arns = ["arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"]
      kubernetes_groups     = []
    }
  }
  policy_associations = flatten([
    for name, config in local.roles : [
      for policy in config.cluster_policies_arns : {
        role_arn   = aws_iam_role.all[name].arn
        policy_arn = policy
      }
    ]
  ])
}
