name       = "welltory"
aws_region = "us-east-1"
global_env = "prod"

vpc = {
  cidr            = "10.130.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.130.1.0/24", "10.130.2.0/24", "10.130.3.0/24"]
  public_subnets  = ["10.130.11.0/24", "10.130.12.0/24", "10.130.13.0/24"]
}

kube = {
  cluster_version = 1.19
}

aws_node_termination_handler = {
  helm_chart_version = "0.15.0"
}

metrics_server = {
  helm_chart_version = "5.8.7"
}

autoscaler = {
  helm_chart_version = "9.9.2"
}


users = {
    john = {
        name = "john"
    },
    mary = {
        name = "mary"
    },
    carl = {
        name = "carl"
    }
}