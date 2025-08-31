# output "api_id" {
#   value = aws_api_gateway_rest_api.this.id
# }

# output "resources" {
#   value = { for r in aws_api_gateway_resource.resources : r.key => r.value.path_part }
# }

# output "resource_ids" {
#   value = { for r in aws_api_gateway_resource.resources : r.key => r.value.id }
# }