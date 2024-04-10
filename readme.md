# Terraform Project Structure

## Structure for Multiple Enviornments 

```
├── envs
│   ├── dev
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── stage
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── prod
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── modules
    ├── network
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── rds_postgres
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── s3_private_bucket
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ecs_fargate
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Commands

#### Terraform Plan, Validate, Apply
```shell
# Use Prefix AWS_PROFILE=terraform-development if facing profile issues.
terraform init
terraform fmt --check --recursive -diff
terraform validate
terraform plan
terraform destroy
```

#### Terraform States List, Destroy
```shell
terraform state list
terraform destroy -target=RESOURCE_TYPE.NAME
```

#### Terraform Lock States
```shell
terraform force-unlock -force <lock-id>
# OR 
ps aux | grep terraform & sudo kill -9 <process_id>
```

#### CLI Commands

```shell
aws ec2 delete-security-group --group-id <sg-id>  --profile name-terraform-development --region eu-west-2
aws secretsmanager delete-secret --secret-id <secret_name> --force-delete-without-recovery --profile name-terraform-development--region eu-west-2
aws iam delete-role --role-name <role_name> --profile name-terraform-development --region eu-west-2
terraformer import aws --resources="s3" --regions=eu-west-1 --profile=name-terraform-development
```
