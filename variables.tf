# variables.tf
# Input variables for VPC infrastructure

variable "aws_region" {
  description = "AWS region for VPC deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "prod-app"
}

variable "environment" {
  description = "Environment (dev, test, preprod, prod)"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (NAT Gateway)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (application workloads)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}
