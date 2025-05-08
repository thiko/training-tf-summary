# ==============================================================
# VARIABLES DEFINITION FILE (variables.tf)
# ==============================================================

# ----------------------
# AWS Configuration Variables
# ----------------------
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
  default     = "default"
}

# ----------------------
# Project Identification Variables
# ----------------------
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "example-project"
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# ----------------------
# Resource Sizing Variables
# ----------------------


# ----------------------
# Complex Variable Types
# ----------------------
variable "instance_settings" {
  description = "Map of instance configurations by environment"
  type = map(object({
    instance_type  = string
    instance_count = number
    root_volume_gb = number
  }))

  default = {
    dev = {
      instance_type  = "t3.micro"
      instance_count = 1
      root_volume_gb = 20
    }
    staging = {
      instance_type  = "t3.small"
      instance_count = 2
      root_volume_gb = 30
    }
    prod = {
      instance_type  = "t3.medium"
      instance_count = 3
      root_volume_gb = 50
    }
  }
}

# ----------------------
# Network Configuration Variables
# ----------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.16.48.0/20"
}

variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
  default     = ["10.16.16.0/20", "10.16.32.0/20"]
}

# ----------------------
# Tagging Variables
# ----------------------
variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    Owner       = "YourTeam"
    Terraform   = "true"
    Application = "ExampleApp"
  }
}


# Variable for sensitive data (not checked into Git)
# variable "db_password" {
#   description = "Database password"
#   type        = string
#   sensitive   = true
#   # No default value - should be provided via .tfvars or environment variables
# }
