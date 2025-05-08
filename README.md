# Terraform summary

Repository for learning / training purposes.

## Course Instructions
- Rename the `terraform.tfvars.example` to `terraform.tfvars` replace the placeholders with real values.
- Apply the configuration to your account
- Discover what it did in your AWS account
- Destroy everything **using the Terraform CLI**

- Create an S3 Bucket in `eu-central-1` Region (use any name you want - we will use it as remote state)
- Change the Terraform backend configuration so, that it will use your previsouly created bucket
- Apply the changes again
- Check if everything worked was expected!

(At the end, please destroy everything using the Terraform CLI again!)


## CLI Commands

- `terraform plan`: Creates the execution plan (append `-out <plan-name>` to create a named plan)
- `terraform apply`: Applies execution plan (append the name of the plan as argument if you created one before)
- `terraform validate`: Syntax validation
- `terraform fmt`: Format configuration files 
- `terraform show`: Human readable plan
- `terraform state list`: List all resources in the state file
- `terraform destroy`: Destroy all resources