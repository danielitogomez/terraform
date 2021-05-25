terraform {
  required_providers {
    apigee = {
      source  = "scastria/apigee"
      version = "0.1.40"
    }
  }
}

# Configure the Apigee Provider
provider "apigee" {
  username     = var.username
  password     = var.password
  organization = var.organization
}


