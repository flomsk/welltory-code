locals {
  kube_cluster_name = "${var.global_env}-${var.name}"
}

resource "aws_eip" "nat" {
  vpc = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name = var.global_env

  cidr = var.vpc.cidr

  azs             = var.vpc.azs
  private_subnets = var.vpc.private_subnets
  public_subnets  = var.vpc.public_subnets

  enable_ipv6          = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  reuse_nat_ips          = true
  external_nat_ip_ids    = aws_eip.nat.*.id

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.kube_cluster_name}"  = "owned"
    "kubernetes.io/role/elb"                             = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.kube_cluster_name}"  = "owned"
    "kubernetes.io/role/internal-elb"                    = "1"
  }

  vpc_tags = {
    Name = var.global_env
  }
}

module "iam" {
  source = "./modules/iam"
}

module "kube" {
  depends_on      = [module.iam]

  source          = "terraform-aws-modules/eks/aws"
  version         = "15.2.0"
  cluster_name    = local.kube_cluster_name
  cluster_version = var.kube.cluster_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa     = true

  cluster_endpoint_public_access = false
  cluster_endpoint_private_access = true
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs = [module.vpc.vpc_cidr_block]

  node_groups = {
    datasciencespot = {
      name             = "datasciencespot"
      iam_role_arn     = module.iam.eks_node_role_arn
      capacity_type    = "SPOT"
      ami_type         = "AL2_x86_64"
      min_capacity     = 1
      desired_capacity = 1
      max_capacity     = 3
      instance_types   = ["c5.large", "c5.xlarge"]
      create_launch_template = true
    }
    datasciencespotgpu = {
      name             = "datasciencespotgpu"
      iam_role_arn     = module.iam.eks_node_role_arn
      capacity_type    = "SPOT"
      ami_type         = "AL2_x86_64"
      min_capacity     = 1
      desired_capacity = 1
      max_capacity     = 3
      instance_types   = ["g4dn.xlarge", "g4dn.2xlarge"]
      create_launch_template = true
    }
  }
}

resource "helm_release" "aws_node_termination_handler" {
  name       = "aws-node-termination-handler"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-node-termination-handler"
  version    = var.aws_node_termination_handler.helm_chart_version
  atomic     = true
  namespace  = "kube-system"

  max_history = 3
  wait        = true

}

module "metrics_server" {
  source = "./modules/helm/metrics_server"

  depends_on = [module.kube]

  helm_chart_version = var.metrics_server.helm_chart_version
}

module "autoscaler" {
  source = "./modules/helm/autoscaler"

  depends_on = [module.kube]

  cluster_name       = module.kube.cluster_id
  cluster_version    = module.kube.cluster_version
  region             = var.aws_region
  helm_chart_version = var.autoscaler.helm_chart_version
}