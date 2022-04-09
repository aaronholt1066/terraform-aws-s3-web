data "aws_iam_policy_document" "allow_access" {
  
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${var.prefix}-${var.name}/*"
    ]
  }
}
