output "rest_api_id" {
  value       = aws_api_gateway_rest_api.this.id
  description = "ID of the API Gateway REST API"
}

output "resource_id" {
  value       = aws_api_gateway_resource.this.id
  description = "ID of the primary resource"
}

output "sub_resource_id" {
  value       = length(var.sub_resource_name) > 0 ? aws_api_gateway_resource.sub[0].id : ""
  description = "ID of the sub-resource if created"
}

output "http_method" {
  value       = var.http_method
  description = "HTTP method used for resources"
}
