resource "aws_eks_cluster" "main" {
  name = local.cluster_name

  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = data.aws_iam_role.control.arn
  version  = "1.37"

  bootstrap_self_managed_addons = false

  upgrade_policy {
    support_type = "STANDARD"
  }

  vpc_config {
    subnet_ids = data.aws_subnets.all[*].id

    endpoint_private_access = true
    endpoint_public_access  = true

    public_access_cidrs = [var.public_access_cidrs]
  }
}
