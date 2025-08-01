module "http_api_gateway" {
  source = "./modules/http_api_gateway"

  api_name           = "sample-api"
  vpc_link_name      = "sample-vpc-link"
  subnet_ids         = ["subnet-0dc6890f5ef304a00", "subnet-0554c78952dfd6313","subnet-078398ff487de1551"]
  security_group_ids = ["sg-0b1a7024b789a3f0a"]
  stage_name         = "dev"

  routes = [
    {
      route_key          = "ANY /admin/{proxy+}"
      integration_uri    = "arn:aws:elasticloadbalancing:ap-south-1:646057972714:listener/net/private-link-nlb/424e657f493d8495/b0c9b008809af129"
      integration_method = "ANY"
    }
    # {
    #   route_key          = "POST /submit"
    #   integration_uri    = "http://internal-nlb-abc123.elb.amazonaws.com/submit"
    #   integration_method = "POST"
    # }
  ]
}