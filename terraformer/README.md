## Terraformer ##


<img width="650" height="396" alt="image" src="https://github.com/user-attachments/assets/7b6d07fc-6665-4abc-b179-eb7967e346e4" />


STEP 1 : Installation
Before installing terraformer make sure you have installed terraform in your machine. 
You can install Terraform from: 

```
https://www.terraform.io/downloads
```
For macOS:
```
brew install terraformer
```
For Windows:
```
winget install terraformer
```
For Linux:
```
export PROVIDER=aws
curl -LO "https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64"
chmod +x terraformer-${PROVIDER}-linux-amd64
sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer
```

<img width="1314" height="856" alt="image" src="https://github.com/user-attachments/assets/31ed6135-11ef-43c5-a5ea-5d7647aabb5c" />

```
terraformer --version
```

STEP2 :

Now, let’s learn about importing the main AWS resources that are most frequently used. 
To do this, create an empty directory eg. terraformer, and add a main.tf file with the following values:

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}


```

Then run terraform init command to initialize the terraform


























