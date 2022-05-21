resource "aws_s3_bucket" "bucket" {
  bucket = "${var.prefix}-${var.name}"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.bucket

    index_document {
      suffix = "index.html"
    }
    error_document {
      key = "error.html"
    }
routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket_website_configuration.bucket.id
  acl    = "public-read"
}


resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket_website_configuration.bucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}


resource "aws_s3_object" "webapp" {
  acl          = "public-read"
  key          = "index.html"
  bucket       = aws_s3_bucket_website_configuration.bucket.id
  content      = file("${path.module}/assets/index.html")
  content_type = "text/html"
}
