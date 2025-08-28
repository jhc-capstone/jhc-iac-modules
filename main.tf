# 1️⃣ Create VPC Link
module "document_vpc_link" {
  source      = "./modules/vpc_link"
  name        = "document-api-vpc-link"
  target_arns = ["arn:aws:elasticloadbalancing:ap-south-1:646057972714:loadbalancer/net/api-gateway-nlb/d3e1523195a9e085"]
}

# 2️⃣ Create API Gateway with single resource and multiple methods
module "document_api" {
  source            = "./modules/rest_api_gateway"
  api_name          = "document-api"
  api_description   = "API to manage documents"
  resource_name     = "rest-services"
  sub_resource_name = "{proxy+}"          # Optional, becomes /DocContent/DocList
  http_method       = "ANY"             # Pass method as input
  vpc_link_id       = module.document_vpc_link.vpc_link_id
  vpc_link_uri      = "http://internal-service.example.com"
}

