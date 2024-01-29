[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/avaloqcloud/terraform-cloudflare-service-publishing/archive/refs/tags/v0.2.0.zip)


## Terraform Cloudflare Service Publishing
Provides a reusable Terraform module to publish services via Cloudflare, compatible with ORM.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2.9 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | = 4.17.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | = 4.17.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_access_application.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.17.0/docs/resources/access_application) | resource |
| [cloudflare_access_policy.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.17.0/docs/resources/access_policy) | resource |
| [cloudflare_access_service_token.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.17.0/docs/resources/access_service_token) | resource |
| [cloudflare_record.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.17.0/docs/resources/record) | resource |
| [cloudflare_tunnel.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.17.0/docs/resources/tunnel) | resource |
| [random_id.these](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service_publishing"></a> [service\_publishing](#input\_service\_publishing) | Service Publishing input object. | <pre>object({<br>    records = optional(list(object({<br>      zone_id = string,<br>      name    = string,<br>      value   = optional(string),<br>      type    = string,<br>      ttl     = number<br>      proxied = bool,<br>    }))),<br>    tunnels = optional(list(object({<br>      account_id = string,<br>      name       = string,<br>    }))),<br>    access_applications = optional(list(object({<br>      zone_id                   = string,<br>      name                      = string,<br>      domain                    = optional(string),<br>      type                      = string,<br>      session_duration          = string,<br>      auto_redirect_to_identity = bool,<br>      allowed_idps              = optional(list(string)),<br>      self_hosted_domains       = optional(list(string)),<br>    })))<br>    access_policies = optional(list(object({<br>      application_id = optional(string),<br>      zone_id        = string,<br>      name           = string,<br>      precedence     = number,<br>      decision       = string,<br>      include = object({<br>        login_method  = optional(list(string)),<br>        email_domain  = optional(list(string)),<br>        service_token = optional(list(string)),<br>      }),<br>    }))),<br>    access_service_tokens = optional(list(object({<br>      account_id = string,<br>      name       = string,<br>    })))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_publishing"></a> [service\_publishing](#output\_service\_publishing) | Service Publishing output object. |
<!-- END_TF_DOCS -->