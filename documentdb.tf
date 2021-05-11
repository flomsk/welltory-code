module "docdb_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/mongodb"
  version = "~> 4.0"

  name        = "${var.global_env}-docdb-access"
  description = "Security group for access DocumentDB within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
}

resource "random_password" "password" {
  depends_on = [aws_iam_user.users]

  for_each = var.users

  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_docdb_subnet_group" "this" {
  depends_on = [aws_iam_user.users]

  for_each = var.users

  name       = "${var.name}-${each.value.name}-subnetgroup"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_docdb_cluster_instance" "this" {
  depends_on = [aws_iam_user.users]

  for_each = var.users

  identifier         = "${var.name}-${each.value.name}-docdb-instance"
  cluster_identifier = aws_docdb_cluster.this[each.key].id
  instance_class     = "db.r5.large"
}

resource "aws_docdb_cluster" "this" {
  depends_on = [aws_iam_user.users]

  for_each = var.users

  skip_final_snapshot     = true
  db_subnet_group_name    = aws_docdb_subnet_group.this[each.key].name
  cluster_identifier      = "${var.name}-${each.value.name}-docdb-cluster"
  engine                  = "docdb"
  master_username         = each.value.name
  master_password         = random_password.password[each.key].result
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this[each.key].name
  vpc_security_group_ids = [module.docdb_security_group.security_group_id]

  storage_encrypted = true

}

resource "aws_docdb_cluster_parameter_group" "this" {
  depends_on = [aws_iam_user.users]

  for_each = var.users

  family = "docdb4.0"
  name = "${var.name}-${each.value.name}-paramgroup"

  parameter {
    name  = "tls"
    value = "enabled"
  }
}