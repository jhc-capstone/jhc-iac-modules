# Create REST API
resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = var.api_description
}

# Create primary resource
resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = var.resource_name
}

# Create ANY method for primary resource
resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "ANY"
  authorization = "NONE"
}

# HTTP_PROXY integration for primary resource
resource "aws_api_gateway_integration" "this" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = var.vpc_link_uri
  connection_type         = "VPC_LINK"
  connection_id           = var.vpc_link_id
}

# Optional sub-resource
resource "aws_api_gateway_resource" "sub" {
  count       = length(var.sub_resource_name) > 0 ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.this.id
  path_part   = var.sub_resource_name
}

# ANY method for sub-resource
resource "aws_api_gateway_method" "sub_method" {
  count        = length(var.sub_resource_name) > 0 ? 1 : 0
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.sub[0].id
  http_method   = "ANY"
  authorization = "NONE"
}

# HTTP_PROXY integration for sub-resource
resource "aws_api_gateway_integration" "sub_integration" {
  count                    = length(var.sub_resource_name) > 0 ? 1 : 0
  rest_api_id              = aws_api_gateway_rest_api.this.id
  resource_id              = aws_api_gateway_resource.sub[0].id
  http_method              = aws_api_gateway_method.sub_method[0].http_method
  type                     = "HTTP_PROXY"
  integration_http_method  = "ANY"
  uri                      = var.vpc_link_uri
  connection_type          = "VPC_LINK"
  connection_id            = var.vpc_link_id
}
