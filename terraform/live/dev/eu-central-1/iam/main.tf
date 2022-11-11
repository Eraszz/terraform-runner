################################################################################
# Set required providers and version
################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.68.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">=2.2.0"
    }
  }
  required_version = ">=1.1.2"
}

provider "aws" {
  region = "eu-central-1"
}


resource "aws_iam_user_policy_attachment" "this" {
  user       = "crm-performance-data-ro"
  policy_arn = aws_iam_policy.this.arn
}


resource "aws_iam_policy" "this" {
  name        = "lambda-invoke-test"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.lambda_invoke.json
}

data "aws_iam_policy_document" "lambda_invoke" {
  statement {

    actions = [
      "lambda:InvokeFunction",
      "apigateway:POST"
    ]

    resources = [
      "*"
    ]
  }
}
