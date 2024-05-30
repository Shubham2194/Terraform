terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.26.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

provider "google" {
  credentials = file("key.json")
  project     = var.google_project
  region      = var.google_region
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-south-1"
}

