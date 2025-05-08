# Terraform summary

Repository for learning / training purposes.

## Usage
Rename the `terraform.tfvars.example` to `terraform.tfvars` replace the placeholders with real values.

## CLI Commands

- `terraform plan`: Creates the execution plan (append `-out <plan-name>` to create a named plan)
- `terraform apply`: Applies execution plan (append the name of the plan as argument if you created one before)
- `terraform validate`: Syntax validation
- `terraform fmt`: Format configuration files 
- `terraform show`: Human readable plan
- `terraform state list`: List all resources in the state file
- `terraform destroy`: Destroy all resources