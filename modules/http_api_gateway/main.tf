resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_vpc_link" "this" {
  name        = var.vpc_link_name
  subnet_ids  = var.subnet_ids
  security_group_ids = var.security_group_ids
}

resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "this" {
  for_each             = { for route in var.routes : route.route_key => route }

  api_id               = aws_apigatewayv2_api.this.id
  integration_type     = "HTTP_PROXY"
  integration_uri      = each.value.integration_uri
  integration_method   = each.value.integration_method
  connection_type      = "VPC_LINK"
  connection_id        = aws_apigatewayv2_vpc_link.this.id
  payload_format_version = "1.0"
  timeout_milliseconds = 30000
}

resource "aws_apigatewayv2_route" "this" {
  for_each     = aws_apigatewayv2_integration.this

  api_id       = aws_apigatewayv2_api.this.id
  route_key    = each.key
  target       = "integrations/${each.value.id}"
}
