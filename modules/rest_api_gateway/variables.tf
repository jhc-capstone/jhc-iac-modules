variable "api_name" {
  type        = string
  description = "Name of the API Gateway REST API"
}

variable "api_description" {
  type        = string
  description = "Description of the API"
  default     = ""
}

variable "resource_name" {
  type        = string
  description = "Primary resource path (e.g., 'DocContent')"
}

variable "sub_resource_name" {
  type        = string
  description = "Optional sub-resource path (child of resource_name)"
  default     = ""
}

variable "vpc_link_id" {
  type        = string
  description = "VPC Link ID for integration"
}

variable "vpc_link_uri" {
  type        = string
  description = "HTTP endpoint URI to integrate with VPC Link"
}
