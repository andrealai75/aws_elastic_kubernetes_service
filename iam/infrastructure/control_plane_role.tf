resource "aws_iam_role" "control_plane" {
  name = "${local.cluster_name}-control-plane"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "amazon_eks_cluster" {
  name = "AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster" {
  role       = aws_iam_role.control_plane.name
  policy_arn = data.aws_iam_policy.amazon_eks_cluster.arn
}
