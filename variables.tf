variable "service_publishing" {
  description = "Service Publishing input object."
  type = object({
    records = optional(list(object({
      name    = string,           # The name of the record
      value   = optional(string), # The value of the record. Required if matching tunnel ommited
      type    = optional(string), # The type of the record. Required if matching tunnel ommited
      ttl     = number,           # The TTL of the record.
      proxied = bool,             # Whether the record gets Cloudflare's origin protection.
    }))),
    tunnels = optional(list(object({
      account_id = string,
      name       = string,
      config = optional(object({ # Embedded cloudflare_tunnel_config object
        warp_routing = optional(object({
          enabled = bool, # Whether WARP routing is enabled.
        })),
        default_origin_request = optional(object({
          access = optional(object({
            aud_tag   = optional(list(string)), # Audience tags of the access rule.
            required  = optional(bool),         # Whether the access rule is required.
            team_name = optional(string),       # Name of the team to which the access rule applies.
          })),
          bastion_mode             = optional(bool),   # Runs as jump host
          ca_pool                  = optional(string), # Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare. Defaults to "".
          connect_timeout          = optional(string), # Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by tlsTimeout. Defaults to 30s.
          disable_chunked_encoding = optional(bool),   # Disables chunked transfer encoding. Useful if you are running a Web Server Gateway Interface (WSGI) server. Defaults to false.
          http2_origin             = optional(bool),   # Enables HTTP/2 support for the origin connection. Defaults to false.
          http_host_header         = optional(string), # Sets the HTTP Host header on requests sent to the local service. Defaults to "".
          ip_rules = optional(object({
            allow  = optional(bool),         # Whether to allow the IP prefix.
            ports  = optional(list(number)), # Ports to use within the IP rule.
            prefix = optional(string),       # IP rule prefix.
          })),
          keep_alive_connections = optional(number), # Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections. Defaults to 100.
          keep_alive_timeout     = optional(string), # Timeout after which an idle keepalive connection can be discarded. Defaults to 1m30s.
          no_happy_eyeballs      = optional(bool),   # Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols. Defaults to false.
          no_tls_verify          = optional(bool),   # Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted. Defaults to false.
          origin_server_name     = optional(string), # Hostname that cloudflared should expect from your origin server certificate. Defaults to "".
          proxy_address          = optional(string)  # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy. Defaults to 127.0.0.1.
          proxy_port             = optional(number), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen. Defaults to 0.
          proxy_type             = optional(string), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Available values: "", socks. Defaults to "".
          tcp_keep_alive         = optional(string), # The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server. Defaults to 30s.
          tls_timeout            = optional(string), # Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server. Defaults to 10s.
        })),
        ingress_rules = list(object({        # Each incoming request received by cloudflared causes cloudflared to send a request to a local service. This section configures the rules that determine which requests are sent to which local services.
          hostname = optional(string),       # Hostname to match the incoming request with. If the hostname matches, the request will be sent to the service.
          path     = optional(string),       # Path of the incoming request. If the path matches, the request will be sent to the local service.
          service  = string,                 # Name of the service to which the request will be sent.
          origin_request = optional(object({ # Settings for requests sent to service.
            access = optional(object({
              aud_tag   = optional(list(string)), # Audience tags of the access rule.
              required  = optional(bool),         # Whether the access rule is required.
              team_name = optional(string),       # Name of the team to which the access rule applies.
            })),
            bastion_mode             = optional(bool),   # Runs as jump host
            ca_pool                  = optional(string), # Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare. Defaults to "".
            connect_timeout          = optional(string), # Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by tlsTimeout. Defaults to 30s.
            disable_chunked_encoding = optional(bool),   # Disables chunked transfer encoding. Useful if you are running a Web Server Gateway Interface (WSGI) server. Defaults to false.
            http2_origin             = optional(bool),   # Enables HTTP/2 support for the origin connection. Defaults to false.
            http_host_header         = optional(string), # Sets the HTTP Host header on requests sent to the local service. Defaults to "".
            ip_rules = optional(object({
              allow  = optional(bool),         # Whether to allow the IP prefix.
              ports  = optional(list(number)), # Ports to use within the IP rule.
              prefix = optional(string),       # IP rule prefix.
            })),
            keep_alive_connections = optional(number), # Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections. Defaults to 100.
            keep_alive_timeout     = optional(string), # Timeout after which an idle keepalive connection can be discarded. Defaults to 1m30s.
            no_happy_eyeballs      = optional(bool),   # Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols. Defaults to false.
            no_tls_verify          = optional(bool),   # Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted. Defaults to false.
            origin_server_name     = optional(string), # Hostname that cloudflared should expect from your origin server certificate. Defaults to "".
            proxy_address          = optional(string)  # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy. Defaults to 127.0.0.1.
            proxy_port             = optional(number), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen. Defaults to 0.
            proxy_type             = optional(string), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Available values: "", socks. Defaults to "".
            tcp_keep_alive         = optional(string), # The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server. Defaults to 30s.
            tls_timeout            = optional(string), # Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server. Defaults to 10s.
          })),
        })),
      })),
    }))),
    access_applications = optional(list(object({
      name                      = string,
      domain                    = optional(string),       # The primary hostname and path that Access will secure.
      type                      = string,                 # The application type
      session_duration          = optional(string),       # How often a user will be forced to re-authorise. Must be in the format 48h or 2h45m. Defaults to 24h
      auto_redirect_to_identity = bool,                   # Option to skip identity provider selection if only one is configured in allowed_idps. Defaults to false.
      allowed_idps              = optional(list(string)), # The identity providers selected for the application.
      self_hosted_domains       = optional(list(string)), # List of domains that access will secure. Only present for self_hosted, vnc, and ssh applications. Always includes the value set as domain.
      saas_app = optional(object({
        auth_type = optional(string), # Optional identifier indicating the authentication protocol used for the saas app. Required for OIDC. Default: "saml"
        # SAML
        sp_entity_id         = optional(string), # SAML: A globally unique name for an identity or service provider.
        consumer_service_url = optional(string), # SAML: The service provider's endpoint that is responsible for receiving and parsing a SAML assertion.
        name_id_format       = optional(string), # SAML: The format of the name identifier sent to the SaaS application. Enum: "id" "email". Default: "email".
        custom_attribute = optional(object({     # SAML: Custom attribute mapped from IDPs.
          name          = optional(string),      # SAML: The name of the attribute as provided to the SaaS app.
          name_format   = optional(string),      # SAML: A globally unique name for an identity or service provider.
          friendly_name = optional(string),      # SAML: A friendly name for the attribute as provided to the SaaS app.
          required      = optional(bool),        # SAML: True if the attribute must be always present.
          source = object({
            name = string, # SAML: The name of the attribute as provided by the IDP.
          }),
          default_relay_state       = optional(string), # SAML: The relay state used if not provided by the identity provider.
          name_id_transform_jsonata = optional(string), # SAML: A [JSONata](https://jsonata.org/) expression that transforms an application's user identities into a NameID value for its SAML assertion. This expression should evaluate to a singular string. The output of this expression can override the `name_id_format` setting.
        })),
        # OIDC
        redirect_uris      = optional(list(string)), # OIDC: The permitted URL's for Cloudflare to return Authorization codes and Access/ID tokens. example: ["https://saas-app.example/sso/oauth2/callback"]
        grant_types        = optional(list(string)), # OIDC: The OIDC flows supported by this application. Example: ["authorization_code"]
        scopes             = optional(list(string)), # OIDC: Define the user information shared with access. Example: ["openid", "email", "profile", "groups"]
        app_launcher_url   = optional(string),       # OIDC: The URL where this applications tile redirects users. Example: "https://saas-app.example/sso/login"
        group_filter_regex = optional(string),       # OIDC: A regex to filter Cloudflare groups returned in ID token and userinfo endpoint. Default: ".*"
      }))
    })))
    access_policies = optional(list(object({
      application_id = optional(string),
      name           = string,
      precedence     = number, # The unique precedence for policies on a single application.
      decision       = string, # Defines the action Access will take if the policy matches the user. Available values: allow, deny, non_identity, bypass.
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
      name          = string,
      protocol      = string,                 # The port configuration at Cloudflare's edge. e.g. tcp/22.
      origin_direct = optional(list(string)), # A list of destination addresses to the origin. e.g. tcp://192.0.2.1:22.
      origin_dns = optional(object({          #  A destination DNS addresses to the origin.
        name = string,                        # Fully qualified domain name of the origin.
      })),
      origin_port = optional(number), # Origin port to proxy traffice to.
      tls         = optional(string), # TLS configuration option for Cloudflare to connect to your origin.
    })))
    load_balancers = optional(list(object({
      name    = string,           # The DNS hostname to associate with your load balancer. If this hostname already exists as a DNS record in Cloudflare's DNS, the load balancer will take precedence and the DNS record will not be used.
      enabled = optional(bool),   # Enable or disable the load balancer. Defaults to true.
      proxied = optional(bool),   # Whether the hostname gets Cloudflare's origin protection. Defaults to false. Conflicts with ttl.
      ttl     = optional(number), # Time to live (TTL) of the DNS entry for the IP address returned by this load balancer. This cannot be set for proxied load balancers. Defaults to 30. Conflicts with proxied.
      default_pool = object({     # Embedded cloudflare_load_balancer_pool object
        account_id = string,
        origins = list(object({    # The list of origins within this pool. Traffic directed at this pool is balanced across all currently healthy origins, provided the pool itself is healthy.
          name    = string,        # A human-identifiable name for the origin.
          address = string,        # The IP address (IPv4 or IPv6) of the origin, or the publicly addressable hostname.
          enabled = optional(bool) # Whether this origin is enabled. Disabled origins will not receive traffic and are excluded from health checks. Defaults to true.
          header = optional(object({
            header = string,        # HTTP Header name.
            values = list(string),  # Values for the HTTP headers.
          }))                       # HTTP request headers.
          weight = optional(number) # The weight (0.01 - 1.00) of this origin, relative to other origins in the pool. Equal values mean equal weighting. A weight of 0 means traffic will not be sent to this origin, but health is still checked. When origin_steering.policy="least_outstanding_requests", weight is used to scale the origin's outstanding requests. When origin_steering.policy="least_connections", weight is used to scale the origin's open connections. Defaults to 1.
        }))
        monitor = optional(object({            # Embedded cloudflare_load_balancer_monitor object
          allow_insecure   = optional(string), # Do not validate the certificate when monitor use HTTPS. Only valid if type is "http" or "https".
          consecutive_down = optional(number), # To be marked unhealthy the monitored origin must fail this healthcheck N consecutive times. Defaults to 0.
          consecutive_up   = optional(number), # To be marked healthy the monitored origin must pass this healthcheck N consecutive times. Defaults to 0.
          description      = optional(string), # Free text description.
          expected_body    = optional(string), # A case-insensitive sub-string to look for in the response body. If this string is not found, the origin will be marked as unhealthy. Only valid if type is "http" or "https".
          expected_codes   = optional(string), # The expected HTTP response code or code range of the health check. Eg 2xx. Only valid and required if type is "http" or "https".
          follow_redirects = optional(bool),   # Follow redirects if returned by the origin. Only valid if type is "http" or "https".
          header = optional(object({           # The HTTP request headers to send in the health check. It is recommended you set a Host header by default. The User-Agent header cannot be overridden.
            header = string,                   # HTTP Header name.
            values = list(string),             # Values for the HTTP headers.
          })),
          interval   = optional(number), # The interval between each health check. Shorter intervals may improve failover time, but will increase load on the origins as we check from multiple locations. Defaults to 60.
          method     = optional(string), # The method to use for the health check.
          path       = optional(string), # The endpoint path to health check against.
          port       = optional(number), # The port number to use for the healthcheck, required when creating a TCP monitor.
          probe_zone = optional(string), # Assign this monitor to emulate the specified zone while probing. Only valid if type is "http" or "https".
          retries    = optional(number), # The number of retries to attempt in case of a timeout before marking the origin as unhealthy. Retries are attempted immediately. Defaults to 2.
          timeout    = optional(number), # The timeout (in seconds) before marking the health check as failed. Defaults to 5.
          type       = optional(string), # The protocol to use for the healthcheck. Available values: http, https, tcp, udp_icmp, icmp_ping, smtp. Defaults to http.
        }))
      })
      session_affinity     = optional(string),           # Specifies the type of session affinity the load balancer should use unless specified as none or "" (default). With value cookie, on the first request to a proxied load balancer, a cookie is generated, encoding information of which origin the request will be forwarded to. Subsequent requests, by the same client to the same load balancer, will be sent to the origin server the cookie encodes, for the duration of the cookie and as long as the origin server remains healthy. If the cookie has expired or the origin server is unhealthy then a new origin server is calculated and used. Value ip_cookie behaves the same as cookie except the initial origin selection is stable and based on the client's IP address. Available values: "", none, cookie, ip_cookie, header. Defaults to none.
      session_affinity_ttl = optional(number),           # Time, in seconds, until this load balancer's session affinity cookie expires after being created. This parameter is ignored unless a supported session affinity policy is set. The current default of 82800 (23 hours) will be used unless session_affinity_ttl is explicitly set. Once the expiry time has been reached, subsequent requests may get sent to a different origin server. Valid values are between 1800 and 604800.
      session_affinity_attributes = optional(object({    # Configure attributes for session affinity.
        drain_duration         = optional(number),       # Configures the drain duration in seconds. This field is only used when session affinity is enabled on the load balancer. Defaults to 0.
        headers                = optional(list(string)), # Configures the HTTP header names to use when header session affinity is enabled.
        require_all_headers    = optional(bool),         # Configures how headers are used when header session affinity is enabled. Set to true to require all headers to be present on requests in order for sessions to be created or false to require at least one header to be present. Defaults to false.
        samesite               = optional(string),       # onfigures the SameSite attribute on session affinity cookie. Value Auto will be translated to Lax or None depending if Always Use HTTPS is enabled. Note: when using value None, then you can not set secure="Never". Available values: Auto, Lax, None, Strict. Defaults to Auto.
        secure                 = optional(string),       # Configures the Secure attribute on session affinity cookie. Value Always indicates the Secure attribute will be set in the Set-Cookie header, Never indicates the Secure attribute will not be set, and Auto will set the Secure attribute depending if Always Use HTTPS is enabled. Available values: Auto, Always, Never. Defaults to Auto.
        zero_downtime_failover = optional(string),       # Configures the zero-downtime failover between origins within a pool when session affinity is enabled. Value none means no failover takes place for sessions pinned to the origin. Value temporary means traffic will be sent to another other healthy origin until the originally pinned origin is available; note that this can potentially result in heavy origin flapping. Value sticky means the session affinity cookie is updated and subsequent requests are sent to the new origin. This feature is currently incompatible with Argo, Tiered Cache, and Bandwidth Alliance. Available values: none, temporary, sticky. Defaults to none.
      }))
      rules = optional(list(object({       #  A list of rules for this load balancer to execute.
        name      = string,                # Human readable name for this rule.
        condition = optional(string),      # The statement to evaluate to determine if this rule's effects should be applied. An empty condition is always true.
        disabled  = optional(bool),        # A disabled rule will not be executed.
        fixed_response = optional(object({ # Settings for a HTTP response to return directly to the eyeball if the condition is true. Note: overrides or fixed_response must be set. 
          content_type = optional(string), # The value of the HTTP context-type header for this fixed response.
          location     = optional(string), # The value of the HTTP location header for this fixed response.
          message_body = optional(string), # The text used as the html body for this fixed response.
          status_code  = optional(number), # The HTTP status code used for this fixed response.
        })),
        overrides = optional(list(object({                # The load balancer settings to alter if this rule's condition is true. Note: overrides or fixed_response must be set.
          default_pools        = optional(list(string)),  # A list of pool IDs ordered by their failover priority. Used whenever pop_pools/country_pools/region_pools are not defined.
          ttl                  = optional(number),        # Time to live (TTL) of the DNS entry for the IP address returned by this load balancer. This cannot be set for proxied load balancers. Defaults to 30.
          session_affinity     = optional(string),        # Specifies the type of session affinity the load balancer should use unless specified as none or "" (default). With value cookie, on the first request to a proxied load balancer, a cookie is generated, encoding information of which origin the request will be forwarded to. Subsequent requests, by the same client to the same load balancer, will be sent to the origin server the cookie encodes, for the duration of the cookie and as long as the origin server remains healthy. If the cookie has expired or the origin server is unhealthy then a new origin server is calculated and used. Value ip_cookie behaves the same as cookie except the initial origin selection is stable and based on the client's IP address. Available values: "", none, cookie, ip_cookie, header. Defaults to none.
          session_affinity_ttl = optional(number),        # Time, in seconds, until this load balancer's session affinity cookie expires after being created. This parameter is ignored unless a supported session affinity policy is set. The current default of 82800 (23 hours) will be used unless session_affinity_ttl is explicitly set. Once the expiry time has been reached, subsequent requests may get sent to a different origin server. Valid values are between 1800 and 604800.
          session_affinity_attributes = optional(object({ # Configure attributes for session affinity.
            # not yet supported drain_duration         = optional(number),       # Configures the drain duration in seconds. This field is only used when session affinity is enabled on the load balancer. Defaults to 0.
            headers                = optional(list(string)), # Configures the HTTP header names to use when header session affinity is enabled.
            require_all_headers    = optional(bool),         # Configures how headers are used when header session affinity is enabled. Set to true to require all headers to be present on requests in order for sessions to be created or false to require at least one header to be present. Defaults to false.
            samesite               = optional(string),       # onfigures the SameSite attribute on session affinity cookie. Value Auto will be translated to Lax or None depending if Always Use HTTPS is enabled. Note: when using value None, then you can not set secure="Never". Available values: Auto, Lax, None, Strict. Defaults to Auto.
            secure                 = optional(string),       # Configures the Secure attribute on session affinity cookie. Value Always indicates the Secure attribute will be set in the Set-Cookie header, Never indicates the Secure attribute will not be set, and Auto will set the Secure attribute depending if Always Use HTTPS is enabled. Available values: Auto, Always, Never. Defaults to Auto.
            zero_downtime_failover = optional(string),       # Configures the zero-downtime failover between origins within a pool when session affinity is enabled. Value none means no failover takes place for sessions pinned to the origin. Value temporary means traffic will be sent to another other healthy origin until the originally pinned origin is available; note that this can potentially result in heavy origin flapping. Value sticky means the session affinity cookie is updated and subsequent requests are sent to the new origin. This feature is currently incompatible with Argo, Tiered Cache, and Bandwidth Alliance. Available values: none, temporary, sticky. Defaults to none.
          })),
        }))),
        priority   = optional(number), # Priority used when determining the order of rule execution. Lower values are executed first. If not provided, the list order will be used.
        terminates = optional(bool),   # Terminates indicates that if this rule is true no further rules should be executed. Note: setting a fixed_response forces this field to true.
      }))),
    })))
  })
  # Validation
  ## Record
  ### type
  validation {
    condition = (var.service_publishing != null && var.service_publishing.records != null) ? (
      alltrue(flatten([
        for r in var.service_publishing.records :
        (r.type != null) ? (
          contains(["A", "AAAA", "CAA", "CNAME", "TXT", "SRV", "MX", "NS", "SPF", "PTR", ], r.type)
        ) : true
      ]))
    ) : true
    error_message = "Attribute 'type' for Record must be one of: 'A', 'AAAA', 'CAA', 'CNAME', 'TXT', 'SRV', 'MX', 'NS', 'SPF', 'PTR'."
  }
  #### value (only if tunnel ommited - with matching name)
  validation {
    condition = (var.service_publishing != null && var.service_publishing.records != null) && (var.service_publishing.tunnels == null) ? (
      alltrue(flatten([
        for r in var.service_publishing.records :
        (r.value != null || r.type != null)
      ]))
    ) : true
    error_message = "Attributes 'value' and 'type' for Record must be specified if matching Tunnel ommited."
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
  ## Tunnel
  ### t.config.ingress_rules
  validation {
    condition = (var.service_publishing != null && var.service_publishing.tunnels != null) ? (
      alltrue(flatten([
        for t in var.service_publishing.tunnels :
        (
          (t.config != null) ? (
            (element(t.config.ingress_rules, length(t.config.ingress_rules) - 1).hostname != null) || (element(t.config.ingress_rules, length(t.config.ingress_rules) - 1).path != null) ? false : true
          ) : true
        )
      ]))
    ) : true
    error_message = "Attributes 'hostname' and 'path' must not be set in the last tunnel.config.ingress_rules rule as it must match all requests. Example: {'service': 'http_status:502'}."
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
    error_message = "Either attribute 'origin_direct' or 'origin_dns' must be set for Spectrum Application."
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
  ## Load Balancer
  ### ttl and proxied
  validation {
    condition = (var.service_publishing != null && var.service_publishing.load_balancers != null) ? (
      alltrue(flatten([
        for lb in var.service_publishing.load_balancers :
        (lb.proxied == true) ? (
          (lb.ttl != null) ? false : true
        ) : true
      ]))
    ) : true
    error_message = "Attribute 'ttl' must not be set if 'proxied' is true for the same Load Balancer. Ommit attribute 'proxied' if you wish to set the 'ttl' attribute."
  }
  ### rules.fixed_response and rules.overrides
  validation {
    condition = (var.service_publishing != null && var.service_publishing.load_balancers != null) ? (
      alltrue(flatten([
        for lb in var.service_publishing.load_balancers :
        (lb.rules != null) ? (
          (
            alltrue(flatten([
              for r in lb.rules :
              (r.fixed_response != null) && (r.overrides != null) ? false : true
            ]))
          )
        ) : true
      ]))
    ) : true
    error_message = "Attributes 'rules.fixed_response' and 'rules.overrides' cannot be set at the same time for Load Balancer."
  }
  ### default_pool.origins.address
  validation {
    condition = (var.service_publishing != null && var.service_publishing.load_balancers != null) ? (
      alltrue(flatten([
        for lb in var.service_publishing.load_balancers :
        (
          (length(lb.default_pool.origins[*].address) != length(distinct(lb.default_pool.origins[*].address))) ? false : true
        )
      ]))
    ) : true
    error_message = "Attribute 'default_pool.origins.address' must be unique in the same Load Balancer."
  }
}