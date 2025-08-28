output "vpc_link_id" {
  value       = aws_api_gateway_vpc_link.this.id
  description = "The ID of the VPC Link"
}
