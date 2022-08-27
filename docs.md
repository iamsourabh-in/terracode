 # Get the image Id for TF:

 aws ec2 describe-images --owners self amazon
 
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