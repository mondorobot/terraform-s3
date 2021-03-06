variable "name" {}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}"
  acl = "public-read"
  force_destroy = "true"
}

resource "aws_iam_user" "s3" {
    name = "${var.name}-s3"
}

resource "aws_iam_access_key" "s3" {
    user = "${aws_iam_user.s3.name}"
}

resource "aws_iam_user_policy" "s3_policy" {
    name = "${var.name}-s3-policy"
    user = "${aws_iam_user.s3.name}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${var.name}",
        "arn:aws:s3:::${var.name}/*"
      ]
    }
  ]
}
EOF
}

output "iam_access_key_id" {
  value = "${aws_iam_access_key.s3.id}"
}
output "iam_access_key_secret" {
  value = "${aws_iam_access_key.s3.secret}"
}
