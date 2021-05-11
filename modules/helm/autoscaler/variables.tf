variable "region" {
    type = string
}

variable "helm_chart_version" {
  description = "Helm chart version"
  type        = string
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "cluster_version" {
  description = "K8s cluster version"
  type        = number
}