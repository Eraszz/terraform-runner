# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "stage" {
  description = "Stage Tag"
  type        = string
}

variable "project" {
  description = "Project Tag"
  type        = string
}

variable "application" {
  description = "Application Tag"
  type        = string
}

variable "module" {
  description = "Module Tag"
  type        = string
}

variable "owner" {
  description = "Owner Tag"
  type        = string
}

variable "purpose" {
  description = "Purpose Tag"
  type        = string
}

variable "app_version" {
  description = "Version Tag"
  type        = string
}

variable "region" {
  description = "Region Tag"
  type        = string
}


################################################################################
# AWS provider variables
################################################################################

variable "aws_region" {
  description = "AWS Terraform provider region"
  type        = string
}


################################################################################
# Env variables
################################################################################

variable "rds_cluster_identifier" {
  description = "Identifier of the RDS cluster"
  type        = string
}

variable "rds_secret_name" {
  description = "Name of the RDS secret"
  type        = string
}

variable "domain_cert_name" {
  description = "Name of the Domain Cert to use for the alb"
  type        = string
}

variable "rds_cluster_db_schema_name" {
  description = "Name of the database schema"
  type        = string
}

variable "rds_cluster_db_table_name" {
  description = "Name of the database table"
  type        = string
}

variable "record_name" {
  description = "Name of alias record to create for the ALB"
  type        = string
}

variable "aws_route53_zone_name" {
  description = "Name of the hosted zone to use"
  type        = string
}
