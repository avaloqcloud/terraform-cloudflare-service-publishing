Terraform module to create a simple Cloudflare Tunnel by using Container Instances

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudflared"></a> [cloudflared](#module\_cloudflared) | git::https://github.com/avaloqcloud/terraform-oci-container-instance.git | new-approach |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudflared"></a> [cloudflared](#input\_cloudflared) | Container instance variable object | <pre>object({<br>    compartment_ocid         = string<br>    container_instance_id    = optional(string) # Required for lookup<br>    availability_domain      = string<br>    display_name             = string # ^[a-z0-9-]+$<br>    shape                    = string<br>    hostname_label           = string # ^[a-z0-9-]+$<br>    subnet_id                = string<br>    container_restart_policy = string # ["NEVER", "ALWAYS", "ON_FAILURE"]<br>    memory_in_gbs            = number<br>    ocpus                    = number<br>    containers = list(object({<br>      display_name          = string<br>      image_url             = string<br>      environment_variables = optional(map(string))<br><br>      command   = optional(list(string))<br>      arguments = optional(list(string))<br><br>      volume_mounts = optional(list(object({<br>        volume_name = string<br>        mount_path  = string<br>      })))<br><br>      resource_config = optional(map(object({<br>        memory_limit_in_gbs = optional(number)<br>        vcpus_limit         = optional(number)<br>      })))<br><br>      memory_limit_in_gbs = optional(number)<br>      vcpus_limit         = optional(number)<br><br>      working_directory = optional(string)<br>    }))<br>    volumes = optional(list(object({<br>      name          = string<br>      volume_type   = string<br>      backing_store = optional(string)<br><br>      configs = optional(list(object({<br>        data      = optional(string)<br>        file_name = optional(string)<br>      })))<br>    })))<br>    image_pull_secrets = optional(list(object({<br>      registry_endpoint = string<br>      secret_type       = string<br>      secret_id         = optional(string)<br>      username          = optional(string)<br>      password          = optional(string)<br>    })))<br>  })</pre> | n/a | yes |

## Outputs

No outputs.
