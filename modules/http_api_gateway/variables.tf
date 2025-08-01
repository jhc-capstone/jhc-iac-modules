variable "api_name" {
  description = "Name of the HTTP API Gateway"
  type        = string
}

variable "vpc_link_name" {
  description = "Name of the VPC Link"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for VPC Link"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for VPC Link"
  type        = list(string)
}

variable "stage_name" {
  description = "Deployment stage name"
  type        = string
  default     = "$default"
}

variable "routes" {
  description = "List of route objects"
  type = list(object({
    route_key          = string   # e.g., "GET /ping"
    integration_uri    = string   # e.g., NLB URI like "http://<nlb-dns-name>"
    integration_method = string   # e.g., "ANY", "GET"
  }))
}
