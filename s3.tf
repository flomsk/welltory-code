resource "aws_s3_bucket" "bucket" {

  depends_on = [aws_iam_user.users]

  for_each = var.users

  bucket = "${var.name}-${each.value.name}-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  policy = <<EOF
{
   "Id":"bucketPolicy",
   "Statement":[
      {
         "Action":"s3:*",
         "Effect":"Deny",
         "NotPrincipal":{
            "AWS":[
               "${aws_iam_user.users[each.key].arn}"
            ]
         },
         "Resource":[
            "arn:aws:s3:::${var.name}-${each.value.name}-bucket",
            "arn:aws:s3:::${var.name}-${each.value.name}-bucket/*"
         ]
      }
   ],
   "Version":"2012-10-17"
}
EOF

  lifecycle_rule {
    prefix  = "/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
}