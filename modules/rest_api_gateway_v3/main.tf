# -------------------------------
# 1️⃣ Create API Gateway
# -------------------------------
resource "aws_api_gateway_rest_api" "this" {
  name        = var.name
  description = "API created via Terraform module"
}

# -------------------------------
# 2️⃣ Level 1: root children
# -------------------------------
resource "aws_api_gateway_resource" "level1" {
  for_each    = { for r in var.resources : r.name => r if r.parent == "root" }
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.value.path_part
}

# -------------------------------
# 3️⃣ Level 2
# -------------------------------
resource "aws_api_gateway_resource" "level2" {
  for_each    = { for r in var.resources : r.name => r if r.parent != "root" && contains(keys(aws_api_gateway_resource.level1), r.parent) }
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.level1[each.value.parent].id
  path_part   = each.value.path_part
}

# -------------------------------
# 4️⃣ Level 3
# -------------------------------
resource "aws_api_gateway_resource" "level3" {
  for_each    = { for r in var.resources : r.name => r if r.parent != "root" && contains(keys(aws_api_gateway_resource.level2), r.parent) }
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.level2[each.value.parent].id
  path_part   = each.value.path_part
}

# -------------------------------
# 5️⃣ Level 4
# -------------------------------
resource "aws_api_gateway_resource" "level4" {
  for_each    = { for r in var.resources : r.name => r if r.parent != "root" && contains(keys(aws_api_gateway_resource.level3), r.parent) }
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.level3[each.value.parent].id
  path_part   = each.value.path_part
}

# -------------------------------
# 6️⃣ Merge all resources for methods
# -------------------------------
locals {
  all_resources = merge(
    aws_api_gateway_resource.level1,
    aws_api_gateway_resource.level2,
    aws_api_gateway_resource.level3,
    aws_api_gateway_resource.level4
  )

  resource_methods = {
    for pair in flatten([
      for res in var.resources : [
        for m in lookup(res, "methods", []) : {
          key         = "${res.name}-${m}"
          resource_id = local.all_resources[res.name].id
          http_method = m
        }
      ]
    ]) : pair.key => {
      resource_id = pair.resource_id
      http_method = pair.http_method
    }
  }
}

# -------------------------------
# 7️⃣ Methods
# -------------------------------
resource "aws_api_gateway_method" "methods" {
  for_each = local.resource_methods

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = each.value.resource_id
  http_method   = each.value.http_method
  authorization = "NONE"
}

# -------------------------------
# 8️⃣ Integration with VPC Link
# -------------------------------
resource "aws_api_gateway_integration" "integration" {
  for_each    = aws_api_gateway_method.methods
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method

  type                    = "HTTP"
  uri                     = var.integration_uri
  integration_http_method = var.integration_http_method != "" ? var.integration_http_method : "POST"

  connection_type = "VPC_LINK"
  connection_id   = var.vpc_link_id
}