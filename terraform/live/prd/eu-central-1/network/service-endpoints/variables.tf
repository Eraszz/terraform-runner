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
# AWS provider and state bucket variables
################################################################################

variable "aws_region" {
  description = "AWS Terraform provider region"
  type        = string
}
