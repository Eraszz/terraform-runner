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

  prefix                           = "${local.required_tags.Project}-${local.required_tags.Application}-${local.required_tags.Module}"
  sg_api_gateway_vpc_endpoint_name = "${local.prefix}-api-gateway"

  private_subnet_cidr = [for v in data.aws_subnet.private : v.cidr_block]

  stage = local.required_tags.Stage
}



################################################################################
# Get VPC ID
################################################################################

data "aws_vpc" "this" {
  tags = {
    service = local.stage
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

data "aws_subnet" "private" {
  count = length(data.aws_subnets.private.ids)

  id = data.aws_subnets.private.ids[count.index]
}


################################################################################
# Create API Gateway VPC Endpoints
################################################################################

module "api_gateway_vpc_endpoint" {
  source = "git::ssh://gitlab@git.meinestadt.de/itbetrieb/infrastructure-as-code/modules/vpc-endpoint.git?ref=0.1.0"

  service_name      = "com.amazonaws.${data.aws_region.current.name}.execute-api"
  vpc_endpoint_type = "Interface"

  vpc_id     = data.aws_vpc.this.id
  subnet_ids = data.aws_subnets.private.ids

  security_group_ids  = [module.sg_api_gateway_vpc_endpoint.security_groups_ids["api_gateway_interface_endpoint"]]
  private_dns_enabled = true

  required_tags = local.required_tags
}

data "aws_region" "current" {}



################################################################################
# Security Group Module
################################################################################

module "sg_api_gateway_vpc_endpoint" {

  source = "git::ssh://gitlab@git.meinestadt.de/itbetrieb/infrastructure-as-code/modules/security-groups.git?ref=3.0.0"

  stage = var.stage

  security_groups = {
    api_gateway_interface_endpoint = {
      name        = local.sg_api_gateway_vpc_endpoint_name
      description = "Security Group for the API Gateway VPC Endpoint"

      rules = {
        ingress_all = {
          from_port   = 0
          to_port     = 0
          protocol    = -1
          cidr_blocks = ["0.0.0.0/0"]
          description = "Security Group for the API Gateway VPC Endpoint"
        },
        egress_https = {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = local.private_subnet_cidr
          description = "Security Group for the API Gateway VPC Endpoint"
        }
      }
    }
  }

  global_tags = local.required_tags
}
