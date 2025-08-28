output "rest_api_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "resource_ids" {
  value = { for k, v in aws_api_gateway_resource.resources : k => v.id }
}
