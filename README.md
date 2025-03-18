# Terraform Cloudflare Service Publishing
Provides a reusable Terraform module to publish services via Cloudflare.
<details><summary>Examples</summary>
<p>

## Example Input
### DNS Record (not proxied)
`service-publishing.auto.tfvars.json`:
```json
{
    "service_publishing": {
        "records": [
            {
                "name": "example.service.example.com",
                "value": "198.51.100.4",
                "type": "A",
                "ttl": 1,
                "proxied": false
            }
        ]
    }
}
```

### Public Tunnel with remote config
`service-publishing.auto.tfvars.json`:
```json
{
    "service_publishing": {
        "tunnels": [
            {
                "account_id": "699d98642c564d2e855e9661899b7252",
                "name": "example.service.example.com",
                "config": {
                    "ingress_rules": [
                        {
                            "hostname": "example.service.example.com",
                            "service": "hello_world"
                        },
                        {
                            "service": "http_status:404"
                        }
                    ]
                }
            }
        ]
    }
}
```

### Public Tunnel with remote config and matching DNS Record
`service-publishing.auto.tfvars.json`:
```json
{
    "service_publishing": {
        "records": [
            {
                "name": "example.service.example.com",
                "ttl": 1,
                "proxied": true
            }
        ],
        "tunnels": [
            {
                "account_id": "699d98642c564d2e855e9661899b7252",
                "name": "example.service.example.com",
                "config": {
                    "ingress_rules": [
                        {
                            "hostname": "example.service.example.com",
                            "service": "hello_world"
                        },
                        {
                            "service": "http_status:404"
                        }
                    ]
                }
            }
        ]
    }
}
```

### ZeroTrust Tunnel with remote config and matching DNS Record
`service-publishing.auto.tfvars.json`:
```json
{
    "service_publishing": {
        "records": [
            {
                "name": "example.service.example.com",
                "ttl": 1,
                "proxied": true
            }
        ],
        "tunnels": [
            {
                "account_id": "699d98642c564d2e855e9661899b7252",
                "name": "example.service.example.com",
                "config": {
                    "ingress_rules": [
                        {
                            "hostname": "example.service.example.com",
                            "service": "http://127.0.0.1:8080"
                        },
                        {
                            "service": "http_status:404"
                        }
                    ]
                }
            }
        ],
        "access_applications": [
            {
                "name": "example.service.example.com",
                "domain": "example.service.example.com",
                "type": "self_hosted",
                "auto_redirect_to_identity": true,
                "allowed_idps": [
                    "76a06b02-7c6b-474d-886e-b743a61be458"
                ]
            }
        ],
        "access_policies": [
            {
                "name"           : "example.service.example.com",
                "precedence"     : 1,
                "decision"       : "allow",
                "include"        : {
                    "login_method": [
                        "76a06b02-7c6b-474d-886e-b743a61be458"
                    ],
                    "email_domain": [
                        "example.com"
                    ]
                }
            }
        ]
    }
}
```

### ZeroTrust (service token) Tunnel with remote config and matching DNS Record
`service-publishing.auto.tfvars.json`:
```json
{
    "service_publishing": {
        "records": [
            {
                "name": "example.service.example.com",
                "ttl": 1,
                "proxied": true
            }
        ],
        "tunnels": [
            {
                "account_id": "699d98642c564d2e855e9661899b7252",
                "name": "example.service.example.com",
                "config": {
                    "ingress_rules": [
                        {
                            "hostname": "example.service.example.com",
                            "service": "http://127.0.0.1:8080"
                        },
                        {
                            "service": "http_status:404"
                        }
                    ]
                }
            }
        ],
        "access_applications": [
            {
                "name": "example.service.example.com",
                "domain": "example.service.example.com",
                "type": "self_hosted",
                "auto_redirect_to_identity": false,
                "session_duration": "1h"
            }
        ],
        "access_policies": [
            {
                "name"           : "example.service.example.com",
                "precedence"     : 1,
                "decision"       : "non_identity",
                "include"        : {}
            }
        ],
        "access_service_tokens": [
            {
                "account_id": "699d98642c564d2e855e9661899b7252",
                "name": "example.service.example.com"
            }
        ]
    }
}
```

### Spectrum Application (origin_dns)
`service-publishing.auto.tfvars.json`:
```json
{
    "service_publishing": {
        "spectrum_applications": [
            {
                "name": "example.service.example.com",
                "protocol": "tcp/443",
                "origin_dns": {
                    "name": "grafana.service.example.com"
                },
                "origin_port": 443,
                "tls": "full"
            }
        ]
    }
}
```

### Spectrum Application (origin_direct)
`service-publishing.auto.tfvars.json`:
```json
{
    "service_publishing": {
        "spectrum_applications": [
            {
                "name": "example.service.example.com",
                "protocol": "tcp/587",
                "origin_direct": [
                    "tcp://198.51.100.4"
                ],
                "tls": "full"
            }
        ]
    }
}
```

### ZeroTrust Tunnel with remote config, OCID app and matching DNS Record
`service-publishing.auto.tfvars.json`:
```json
{
    "service_publishing": {
        "records": [
            {
                "name": "grafana.service.example.com",
                "ttl": 1,
                "proxied": true
            }
        ],
        "tunnels": [
            {
                "account_id": "699d98642c564d2e855e9661899b7252",
                "name": "grafana.service.example.com",
                "config": {
                    "ingress_rules": [
                        {
                            "hostname": "grafana.service.example.com",
                            "service": "http://127.0.0.1:9000"
                        },
                        {
                            "service": "http_status:404"
                        }
                    ]
                }
            }
        ],
        "access_applications": [
            {
                "name": "grafana.service.example.com",
                "domain": "grafana.service.example.com",
                "type": "saas",
                "auto_redirect_to_identity": true,
                "allowed_idps": [
                    "76a06b02-7c6b-474d-886e-b743a61be458"
                ],
				"saas_app": {
					"auth_type": "oidc",
					"redirect_uris": ["https://grafana.service.example.com/login/generic_oauth"],
					"grant_types": ["authorization_code"],
					"scopes": ["openid", "email", "profile", "groups"],
					"app_launcher_url": "https://grafana.service.example.com"
				}
            }
        ],
        "access_policies": [
            {
                "name"           : "grafana.service.example.com",
                "precedence"     : 1,
                "decision"       : "allow",
                "include"        : {
                    "login_method": [
                        "76a06b02-7c6b-474d-886e-b743a61be458"
                    ],
                    "email_domain": [
                        "example.com"
                    ]
                }
            }
        ]
    }
}
```

</p>
</details>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.3 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.52 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 4.52 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_zero_trust_access_application.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/access_application) | resource |
| [cloudflare_zero_trust_access_policy.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/access_policy) | resource |
| [cloudflare_zero_trust_access_service_token.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/access_service_token) | resource |
| [cloudflare_load_balancer.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/load_balancer) | resource |
| [cloudflare_load_balancer_monitor.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/load_balancer_monitor) | resource |
| [cloudflare_load_balancer_pool.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/load_balancer_pool) | resource |
| [cloudflare_record.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [cloudflare_spectrum_application.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/spectrum_application) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/tunnel) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared_config.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/tunnel_config) | resource |
| [random_id.these](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [cloudflare_zone.these](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service_publishing"></a> [service\_publishing](#input\_service\_publishing) | Service Publishing input object. | <pre>object({<br>    records = optional(list(object({<br>      name    = string,           # The name of the record<br>      value   = optional(string), # The value of the record. Required if matching tunnel ommited<br>      type    = optional(string), # The type of the record. Required if matching tunnel ommited<br>      ttl     = number,           # The TTL of the record.<br>      proxied = bool,             # Whether the record gets Cloudflare's origin protection.<br>    }))),<br>    tunnels = optional(list(object({<br>      account_id = string,<br>      name       = string,<br>      config = optional(object({ # Embedded cloudflare_zero_trust_tunnel_cloudflared_config object<br>        warp_routing = optional(object({<br>          enabled = bool, # Whether WARP routing is enabled.<br>        })),<br>        default_origin_request = optional(object({<br>          access = optional(object({<br>            aud_tag   = optional(list(string)), # Audience tags of the access rule.<br>            required  = optional(bool),         # Whether the access rule is required.<br>            team_name = optional(string),       # Name of the team to which the access rule applies.<br>          })),<br>          bastion_mode             = optional(bool),   # Runs as jump host<br>          ca_pool                  = optional(string), # Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare. Defaults to "".<br>          connect_timeout          = optional(string), # Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by tlsTimeout. Defaults to 30s.<br>          disable_chunked_encoding = optional(bool),   # Disables chunked transfer encoding. Useful if you are running a Web Server Gateway Interface (WSGI) server. Defaults to false.<br>          http2_origin             = optional(bool),   # Enables HTTP/2 support for the origin connection. Defaults to false.<br>          http_host_header         = optional(string), # Sets the HTTP Host header on requests sent to the local service. Defaults to "".<br>          ip_rules = optional(object({<br>            allow  = optional(bool),         # Whether to allow the IP prefix.<br>            ports  = optional(list(number)), # Ports to use within the IP rule.<br>            prefix = optional(string),       # IP rule prefix.<br>          })),<br>          keep_alive_connections = optional(number), # Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections. Defaults to 100.<br>          keep_alive_timeout     = optional(string), # Timeout after which an idle keepalive connection can be discarded. Defaults to 1m30s.<br>          no_happy_eyeballs      = optional(bool),   # Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols. Defaults to false.<br>          no_tls_verify          = optional(bool),   # Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted. Defaults to false.<br>          origin_server_name     = optional(string), # Hostname that cloudflared should expect from your origin server certificate. Defaults to "".<br>          proxy_address          = optional(string)  # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy. Defaults to 127.0.0.1.<br>          proxy_port             = optional(number), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen. Defaults to 0.<br>          proxy_type             = optional(string), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Available values: "", socks. Defaults to "".<br>          tcp_keep_alive         = optional(string), # The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server. Defaults to 30s.<br>          tls_timeout            = optional(string), # Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server. Defaults to 10s.<br>        })),<br>        ingress_rules = list(object({        # Each incoming request received by cloudflared causes cloudflared to send a request to a local service. This section configures the rules that determine which requests are sent to which local services.<br>          hostname = optional(string),       # Hostname to match the incoming request with. If the hostname matches, the request will be sent to the service.<br>          path     = optional(string),       # Path of the incoming request. If the path matches, the request will be sent to the local service.<br>          service  = string,                 # Name of the service to which the request will be sent.<br>          origin_request = optional(object({ # Settings for requests sent to service.<br>            access = optional(object({<br>              aud_tag   = optional(list(string)), # Audience tags of the access rule.<br>              required  = optional(bool),         # Whether the access rule is required.<br>              team_name = optional(string),       # Name of the team to which the access rule applies.<br>            })),<br>            bastion_mode             = optional(bool),   # Runs as jump host<br>            ca_pool                  = optional(string), # Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare. Defaults to "".<br>            connect_timeout          = optional(string), # Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by tlsTimeout. Defaults to 30s.<br>            disable_chunked_encoding = optional(bool),   # Disables chunked transfer encoding. Useful if you are running a Web Server Gateway Interface (WSGI) server. Defaults to false.<br>            http2_origin             = optional(bool),   # Enables HTTP/2 support for the origin connection. Defaults to false.<br>            http_host_header         = optional(string), # Sets the HTTP Host header on requests sent to the local service. Defaults to "".<br>            ip_rules = optional(object({<br>              allow  = optional(bool),         # Whether to allow the IP prefix.<br>              ports  = optional(list(number)), # Ports to use within the IP rule.<br>              prefix = optional(string),       # IP rule prefix.<br>            })),<br>            keep_alive_connections = optional(number), # Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections. Defaults to 100.<br>            keep_alive_timeout     = optional(string), # Timeout after which an idle keepalive connection can be discarded. Defaults to 1m30s.<br>            no_happy_eyeballs      = optional(bool),   # Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols. Defaults to false.<br>            no_tls_verify          = optional(bool),   # Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted. Defaults to false.<br>            origin_server_name     = optional(string), # Hostname that cloudflared should expect from your origin server certificate. Defaults to "".<br>            proxy_address          = optional(string)  # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy. Defaults to 127.0.0.1.<br>            proxy_port             = optional(number), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen. Defaults to 0.<br>            proxy_type             = optional(string), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Available values: "", socks. Defaults to "".<br>            tcp_keep_alive         = optional(string), # The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server. Defaults to 30s.<br>            tls_timeout            = optional(string), # Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server. Defaults to 10s.<br>          })),<br>        })),<br>      })),<br>    }))),<br>    access_applications = optional(list(object({<br>      name                      = string,<br>      domain                    = optional(string),       # The primary hostname and path that Access will secure.<br>      type                      = string,                 # The application type<br>      session_duration          = optional(string),       # How often a user will be forced to re-authorise. Must be in the format 48h or 2h45m. Defaults to 24h<br>      auto_redirect_to_identity = bool,                   # Option to skip identity provider selection if only one is configured in allowed_idps. Defaults to false.<br>      allowed_idps              = optional(list(string)), # The identity providers selected for the application.<br>      self_hosted_domains       = optional(list(string)), # List of domains that access will secure. Only present for self_hosted, vnc, and ssh applications. Always includes the value set as domain.<br>      saas_app = optional(object({<br>        auth_type = optional(string), # Optional identifier indicating the authentication protocol used for the saas app. Required for OIDC. Default: "saml"<br>        # SAML<br>        sp_entity_id         = optional(string), # SAML: A globally unique name for an identity or service provider.<br>        consumer_service_url = optional(string), # SAML: The service provider's endpoint that is responsible for receiving and parsing a SAML assertion.<br>        name_id_format       = optional(string), # SAML: The format of the name identifier sent to the SaaS application. Enum: "id" "email". Default: "email".<br>        custom_attribute = optional(object({     # SAML: Custom attribute mapped from IDPs.<br>          name          = optional(string),      # SAML: The name of the attribute as provided to the SaaS app.<br>          name_format   = optional(string),      # SAML: A globally unique name for an identity or service provider.<br>          friendly_name = optional(string),      # SAML: A friendly name for the attribute as provided to the SaaS app.<br>          required      = optional(bool),        # SAML: True if the attribute must be always present.<br>          source = object({<br>            name = string, # SAML: The name of the attribute as provided by the IDP.<br>          }),<br>          default_relay_state              = optional(string), # SAML: The relay state used if not provided by the identity provider.<br>          name_id_transform_jsonata        = optional(string), # SAML: A [JSONata](https://jsonata.org/) expression that transforms an application's user identities into a NameID value for its SAML assertion. This expression should evaluate to a singular string. The output of this expression can override the `name_id_format` setting.<br>          saml_attribute_transform_jsonata = optional(string), # SAML: A [JSONata](https://jsonata.org/) expression that transforms an application's user identities into attribute assertions in the SAML response. The expression can transform id, email, name, and groups values. It can also transform fields listed in the saml_attributes or oidc_fields of the identity provider used to authenticate. The output of this expression must be a JSON object.<br>        })),<br>        # OIDC<br>        redirect_uris      = optional(list(string)), # OIDC: The permitted URL's for Cloudflare to return Authorization codes and Access/ID tokens. example: ["https://saas-app.example/sso/oauth2/callback"]<br>        grant_types        = optional(list(string)), # OIDC: The OIDC flows supported by this application. Example: ["authorization_code"]<br>        scopes             = optional(list(string)), # OIDC: Define the user information shared with access. Example: ["openid", "email", "profile", "groups"]<br>        app_launcher_url   = optional(string),       # OIDC: The URL where this applications tile redirects users. Example: "https://saas-app.example/sso/login"<br>        group_filter_regex = optional(string),       # OIDC: A regex to filter Cloudflare groups returned in ID token and userinfo endpoint. Default: ".*"<br>      }))<br>    })))<br>    access_policies = optional(list(object({<br>      application_id = optional(string),<br>      name           = string,<br>      precedence     = number, # The unique precedence for policies on a single application.<br>      decision       = string, # Defines the action Access will take if the policy matches the user. Available values: allow, deny, non_identity, bypass.<br>      include = object({<br>        login_method  = optional(list(string)),<br>        email_domain  = optional(list(string)),<br>        service_token = optional(list(string)),<br>      }),<br>    }))),<br>    access_service_tokens = optional(list(object({<br>      account_id = string,<br>      name       = string,<br>    })))<br>    spectrum_applications = optional(list(object({<br>      name          = string,<br>      protocol      = string,                 # The port configuration at Cloudflare's edge. e.g. tcp/22.<br>      origin_direct = optional(list(string)), # A list of destination addresses to the origin. e.g. tcp://192.0.2.1:22.<br>      origin_dns = optional(object({          #  A destination DNS addresses to the origin.<br>        name = string,                        # Fully qualified domain name of the origin.<br>      })),<br>      origin_port = optional(number), # Origin port to proxy traffice to.<br>      tls         = optional(string), # TLS configuration option for Cloudflare to connect to your origin.<br>    })))<br>    load_balancers = optional(list(object({<br>      name    = string,           # The DNS hostname to associate with your load balancer. If this hostname already exists as a DNS record in Cloudflare's DNS, the load balancer will take precedence and the DNS record will not be used.<br>      enabled = optional(bool),   # Enable or disable the load balancer. Defaults to true.<br>      proxied = optional(bool),   # Whether the hostname gets Cloudflare's origin protection. Defaults to false. Conflicts with ttl.<br>      ttl     = optional(number), # Time to live (TTL) of the DNS entry for the IP address returned by this load balancer. This cannot be set for proxied load balancers. Defaults to 30. Conflicts with proxied.<br>      default_pool = object({     # Embedded cloudflare_load_balancer_pool object<br>        account_id = string,<br>        origins = list(object({    # The list of origins within this pool. Traffic directed at this pool is balanced across all currently healthy origins, provided the pool itself is healthy.<br>          name    = string,        # A human-identifiable name for the origin.<br>          address = string,        # The IP address (IPv4 or IPv6) of the origin, or the publicly addressable hostname.<br>          enabled = optional(bool) # Whether this origin is enabled. Disabled origins will not receive traffic and are excluded from health checks. Defaults to true.<br>          header = optional(object({<br>            header = string,        # HTTP Header name.<br>            values = list(string),  # Values for the HTTP headers.<br>          }))                       # HTTP request headers.<br>          weight = optional(number) # The weight (0.01 - 1.00) of this origin, relative to other origins in the pool. Equal values mean equal weighting. A weight of 0 means traffic will not be sent to this origin, but health is still checked. When origin_steering.policy="least_outstanding_requests", weight is used to scale the origin's outstanding requests. When origin_steering.policy="least_connections", weight is used to scale the origin's open connections. Defaults to 1.<br>        }))<br>        monitor = optional(object({            # Embedded cloudflare_load_balancer_monitor object<br>          allow_insecure   = optional(string), # Do not validate the certificate when monitor use HTTPS. Only valid if type is "http" or "https".<br>          consecutive_down = optional(number), # To be marked unhealthy the monitored origin must fail this healthcheck N consecutive times. Defaults to 0.<br>          consecutive_up   = optional(number), # To be marked healthy the monitored origin must pass this healthcheck N consecutive times. Defaults to 0.<br>          description      = optional(string), # Free text description.<br>          expected_body    = optional(string), # A case-insensitive sub-string to look for in the response body. If this string is not found, the origin will be marked as unhealthy. Only valid if type is "http" or "https".<br>          expected_codes   = optional(string), # The expected HTTP response code or code range of the health check. Eg 2xx. Only valid and required if type is "http" or "https".<br>          follow_redirects = optional(bool),   # Follow redirects if returned by the origin. Only valid if type is "http" or "https".<br>          header = optional(object({           # The HTTP request headers to send in the health check. It is recommended you set a Host header by default. The User-Agent header cannot be overridden.<br>            header = string,                   # HTTP Header name.<br>            values = list(string),             # Values for the HTTP headers.<br>          })),<br>          interval   = optional(number), # The interval between each health check. Shorter intervals may improve failover time, but will increase load on the origins as we check from multiple locations. Defaults to 60.<br>          method     = optional(string), # The method to use for the health check.<br>          path       = optional(string), # The endpoint path to health check against.<br>          port       = optional(number), # The port number to use for the healthcheck, required when creating a TCP monitor.<br>          probe_zone = optional(string), # Assign this monitor to emulate the specified zone while probing. Only valid if type is "http" or "https".<br>          retries    = optional(number), # The number of retries to attempt in case of a timeout before marking the origin as unhealthy. Retries are attempted immediately. Defaults to 2.<br>          timeout    = optional(number), # The timeout (in seconds) before marking the health check as failed. Defaults to 5.<br>          type       = optional(string), # The protocol to use for the healthcheck. Available values: http, https, tcp, udp_icmp, icmp_ping, smtp. Defaults to http.<br>        }))<br>      })<br>      session_affinity     = optional(string),           # Specifies the type of session affinity the load balancer should use unless specified as none or "" (default). With value cookie, on the first request to a proxied load balancer, a cookie is generated, encoding information of which origin the request will be forwarded to. Subsequent requests, by the same client to the same load balancer, will be sent to the origin server the cookie encodes, for the duration of the cookie and as long as the origin server remains healthy. If the cookie has expired or the origin server is unhealthy then a new origin server is calculated and used. Value ip_cookie behaves the same as cookie except the initial origin selection is stable and based on the client's IP address. Available values: "", none, cookie, ip_cookie, header. Defaults to none.<br>      session_affinity_ttl = optional(number),           # Time, in seconds, until this load balancer's session affinity cookie expires after being created. This parameter is ignored unless a supported session affinity policy is set. The current default of 82800 (23 hours) will be used unless session_affinity_ttl is explicitly set. Once the expiry time has been reached, subsequent requests may get sent to a different origin server. Valid values are between 1800 and 604800.<br>      session_affinity_attributes = optional(object({    # Configure attributes for session affinity.<br>        drain_duration         = optional(number),       # Configures the drain duration in seconds. This field is only used when session affinity is enabled on the load balancer. Defaults to 0.<br>        headers                = optional(list(string)), # Configures the HTTP header names to use when header session affinity is enabled.<br>        require_all_headers    = optional(bool),         # Configures how headers are used when header session affinity is enabled. Set to true to require all headers to be present on requests in order for sessions to be created or false to require at least one header to be present. Defaults to false.<br>        samesite               = optional(string),       # onfigures the SameSite attribute on session affinity cookie. Value Auto will be translated to Lax or None depending if Always Use HTTPS is enabled. Note: when using value None, then you can not set secure="Never". Available values: Auto, Lax, None, Strict. Defaults to Auto.<br>        secure                 = optional(string),       # Configures the Secure attribute on session affinity cookie. Value Always indicates the Secure attribute will be set in the Set-Cookie header, Never indicates the Secure attribute will not be set, and Auto will set the Secure attribute depending if Always Use HTTPS is enabled. Available values: Auto, Always, Never. Defaults to Auto.<br>        zero_downtime_failover = optional(string),       # Configures the zero-downtime failover between origins within a pool when session affinity is enabled. Value none means no failover takes place for sessions pinned to the origin. Value temporary means traffic will be sent to another other healthy origin until the originally pinned origin is available; note that this can potentially result in heavy origin flapping. Value sticky means the session affinity cookie is updated and subsequent requests are sent to the new origin. This feature is currently incompatible with Argo, Tiered Cache, and Bandwidth Alliance. Available values: none, temporary, sticky. Defaults to none.<br>      }))<br>      rules = optional(list(object({       #  A list of rules for this load balancer to execute.<br>        name      = string,                # Human readable name for this rule.<br>        condition = optional(string),      # The statement to evaluate to determine if this rule's effects should be applied. An empty condition is always true.<br>        disabled  = optional(bool),        # A disabled rule will not be executed.<br>        fixed_response = optional(object({ # Settings for a HTTP response to return directly to the eyeball if the condition is true. Note: overrides or fixed_response must be set. <br>          content_type = optional(string), # The value of the HTTP context-type header for this fixed response.<br>          location     = optional(string), # The value of the HTTP location header for this fixed response.<br>          message_body = optional(string), # The text used as the html body for this fixed response.<br>          status_code  = optional(number), # The HTTP status code used for this fixed response.<br>        })),<br>        overrides = optional(list(object({                # The load balancer settings to alter if this rule's condition is true. Note: overrides or fixed_response must be set.<br>          default_pools        = optional(list(string)),  # A list of pool IDs ordered by their failover priority. Used whenever pop_pools/country_pools/region_pools are not defined.<br>          ttl                  = optional(number),        # Time to live (TTL) of the DNS entry for the IP address returned by this load balancer. This cannot be set for proxied load balancers. Defaults to 30.<br>          session_affinity     = optional(string),        # Specifies the type of session affinity the load balancer should use unless specified as none or "" (default). With value cookie, on the first request to a proxied load balancer, a cookie is generated, encoding information of which origin the request will be forwarded to. Subsequent requests, by the same client to the same load balancer, will be sent to the origin server the cookie encodes, for the duration of the cookie and as long as the origin server remains healthy. If the cookie has expired or the origin server is unhealthy then a new origin server is calculated and used. Value ip_cookie behaves the same as cookie except the initial origin selection is stable and based on the client's IP address. Available values: "", none, cookie, ip_cookie, header. Defaults to none.<br>          session_affinity_ttl = optional(number),        # Time, in seconds, until this load balancer's session affinity cookie expires after being created. This parameter is ignored unless a supported session affinity policy is set. The current default of 82800 (23 hours) will be used unless session_affinity_ttl is explicitly set. Once the expiry time has been reached, subsequent requests may get sent to a different origin server. Valid values are between 1800 and 604800.<br>          session_affinity_attributes = optional(object({ # Configure attributes for session affinity.<br>            # not yet supported drain_duration         = optional(number),       # Configures the drain duration in seconds. This field is only used when session affinity is enabled on the load balancer. Defaults to 0.<br>            headers                = optional(list(string)), # Configures the HTTP header names to use when header session affinity is enabled.<br>            require_all_headers    = optional(bool),         # Configures how headers are used when header session affinity is enabled. Set to true to require all headers to be present on requests in order for sessions to be created or false to require at least one header to be present. Defaults to false.<br>            samesite               = optional(string),       # onfigures the SameSite attribute on session affinity cookie. Value Auto will be translated to Lax or None depending if Always Use HTTPS is enabled. Note: when using value None, then you can not set secure="Never". Available values: Auto, Lax, None, Strict. Defaults to Auto.<br>            secure                 = optional(string),       # Configures the Secure attribute on session affinity cookie. Value Always indicates the Secure attribute will be set in the Set-Cookie header, Never indicates the Secure attribute will not be set, and Auto will set the Secure attribute depending if Always Use HTTPS is enabled. Available values: Auto, Always, Never. Defaults to Auto.<br>            zero_downtime_failover = optional(string),       # Configures the zero-downtime failover between origins within a pool when session affinity is enabled. Value none means no failover takes place for sessions pinned to the origin. Value temporary means traffic will be sent to another other healthy origin until the originally pinned origin is available; note that this can potentially result in heavy origin flapping. Value sticky means the session affinity cookie is updated and subsequent requests are sent to the new origin. This feature is currently incompatible with Argo, Tiered Cache, and Bandwidth Alliance. Available values: none, temporary, sticky. Defaults to none.<br>          })),<br>        }))),<br>        priority   = optional(number), # Priority used when determining the order of rule execution. Lower values are executed first. If not provided, the list order will be used.<br>        terminates = optional(bool),   # Terminates indicates that if this rule is true no further rules should be executed. Note: setting a fixed_response forces this field to true.<br>      }))),<br>    })))<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_publishing"></a> [service\_publishing](#output\_service\_publishing) | Service Publishing output object. |
<!-- END_TF_DOCS -->