variable "cloudflared" {
  description = "Container instance variable object"
  type = object({
    compartment_ocid         = string
    container_instance_id    = optional(string) # Required for lookup
    availability_domain      = string
    display_name             = string # ^[a-z0-9-]+$
    shape                    = string
    hostname_label           = string # ^[a-z0-9-]+$
    subnet_id                = string
    container_restart_policy = string # ["NEVER", "ALWAYS", "ON_FAILURE"]
    memory_in_gbs            = number
    ocpus                    = number
    containers = list(object({
      display_name          = string
      image_url             = string
      environment_variables = optional(map(string))

      command   = optional(list(string))
      arguments = optional(list(string))

      volume_mounts = optional(list(object({
        volume_name = string
        mount_path  = string
      })))

      resource_config = optional(map(object({
        memory_limit_in_gbs = optional(number)
        vcpus_limit         = optional(number)
      })))

      memory_limit_in_gbs = optional(number)
      vcpus_limit         = optional(number)

      working_directory = optional(string)
    }))
    volumes = optional(list(object({
      name          = string
      volume_type   = string
      backing_store = optional(string)

      configs = optional(list(object({
        data      = optional(string)
        file_name = optional(string)
      })))
    })))
    image_pull_secrets = optional(list(object({
      registry_endpoint = string
      secret_type       = string
      secret_id         = optional(string)
      username          = optional(string)
      password          = optional(string)
    })))
  })
}
