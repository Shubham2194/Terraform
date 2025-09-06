Scnerio: 
Let's say we have terraform workspace configured and have dev,stage and prod workspaces.
Using this we are creating our whole infra on AWS (i.e S3, ECR , EKS, CDN , security groups)

we used CIDR for VPC as follow:
terraform.tfvars:
cidr               = "10.0.0.0/16"
cidr-pub           = ["10.0.4.0/24", "10.0.5.0/24"]
cidr-private       = ["10.0.1.0/24", "10.0.2.0/24"]

VPC.tf:
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

(we have multiple variable for all the resources , but we are focusing on these for now)

We aaplied one by one and create three environment (dev,stage and prod):
these are the vpc's on AWS console 



Now in case of prod we are using SAAS base DB which is coucbase and to need make sure our EKS pods should communiate with DB,
either we can whitelist whole CIDR range or we can do VPC peering which is a better practice ,so we started with peering.
While peering we have filled all the requirements but we see its giving as issue:-




