module "authorizer_lambda" {
  source = "./modules/lambda"
  function_name = "api-authorizer-lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "./src/authorizer_function.zip"

  timeout       = 15
  memory_size   = 256

  environment_variables = {
    ENV = "dev"
  }

  tags = {
    Env = "dev"
    Owner = "team-dev"
  }
  lambda_policy_json = jsonencode({
  Version = "2012-10-17",
  Statement = [
    {
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Effect   = "Allow",
      Resource = "*"
    },
    {
      Action = [
        "s3:GetObject",
        "s3:PutObject"
      ],
      Effect   = "Allow",
      Resource = "arn:aws:s3:::your-bucket-name/*"
    }
  ]
})

}
module "http_api_gateway" {
  source = "./modules/http_api_gateway"

  api_name           = "sample-api"
  vpc_link_name      = "sample-vpc-link"
  subnet_ids         = ["subnet-0dc6890f5ef304a00", "subnet-0554c78952dfd6313","subnet-078398ff487de1551"]
  security_group_ids = ["sg-0b1a7024b789a3f0a"]
  stage_name         = "dev"
  region = "ap-south-1"
  # lambda_arn = "arn:aws:lambda:ap-south-1:646057972714:function:my-lambda-dev"
  lambda_arn = module.authorizer_lambda.function_arn

  routes = [
    {
      route_key          = "ANY /admin/{proxy+}"
      integration_uri    = "arn:aws:elasticloadbalancing:ap-south-1:646057972714:listener/net/api-gateway-nlb/d3e1523195a9e085/a840f1082c785467"
      integration_method = "ANY"
    }
  ]
}