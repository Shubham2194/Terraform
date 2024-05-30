terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.31.1"
    }
  }
}

provider "google" {
    
    credentials = file("key.json")
    project = var.project
    region = var.zone

}
