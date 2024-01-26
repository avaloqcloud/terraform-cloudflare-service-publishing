terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = "~> 1.2.9"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 4.17.0"
    }
  }
}