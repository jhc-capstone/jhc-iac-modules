variable "name" {
  type        = string
  description = "Name of the VPC Link"
}

variable "target_arns" {
  type        = list(string)
  description = "List of NLB ARNs to connect API Gateway to"
}
