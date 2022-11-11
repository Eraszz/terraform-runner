################################################################################
# VPC Endpoint Outputs
################################################################################

output "api_gateway_endpoint_id" {
  description = "The ID of the VPC endpoint for API Gateway."
  value       = module.api_gateway_vpc_endpoint.id
}

output "api_gateway_endpoint_arn" {
  description = "The Amazon Resource Name (ARN) of the VPC endpoint for API Gateway."
  value       = module.api_gateway_vpc_endpoint.arn
}

output "api_gateway_endpoint_network_interface_ids" {
  description = "IDs of the Interface Endpoint for API Gateway"
  value       = module.api_gateway_vpc_endpoint.network_interface_ids
}
