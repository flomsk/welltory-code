resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = var.helm_chart_version
  atomic     = true
  namespace  = "kube-system"

  max_history = 3
  wait        = true

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

}