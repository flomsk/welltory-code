output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
  description = "ARN of created node role"
}