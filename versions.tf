terraform {
  required_version = ">= 1.4.3"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.43"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}