resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "10.18.3"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
}

resource "helm_release" "argocd_bootstrap" {
  name       = "argocd-bootstrap"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.2"
  namespace  = "argocd"

  values = [
    yamlencode({
      applications = {
        cluster-bootstrap = {
          namespace = "argocd"
          project   = "default"
          source = {
            repoURL        = "https://github.com/andrealai75/aws_eks_gitops_config_argocd.git"
            targetRevision = "main"
            path           = "namespaces"
            directory = {
              recurse = true
            }
          }
          destination = {
            server = "https://kubernetes.default.svc"
          }
          syncPolicy = {
            automated = {
              prune    = true
              selfHeal = true
            }
          }
        }
      }
    })
  ]

  depends_on = [helm_release.argocd]
}
