resource "aws_iam_role" "lambda_exec" {
  name = "${var.function_name}-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_custom_policy" {
  name   = "${var.function_name}-custom-policy"
  policy = var.lambda_policy_json
}

resource "aws_iam_role_policy_attachment" "lambda_custom_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_custom_policy.arn
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = var.handler
  runtime       = var.runtime
  filename      = var.filename
  source_code_hash = filebase64sha256(var.filename)
  timeout       = var.timeout
  memory_size   = var.memory_size

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}
