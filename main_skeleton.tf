# ==============================================================
# TERRAFORM CONFIGURATION SKELETON
# ==============================================================

# ----------------------
# Terraform Block
# ----------------------
# Specifies the required Terraform version and providers
terraform {
  # Define required Terraform version
  required_version = ">= 1.0.0"

  # Define required providers with versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Add other providers as needed
    # azurerm = {
    #   source  = "hashicorp/azurerm"
    #   version = "~> 3.0"
    # }
  }

  # It not possible to use variables here :-( But you can make it overwritable (check TF Backend Documentation)
  #   Or things like Terragrunt 
  # Backend configuration (where state will be stored)
  backend "local" {
    path = ".tfstate/terraform.tfstate"
  }


  # Remote backend example:
  # backend "s3" {
  #   bucket         = "terraform-state-bucket"
  #   key            = "path/to/terraform.tfstate"
  #   region         = "eu-central-1"
  #   #dynamodb_table = "terraform-locks" # For state locking (!! old way !!)
  #   use_lockfile    = true  #S3 native locking! new! (replace dynamodb locks)
  #   encrypt        = true
  # }
}

# ----------------------
# Provider Blocks
# ----------------------
# Main provider
provider "aws" {
  region = var.aws_region

  # Optional profile from AWS config 
  profile = var.aws_profile

  # Optional default tags applied to all resources
  default_tags {
    tags = var.default_tags
  }
}

# Optional secondary provider (different region)
# Use provider = aws.us-east-1 when you want to use it
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

# ----------------------
# Locals
# ----------------------
# For intermediate computed values or to avoid repetition
locals {
  common_name = "${var.project_name}-${var.environment}"

  # Example computed value based on variables
  # Another common way: instance_count = var.environment == "prod" ? 3 : 1
  instance_count = var.instance_settings[var.environment].instance_count

  # Common tags that will be applied to all resources
  common_tags = merge(
    var.default_tags,
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  )
}

# ----------------------
# Data Sources
# ----------------------
# Getting existing resources or information from AWS
data "aws_vpc" "default" {
  # This data provider is UNUSED - only for demo purposes
  # Get data fom DEFAULT VPC from current region (which we dont use here)
  default = true
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# Other common example: Import OUTPUTS of another module from another team.
# Loose coupling between modules



# ----------------------
# Resources
# ----------------------
# Define infrastructure components

# Example EC2 Instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_settings[var.environment].instance_type
  subnet_id     = module.vpc.public_subnet_ids[0] # ref module export

  # Count can be used for creating multiple instances
  count = local.instance_count

  root_block_device {
    volume_size = var.instance_settings[var.environment].root_volume_gb
  }

  tags = merge(
    local.common_tags,
    {
      # format() function usage
      Name = format("%s-web-%d", local.common_name, count.index + 1) #Alternative: "${local.common_name}-web-${count.index + 1}"
    }
  )
}

# ----------------------
# Modules
# ----------------------
# Using reusable modules
module "vpc" {
  source = "./modules/vpc"
  # or from Terraform Registry:
  # source = "terraform-aws-modules/vpc/aws"
  # version = "3.14.0"

  vpc_name             = local.common_name
  vpc_cidr             = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnets  = tolist([var.public_subnet_cidr])
  private_subnets = var.subnet_cidrs

  tags = local.common_tags
}

# ----------------------
# Outputs
# ----------------------
# Define values to output after apply
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_ids
}

output "instance_public_ips" {
  description = "The public IP addresses of the web instances"
  value       = aws_instance.web[*].public_ip
}
