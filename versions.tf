terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = "~> 1.2.9"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 4.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }
}