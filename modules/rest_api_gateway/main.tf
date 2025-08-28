resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = var.api_description
}

# Create resources (paths)
resource "aws_api_gateway_resource" "resources" {
  for_each    = toset(var.api_resources)
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.value
}

# Create methods (for each resource)
resource "aws_api_gateway_method" "methods" {
  for_each = {
    for res in var.api_resources : res => res
  }

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.resources[each.value].id
  http_method   = var.http_method
  authorization = "NONE"
}
