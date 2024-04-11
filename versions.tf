terraform {
  required_version = ">= 1.4.3, <= 1.7.4"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 4.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}