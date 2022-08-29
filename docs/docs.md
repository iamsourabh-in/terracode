 # Get the image Id for TF:
 
```sh
 aws ec2 describe-images --owners self amazon
```

# Generate for aws-learning

 ```sh
 terraform-docs markdown table --output-file ./readme.md .\modules\aws-learning\  
```
# Generate for ec2-apache-server

```sh
  terraform-docs markdown table --output-file ./readme.md .\modules\ec2-apache-server\
```

# Generate for main file
```sh
   terraform-docs markdown table --output-file ./readme.md . 
```


# Terraform Commands

```sh

terraform init

terraform validate 

terraform console

terraform output -json

terraform init -upgrade 

terraform plan

terraform apply -auto-approve

terraform destroy -auto-approve

```