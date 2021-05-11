# Terraform

### Prerequisites
- [terraform >= 0.14.8](https://github.com/hashicorp/terraform/releases)
- [awscli v2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
- [kubectl](https://kubernetes.io/ru/docs/tasks/tools/install-kubectl/)
- [jq](https://stedolan.github.io/jq/download/) and [yq](https://github.com/mikefarah/yq)
- [helm >3.2](https://github.com/helm/helm/releases)

---

### Provide necessary credentials

- `export AWS_PROFILE=PROFILENAME`

---

### Remote state

You can setup remote state on `versions.tf` file.

---

### What does this module do

It creates:

1. IAM users in account
2. VPC
3. EKS with CPU and GPU Spot instances.
4. S3 Bucket for each user with restricted policy.
5. DocumentDB cluster for each user. (**TBD: IAM Auth**)
6. Cloudwatch alarms on S3 BytesDownload metric and DocDB NetworkTransmitThroughput metric. (**TBD: Correct dimensions**)

---

### Working with infrastructure

1. Setup `terraform.tfvars`.
2. (Optional) Make sure you specified correct bucket in `versions.tf` in `backend "s3"` map.
3. Check your installation with `terraform plan`
4. If everything works for you - `terraform apply`

---