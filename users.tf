resource "aws_iam_user" "users" {
  for_each = var.users

  name = each.value.name
  path = "/"

}