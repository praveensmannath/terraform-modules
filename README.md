# Terraform teplate 

### Prerequisites:
* Terraform
* AWS Cli
### Usage:

1. Configure your AWS Cli to right AWS prprofile. this profile will be used to save your terrafrom states in S3 bucket
2. create s3 bucket 
Commands to Setup Environments:
```
$ terrafrom init # (This will fail if you dont have right privs to s3 buckets, where you are saving TF states)
$ terraform plan -var "region=us-east-1" -var "access_key=xxxxxx" -var "secret_key=xxxxxxxxx" -var "name=project_name" -var "env=dev/stage" -var "created_by=admin" -var "bucket-name=asdf1234" 
$ terraform apply "region=us-east-1" -var "access_key=xxxxxx" -var "secret_key=xxxxxxxxx" -var "name=project_name" -var "env=dev/stage" -var "created_by=admin" -var "bucket-name=asdf1234" 
```
