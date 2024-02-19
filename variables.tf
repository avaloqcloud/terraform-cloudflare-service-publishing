variable "service_publishing" {
  description = "Service Publishing input object."
  type = object({
    records = optional(list(object({
      zone_id = string,
      name    = string,
      value   = optional(string),
      type    = string,
      ttl     = number
      proxied = bool,
    }))),
    tunnels = optional(list(object({
      account_id = string,
      name       = string,
    }))),
    access_applications = optional(list(object({
      zone_id                   = string,
      name                      = string,
      domain                    = optional(string),
      type                      = string,
      session_duration          = string,
      auto_redirect_to_identity = bool,
      allowed_idps              = optional(list(string)),
      self_hosted_domains       = optional(list(string)),
    })))
    access_policies = optional(list(object({
      application_id = optional(string),
      zone_id        = string,
      name           = string,
      precedence     = number,
      decision       = string,
      include = object({
        login_method  = optional(list(string)),
        email_domain  = optional(list(string)),
        service_token = optional(list(string)),
      }),
    }))),
    access_service_tokens = optional(list(object({
      account_id = string,
      name       = string,
    })))
    spectrum_applications = optional(list(object({
      zone_id       = string,
      name          = string,
      protocol      = string,
      origin_direct = optional(list(string)),
      origin_dns = optional(object({
        name = string,
      })),
      origin_port = optional(number)
      tls         = optional(string),
    })))
  })
  # Validation:
  ## If tunnel ommited, make sure in Records value is given.
  ### If Specturm application defined mutually exclusive with record.
  ### If Spectrum application, one of origin_direct or origin_dns must be provided and are mutually exclusive.
  ### If Spectrum application origin_dns is not nil, enforce setting of origin_port
  ### If Spectrum application is TCP, enum for tls attribute see (except for "flexible"): https://developers.cloudflare.com/spectrum/reference/configuration-options/#edge-tls-termination.
}