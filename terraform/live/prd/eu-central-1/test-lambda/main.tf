################################################################################
# set local variables and tags
################################################################################

locals {
  required_tags = {
    Stage       = var.stage
    Region      = var.region
    Project     = var.project
    Application = var.application
    Module      = var.module
    Owner       = var.owner
    Purpose     = var.purpose
    Version     = var.app_version
  }

  old_required_tags = {
    Environment = var.stage
    Region      = var.region
    Project     = var.project
    Application = var.application
    Module      = var.module
    Owner       = var.owner
    Purpose     = var.purpose
    Version     = var.app_version
    Name        = "test"
  }

  lambda_prefix = "${local.required_tags.Project}-${local.required_tags.Application}-test-lambda"

}


################################################################################
# Get VPC ID
################################################################################

data "aws_vpc" "this" {
  tags = {
    service = var.stage
  }
}


################################################################################
# Get List of private Subnet IDs for VPC
################################################################################

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  filter {
    name   = "tag:Tier"
    values = ["*Private*"]
  }
}



# ################################################################################
# # Lambda Request Handler
# ################################################################################

# module "lambda_proxy" {

#   source = "git::ssh://gitlab@git.meinestadt.de/itbetrieb/terraform/modules/lambda.git?ref=0.1.2"

#   function_name = local.lambda_prefix
#   role          = module.iam_role_lambda_proxy.role_arn

#   filename         = data.archive_file.lambda_proxy.output_path
#   handler          = "index.lambda_handler"
#   source_code_hash = data.archive_file.lambda_proxy.output_base64sha256

#   timeout     = 30
#   memory_size = 128

#   vpc_config = {
#     security_group_ids = [module.sg_lambda_proxy.security_group_id]
#     subnet_ids         = data.aws_subnets.private.ids
#   }

#   layers = ["arn:aws:lambda:eu-central-1:336392948345:layer:AWSSDKPandas-Python38:1"]

#   required_tags = local.required_tags
# }

# data "archive_file" "lambda_proxy" {
#   type        = "zip"
#   source_dir  = "${path.module}/src/"
#   output_path = "${path.module}/zip/python.zip"
# }


# ################################################################################
# # IAM role module for lambda execution role
# ################################################################################

# module "iam_role_lambda_proxy" {
#   # tflint-ignore: terraform_module_pinned_source
#   source = "git::ssh://gitlab@git.meinestadt.de/itbetrieb/terraform/modules/iam.git"

#   role_settings = [
#     {
#       name                    = local.lambda_prefix
#       assume_role_policy_file = "${path.module}/iam/assume.json"
#       role_policy_file        = "${path.module}/iam/lambda_permissions.json"
#       tags                    = {}
#     }
#   ]
# }


# ################################################################################
# # Lambda Security Group
# ################################################################################

# module "sg_lambda_proxy" {

#   # tflint-ignore: terraform_module_pinned_source
#   source  = "git::ssh://gitlab@git.meinestadt.de/itbetrieb/terraform/modules/security-groups.git"
#   sg_name = local.lambda_prefix
#   stage   = var.stage
#   egress_rule = [
#     {
#       from_port                = 0
#       to_port                  = 0
#       protocol                 = -1
#       cidr_blocks              = ["0.0.0.0/0"]
#       description              = "Security Group for the API-Interface Lambda Proxies"
#       source_security_group_id = null
#       self                     = false

#     }
#   ]
# }


################################################################################
# RDS Credentials
################################################################################


# resource "aws_secretsmanager_secret" "this" {
#   name = "bi-aurora-rds-postgresql-secret"
# }


# resource "aws_secretsmanager_secret_version" "this" {
#   secret_id     = aws_secretsmanager_secret.this.id
#   secret_string = <<EOF
#   {
#     "username": "bi",
#     "password": "MmtHLXX8BiT38uYY",
#     "engine": "postgres",
#     "host": "bi-common-production.cluster-csh3u0vcvuec.eu-central-1.rds.amazonaws.com",
#     "port": 5432,
#     "dbClusterIdentifier": "bi-common-production"
#   }
#   EOF
# }



# ################################################################################
# # Get List of private Subnet IDs for VPC
# ################################################################################

# data "aws_subnets" "public" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.this.id]
#   }
#   filter {
#     name   = "tag:Tier"
#     values = ["*Public*"]
#   }
# }


# ################################################################################
# # Bastion Host for RDS Integration
# ################################################################################

# module "rds_bastion" {
#   source = "git@github.com:celver-AG/terraform-aws-ec2-instance?ref=0.1.6"

#   instance_type          = "t2.micro"
#   ami                    = "ami-070b208e993b59cea"
#   subnet_id              = data.aws_subnets.public.ids[0]
#   vpc_security_group_ids = [module.sg_rds_bastion.id]

#   root_block_device = {
#     volume_size           = 8
#     volume_type           = "gp2"
#     encrypted             = true
#     delete_on_termination = true
#   }

#   associate_public_ip_address = true

#   public_key_configuration = {
#     public_key_name = "rds_bastion"
#     public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDibSNjepjJ+GJIWcyNPQiYlPj0knuLyCryND/dvbI38VnJnoLdxIMJNw0VDJhS8fsl1fUK/StPXxKYLu9KBOZLhujDQAOjUT9byWcnx5ESVSfv22xHDw1fL79yrSIsXNg65RRkXdI/ALUWN+ObyEBZhfFQljSC7TwRW2DBYAlYQ6iZ9fBlHq4bObyTv+6byWobw3WPl80OolceIt8Tt86V3jSCTTyObx/1a/kND/i6mwTnTSnbw6OkNJWTnsST+ezQIVubv0ON6ncvlkHs+wknwY4ntpXB0R8r4VlJOaxPIH97q9g1CbPn5xWtpCvw0CnurihmBqDW0Q3IQ2cZJht6XR56yZF9WRNtyd3rarHqWgdM3c7xXXi+3mryY6WMd1dWcMHx+Ssd00bedgzBCc4DnNZo80bb70TkCe/Dr6GwCL6++9roCJhnuV84VfRVgS3sYV0tuJgOtMOzbA4VTIHbkADbvZlbvUa26bkzjAed47CI0iF0FhTZl6SSUa2Z4rd5IicmUv3ORgd2R/vq0uDXe6CDDxA7IKkw6fI1TaTpZUD+bAQhqjUKPZIcqejTdE0vNO7ChV2EaJFvCHbCAraG86HL2VLWt/TjWuxXOu4+AwM4Dhh7RS172pGx4Lpt5irG1ytDvzWEfixy92TT/6q3Oi3ZKu/lXa8TekmYDY6yjw== hendrik@NBK172"
#   }

#   required_tags = local.old_required_tags
# }

# output "public_ip" {
#   description = "Public IP address assigned to the instance, if applicable"
#   value       = module.rds_bastion.public_ip
# }

# ################################################################################
# # Security Group Module
# ################################################################################

# module "sg_rds_bastion" {
#   source = "git@github.com:celver-AG/terraform-aws-security-group.git?ref=0.1.3"

#   name   = "rds_bastion"
#   vpc_id = data.aws_vpc.this.id

#   security_group_rule = [
#     {
#       type        = "ingress"
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     },
#     {
#       type        = "egress"
#       from_port   = 0
#       to_port     = 65535
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]

#   required_tags = local.old_required_tags

# }