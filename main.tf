provider "aws" {    
  profile = "hurou"
}

variable "region" {
    type = "string"
    default = "ap-northeast-1"
    description = "AWS region"
}


variable "service" {
  type        = "string"
  default     = "srvdef"
  description = "service name"
}

variable "stage" {
  type        = "string"
  default     = "stgdef"
  description = "stage name"
}

resource "aws_iam_role" "role0" {
  name                 = "${var.stage}-${var.service}-lambda-terraform-role"
  path                 = "/"
#   permissions_boundary = "arn:aws:iam::902887174334:policy/PermissionBoundaryForRoles"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "role_policy0" {
  name = "${var.stage}-${var.service}-lambda-terraform-policy"
  role = "${aws_iam_role.role0.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:*",
                "dynamodb:*",
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}



output "service" {
  value = "${var.service}"
}

output "stage" {
  value = "${var.stage}"
}
output "IAMRoleARN" {
  value = "${aws_iam_role.role0.arn}"
}