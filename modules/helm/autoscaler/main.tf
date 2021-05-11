module "get_autoscaler_tag" {
  source  = "matti/resource/shell"
  environment = {
    version = var.cluster_version
  }
  command = "curl https://api.github.com/repos/kubernetes/autoscaler/releases | jq -r '.[] | .tag_name' | grep $version | head -1 | cut -d \"-\" -f3"
}

resource "helm_release" "autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.helm_chart_version
  namespace  = "kube-system"
  atomic     = true

  values = [templatefile("${path.module}/values.yaml", {
    region              = var.region
    cluster_name        = var.cluster_name
    tag                 = module.get_autoscaler_tag.stdout
  })]

}