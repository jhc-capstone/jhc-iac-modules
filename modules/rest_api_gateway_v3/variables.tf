variable "name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "resources" {
  description = "List of API Gateway resources with optional methods"
  type = list(object({
    name      = string
    path_part = string
    parent    = string
    methods   = optional(list(string), [])
  }))
}

variable "vpc_link_id" {
  description = "VPC Link ID for integration"
  type        = string
}

variable "integration_uri" {
  description = "Backend URI for integration"
  type        = string
}

variable "integration_http_method" {
  description = "HTTP method for backend integration"
  type        = string
  default     = "POST"
}