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

  prefix    = "${local.required_tags.Project}-${local.required_tags.Application}"
  root_path = "../../../../../"

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


################################################################################
# VPC Endpoint (API Gateway)
################################################################################

data "aws_vpc_endpoint" "this" {
  vpc_id       = data.aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.execute-api"

  filter {
    name   = "tag:Project"
    values = ["performance-data"]
  }
}

data "aws_region" "current" {}


################################################################################
# Route53 hosted zone
################################################################################

data "aws_route53_zone" "this" {
  name = var.aws_route53_zone_name
}


# ################################################################################
# # API Interface Module
# ################################################################################

module "api_interface" {
  source = "git::ssh://gitlab@git.meinestadt.de/itbetrieb/terraform/configurations/performance-data-api-interface.git?ref=0.1.4"

  api_name                   = local.prefix
  stage                      = var.stage
  rds_cluster_identifier     = var.rds_cluster_identifier
  rds_secret_name            = var.rds_secret_name
  rds_cluster_db_schema_name = var.rds_cluster_db_schema_name
  rds_cluster_db_table_name  = var.rds_cluster_db_table_name

  domain_cert_name = var.domain_cert_name
  record_name      = var.record_name
  zone_id          = data.aws_route53_zone.this.zone_id

  vpc_endpoint_id = data.aws_vpc_endpoint.this.id
  subnet_ids      = data.aws_subnets.private.ids

  lambda_proxy_src_dir_raw_multi         = "${local.root_path}/src/multiCampaignPerformanceRaw/"
  lambda_proxy_src_dir_aggregated_multi  = "${local.root_path}/src/multiCampaignPerformanceAggregated/"
  lambda_proxy_src_dir_raw_single        = "${local.root_path}/src/singleCampaignPerformanceRaw/"
  lambda_proxy_src_dir_aggregated_single = "${local.root_path}/src/singleCampaignPerformanceAggregated/"

  api_gateway_stages = {
    "v1" = {}
  }
  api_gateway_main_stage = "v1"

  required_tags = local.required_tags
}
