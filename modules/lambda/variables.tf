variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "handler" {
  description = "Handler (e.g., index.handler)"
  type        = string
}

variable "runtime" {
  description = "Runtime environment (e.g., python3.8)"
  type        = string
}

variable "filename" {
  description = "Path to deployment package zip"
  type        = string
}

variable "timeout" {
  type        = number
  default     = 10
}

variable "memory_size" {
  type        = number
  default     = 128
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "lambda_policy_json" {
  description = "The IAM policy in JSON format to attach to the Lambda execution role"
  type        = string
}