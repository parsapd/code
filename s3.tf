resource "aws_s3_bucket" "s3" {
  bucket = "pras-bala-bucket"

  tags = {
    Name        = "pras-bala-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_s3" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "pras-bala-log-bucket"
}

resource "aws_s3_bucket_logging" "s3logging" {
  bucket = aws_s3_bucket.s3.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket" "statefilebucket" {
  bucket = "terraform-state-file-prasabala"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_policy" "allow_access_for_another_account" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.allow_access_for_another_account.json
}

data "aws_iam_policy_document" "allow_access_for_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::591948016557:user/tfadmin"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.s3.arn,
      "${aws_s3_bucket.s3.arn}/*",
    ]
  }
}