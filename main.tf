module "store_api" {
  source          = "./modules/rest_api_gateway"
  api_name        = "store-api"
  api_description = "API to manage store operations"
  api_resources   = ["DocContent", "DocList"]
  http_method     = "GET"
}