variable "name" {
  description = "Welltory"
  type        = string
  default     = "welltory"
}

variable "aws_region" {
  description = "AWS Region Name"
  type        = string
}

variable "global_env" {
  description = "Environment Name: nonprod or prod"
  type        = string
}


variable "vpc" {
  description = "VPC Configuration"
  type        = object({
    cidr = string
    azs = list(string)
    private_subnets = list(string)
    public_subnets = list(string)
  })
}

variable "kube" {
  description = "Kubernetes cluster configuration."
  type        = object({
    cluster_version             = number
  })
}

variable "autoscaler" {
  description = "Autoscaler configuration."
  type        = object({
    helm_chart_version = string
  })
}

variable "aws_node_termination_handler" {
  description = "aws_node_termination_handler configuration."
  type        = object({
    helm_chart_version = string
  })
}

variable "metrics_server" {
  description = "Metrics server configuration."
  type        = object({
    helm_chart_version = string
  })
}

variable "users" {
  type = map(object({
    name        = string
  }))
}