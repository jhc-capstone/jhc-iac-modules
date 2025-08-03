# API Gateway HTTP API
resource "aws_apigatewayv2_api" "this" {
  name          = var.api_name
  protocol_type = "HTTP"
}

# VPC Link
resource "aws_apigatewayv2_vpc_link" "this" {
  name               = var.vpc_link_name
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

# Lambda Authorizer
resource "aws_apigatewayv2_authorizer" "lambda_auth" {
  name                               = var.authorizer_name
  api_id                             = aws_apigatewayv2_api.this.id
  authorizer_type                    = "REQUEST"
  authorizer_uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  identity_sources                   = ["$request.header.Authorization"]
  authorizer_payload_format_version = "2.0"
  enable_simple_responses            = true
}

# Permission for API Gateway to invoke Lambda Authorizer
resource "aws_lambda_permission" "allow_apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.this.execution_arn}/*/*"
}

# Stage
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = var.stage_name
  auto_deploy = true
}

# Integrations for each route
resource "aws_apigatewayv2_integration" "this" {
  for_each               = { for route in var.routes : route.route_key => route }

  api_id                 = aws_apigatewayv2_api.this.id
  integration_type       = "HTTP_PROXY"
  integration_uri        = each.value.integration_uri
  integration_method     = each.value.integration_method
  connection_type        = "VPC_LINK"
  connection_id          = aws_apigatewayv2_vpc_link.this.id
  payload_format_version = "1.0"
  timeout_milliseconds   = 30000
}

# Routes with Lambda Authorizer
resource "aws_apigatewayv2_route" "this" {
  for_each            = aws_apigatewayv2_integration.this

  api_id              = aws_apigatewayv2_api.this.id
  route_key           = each.key
  target              = "integrations/${each.value.id}"

  authorization_type  = "CUSTOM"
  authorizer_id       = aws_apigatewayv2_authorizer.lambda_auth.id
}