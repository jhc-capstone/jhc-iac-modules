# 1️⃣ Create VPC Link
module "document_vpc_link" {
  source      = "./modules/vpc_link"
  name        = "document-api-vpc-link"
  target_arns = ["arn:aws:elasticloadbalancing:ap-south-1:646057972714:loadbalancer/net/api-gateway-nlb/d3e1523195a9e085"]
}

module "my_api" {
  source = "./modules/rest_api_gateway_v3"
  name   = "my-api"

  vpc_link_id             = module.document_vpc_link.vpc_link_id
  integration_uri         = "https://internal-service.example.com"
  # integration_http_method = "POST"

  resources = [
    {
      name      = "rest-services"
      path_part = "rest-services"
      parent    = "root"
    },
    {
      name      = "citation-and-classification"
      path_part = "citation-and-classification"
      parent    = "rest-services"
    },
    {
      name      = "proxy"
      path_part = "{proxy+}"
      parent    = "citation-and-classification"
      methods   = ["ANY"]
    },
    {
      name      = "services"
      path_part = "services"
      parent    = "root"
      methods   = ["POST"]
    },
    {
      name      = "DocContent"
      path_part = "DocContent"
      parent    = "services"
      methods   = ["POST"]
    },
    {
      name      = "DocContentDataServ.wsdl"
      path_part = "DocContentDataServ.wsdl"
      parent    = "services"
      methods   = ["GET"]
    },
    {
      name      = "DocList"
      path_part = "DocList"
      parent    = "services"
      methods   = ["POST"]
    },
    {
      name      = "DocList.wsdl"
      path_part = "DocList.wsdl"
      parent    = "services"
      methods   = ["GET"]
    },
    {
      name      = "rpc"
      path_part = "rpc"
      parent    = "services"
    },
    {
      name      = "FwaPort"
      path_part = "FwaPort"
      parent    = "rpc"
    },
    {
      name      = "DocContent2"
      path_part = "DocContent"
      parent    = "FwaPort"
      methods   = ["POST"]
    }
  ]
}
