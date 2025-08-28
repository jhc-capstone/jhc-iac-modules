variable "api_name" {
  description = "Name of the API Gateway REST API"
  type        = string
}

variable "api_description" {
  description = "Description for the API Gateway"
  type        = string
  default     = ""
}

variable "api_resources" {
  description = "List of resource paths for the API (e.g., orders, products)"
  type        = list(string)
}

variable "http_method" {
  description = "HTTP method for the resource (GET, POST, etc.)"
  type        = string
  default     = "GET"
}
