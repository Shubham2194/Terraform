This repository contains the terraform file code, which we can use to provision the Amazon EKS cluster.

``` 
cd kube_terraform/ToDo-App/
terraform init
```

3️⃣ Edit the below file according to your configuration
```

Let's set up the variable for our Infrastructure and create one file with the name of terraform.tfvars inside kube_terraform/ToDo-App/backend.tf and add the below conntent into that file.

```
REGION          = "us-east-1"

PROJECT_NAME    = "ToDo-App"

VPC_CIDR        = "10.0.0.0/16"

PUB_SUB1_CIDR   = "10.0.1.0/24"

PUB_SUB2_CIDR   = "10.0.2.0/24"

PRI_SUB3_CIDR   = "10.0.3.0/24"

PRI_SUB4_CIDR   = "10.0.4.0/24"
```

Please note that the above file is crucial for setting up the infrastructure, so pay close attention to the values you enter for each variable.

It's time to build the infrastructure

The below command will tell you what terraform is going to create.

`terraform plan`

Finally, HIT the below command to create the infrastructure...

`terraform apply`

type yes, and it will prompt you for permission or use --auto-approve in the command above.

Thank you so much for reading my blog.
