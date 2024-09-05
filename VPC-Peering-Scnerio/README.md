Scnerio: 
Let's say we have terraform workspace configured and have dev,stage and prod workspaces.

Using workspaces we are creating our whole infra on AWS (i.e S3, ECR , EKS, CDN , security groups)

we used CIDR for VPC as follow:
terraform.tfvars:

```tf
cidr               = "10.0.0.0/16"
cidr-pub           = ["10.0.4.0/24", "10.0.5.0/24"]
cidr-private       = ["10.0.1.0/24", "10.0.2.0/24"]
```

VPC.tf:
```tf
data "aws_availability_zones" "availability" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name                 = "${var.name}-${terraform.workspace}"
  cidr                 = var.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.cidr-private
  public_subnets       = var.cidr-pub
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Name                     = "fs-pub-${terraform.workspace}"
    "kubernetes.io/role/elb" = 1

  }
  map_public_ip_on_launch = true

  private_subnet_tags = {
    Name                              = "fs-private-${terraform.workspace}"
    "kubernetes.io/role/internal-elb" = 1

  }

}
```
(we have multiple variable for all the resources , but we are focusing on these for now)

We aaplied one by one and create three environment (dev,stage and prod):

these are the vpc's on AWS console 


![image](https://github.com/user-attachments/assets/e6f60525-f924-43e6-8537-3caad1cc8930)


Now in case of prod we are using SAAS base DB which is coucbase and to need make sure our EKS pods should communiate with DB,
either we can whitelist whole CIDR range or we can do VPC peering which is a better practice ,so we started with peering.
While peering we have filled all the requirements:-

![image](https://github.com/user-attachments/assets/1af17881-2b6b-4f3a-8fdf-696c37e7a1f1)

But we are facing an issue-

![image](https://github.com/user-attachments/assets/d69a36fd-ed4c-441c-bc71-e640a93df434)

I can see the problem probably be with overlapping CIDR range .

So here we make some changes in our terraform vpc.tf and terraform.tfvars

vpc.tf :

```tf

locals {
  cidr            = terraform.workspace == "prod" ? var.prodcidr : var.cidr
  private_subnets = terraform.workspace == "prod" ? var.cidr-private-prod : var.cidr-private
  public_subnets  = terraform.workspace == "prod" ? var.cidr-pub-prod : var.cidr-pub
}

data "aws_availability_zones" "availability" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name                 = "${var.name}-${terraform.workspace}"
  cidr                 = local.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = local.private_subnets
  public_subnets       = local.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Name                     = "fs-pub-${terraform.workspace}"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    Name                              = "fs-private-${terraform.workspace}"
    "kubernetes.io/role/internal-elb" = 1
  }

  map_public_ip_on_launch = true
}
```

terraform.tfvars:

```tf
cidr               = "10.0.0.0/16"
prodcidr           = "192.168.0.0/16"
cidr-pub-prod      = ["192.168.1.0/24", "192.168.2.0/24"]
cidr-private-prod  = ["192.168.3.0/24", "192.168.5.0/24"]
cidr-pub           = ["10.0.4.0/24", "10.0.5.0/24"]
cidr-private       = ["10.0.1.0/24", "10.0.2.0/24"]

```

this will modify the VPC with different CIDR range and save us !!!


Now i Went back to my SAAS DB service and try peering again with my VPC id and finally it Peered !!

![image](https://github.com/user-attachments/assets/e9b25a46-5f8a-4b72-8ca0-7c51c0e7eb9f)

