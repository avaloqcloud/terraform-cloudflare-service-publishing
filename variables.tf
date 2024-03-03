variable "service_publishing" {
  description = "Service Publishing input object."
  type = object({
    records = optional(list(object({
      zone_id = string,
      name    = string,
      value   = optional(string), # required if matching tunnel ommited
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
      saas_app = optional(object({
        auth_type          = optional(string),
        redirect_uris      = optional(list(string)), # OIDC: The permitted URL's for Cloudflare to return Authorization codes and Access/ID tokens. example: ["https://saas-app.example/sso/oauth2/callback"]
        grant_types        = optional(list(string)), # OIDC: The OIDC flows supported by this application. Example: ["authorization_code"]
        scopes             = optional(list(string)), # OIDC: Define the user information shared with access. Example: ["openid", "email", "profile", "groups"]
        app_launcher_url   = optional(string),       # OIDC: The URL where this applications tile redirects users. Example: "https://saas-app.example/sso/login"
        group_filter_regex = optional(string),       # OIDC: A regex to filter Cloudflare groups returned in ID token and userinfo endpoint. Default: ".*"
      }))
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
  # Validation
  ## Record
  ### type
  validation {
    condition = (var.service_publishing != null && var.service_publishing.records != null) ? (
      alltrue(flatten([
        for r in var.service_publishing.records :
        contains(["A", "AAAA", "CAA", "CNAME", "TXT", "SRV", "MX", "NS", "SPF", "PTR", ], r.type)
      ]))
    ) : true
    error_message = "Attribute 'type' for Record must be one of: 'A', 'AAAA', 'CAA', 'CNAME', 'TXT', 'SRV', 'MX', 'NS', 'SPF', 'PTR'."
  }
  #### value (only if tunnel ommited - with matching name)
  validation {
    condition = (var.service_publishing != null && var.service_publishing.records != null) && (var.service_publishing.tunnels == null) ? (
      alltrue(flatten([
        for r in var.service_publishing.records :
        r.value != null
      ]))
    ) : true
    error_message = "Attribute 'value' for Record must be specified if matching Tunnel ommited."
  }
  ## Access Application
  ### type
  validation {
    condition = (var.service_publishing != null && var.service_publishing.access_applications != null) ? (
      alltrue(flatten([
        for aa in var.service_publishing.access_applications :
        contains(["bookmark", "saas", "self_hosted", "ssh", ], aa.type)
      ]))
    ) : true
    error_message = "Attribute 'type' for Access Application must be one of: 'bookmark', 'saas', 'self_hosted', 'ssh'."
  }
  ### saas (if type = saas and saas_app.auth_type = oidc)
  validation {
    condition = (var.service_publishing != null && var.service_publishing.access_applications != null) ? (
      alltrue(flatten([
        for aa in var.service_publishing.access_applications :
        (
          (aa.type == "saas") ? (
            (aa.saas_app.auth_type == "oidc") ? (
              (aa.saas_app.redirect_uris != null && aa.saas_app.grant_types != null && aa.saas_app.scopes != null && aa.saas_app.app_launcher_url != null) ? true : false
            ) : true
          ) : true
        )
      ]))
    ) : true
    error_message = "Attributes 'redirect_uris', 'grant_types', 'scopes' and 'app_launcher_url' must be set if Access Application 'type' is 'saas' and 'saas_app.auth_type' is 'oidc'."
  }
  ## Spectrum Application
  ### origin_direct or origin_dns (mutually exclusive)
  validation {
    condition = (var.service_publishing != null && var.service_publishing.spectrum_applications != null) ? (
      alltrue(flatten([
        for sa in var.service_publishing.spectrum_applications :
        (
          sa.origin_direct != null || sa.origin_dns != null
        )
      ]))
    ) : true
    error_message = "Either attribute 'origin_direct' or 'origin_dns' must be setfor Spectrum Application."
  }
  validation {
    condition = (var.service_publishing != null && var.service_publishing.spectrum_applications != null) ? (
      alltrue(flatten([
        for sa in var.service_publishing.spectrum_applications :
        (
          (sa.origin_direct != null) && (sa.origin_dns != null) ? false : true
        )
      ]))
    ) : true
    error_message = "Attributes 'origin_direct' and 'origin_dns' cannot be set at the same time for Spectrum Application."
  }
  ### origin_dns and origin_port
  validation {
    condition = (var.service_publishing != null && var.service_publishing.spectrum_applications != null) ? (
      alltrue(flatten([
        for sa in var.service_publishing.spectrum_applications :
        (
          (sa.origin_dns != null) ? (sa.origin_port != null ? true : false) : true
        )
      ]))
    ) : true
    error_message = "Attribute 'origin_direct' requires attribute 'origin_port' to be set for Spectrum Application."
  }
  ###If Specturm application defined mutually exclusive with record.
  ### tls (only for TCP)
  /*
    strcontains available from TF v1.5.x
    validation {
      condition = (var.service_publishing != null && var.service_publishing.spectrum_applications != null) ? (
        alltrue(flatten([
          for sp in var.service_publishing.spectrum_applications :
            (
              strcontains(sp.protocol, "tcp") && contains(["full", "strict"], sp.tls) ? false : true
            )
        ]))
      ) : true
      error_message = "Attribute 'tls' for Spectrum Application must be one of: 'full', 'strict' (if protocol is 'tcp')."
    }
  */
}