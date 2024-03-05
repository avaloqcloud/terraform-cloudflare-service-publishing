[![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/avaloqcloud/terraform-cloudflare-service-publishing/archive/refs/tags/v0.2.0.zip)


## Terraform Cloudflare Service Publishing
Provides a reusable Terraform module to publish services via Cloudflare, compatible with ORM.
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2.9 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | = 4.25.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | = 4.25.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_access_application.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.25.0/docs/resources/access_application) | resource |
| [cloudflare_access_policy.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.25.0/docs/resources/access_policy) | resource |
| [cloudflare_access_service_token.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.25.0/docs/resources/access_service_token) | resource |
| [cloudflare_record.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.25.0/docs/resources/record) | resource |
| [cloudflare_spectrum_application.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.25.0/docs/resources/spectrum_application) | resource |
| [cloudflare_tunnel.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.25.0/docs/resources/tunnel) | resource |
| [cloudflare_tunnel_config.these](https://registry.terraform.io/providers/cloudflare/cloudflare/4.25.0/docs/resources/tunnel_config) | resource |
| [random_id.these](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service_publishing"></a> [service\_publishing](#input\_service\_publishing) | Service Publishing input object. | <pre>object({<br>    records = optional(list(object({<br>      zone_id = string,<br>      name    = string,<br>      value   = optional(string), # required if matching tunnel ommited<br>      type    = string,<br>      ttl     = number<br>      proxied = bool,<br>    }))),<br>    tunnels = optional(list(object({<br>      account_id = string,<br>      name       = string,<br>    }))),<br>    tunnels_config = optional(list(object({<br>      account_id = string,<br>      name       = optional(string), # required if wanting to match tunnel<br>      tunnel_id  = optional(string), # required if matching tunnel ommited<br>      config = object({<br>        warp_routing = optional(object({<br>          enabled = bool, # Whether WARP routing is enabled.<br>        })),<br>        default_origin_request = optional(object({<br>          access = optional(object({<br>            aud_tag   = optional(list(string)), # Audience tags of the access rule.<br>            required  = optional(bool),         # Whether the access rule is required.<br>            team_name = optional(string),       # Name of the team to which the access rule applies.<br>          })),<br>          bastion_mode             = optional(bool),<br>          ca_pool                  = optional(string), # Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare. Defaults to "".<br>          connect_timeout          = optional(string), # Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by tlsTimeout. Defaults to 30s.<br>          disable_chunked_encoding = optional(bool),   # Disables chunked transfer encoding. Useful if you are running a Web Server Gateway Interface (WSGI) server. Defaults to false.<br>          http2_origin             = optional(bool),   # Enables HTTP/2 support for the origin connection. Defaults to false.<br>          http_host_header         = optional(string), # Sets the HTTP Host header on requests sent to the local service. Defaults to "".<br>          ip_rules = optional(object({<br>            allow  = optional(bool),         # Whether to allow the IP prefix.<br>            ports  = optional(list(number)), # Ports to use within the IP rule.<br>            prefix = optional(string),       # IP rule prefix.<br>          })),<br>          keep_alive_connections = optional(number), # Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections. Defaults to 100.<br>          keep_alive_timeout     = optional(string), # Timeout after which an idle keepalive connection can be discarded. Defaults to 1m30s.<br>          no_happy_eyeballs      = optional(bool),   # Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols. Defaults to false.<br>          no_tls_verify          = optional(bool),   # Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted. Defaults to false.<br>          origin_server_name     = optional(string), # Hostname that cloudflared should expect from your origin server certificate. Defaults to "".<br>          proxy_address          = optional(string)  # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy. Defaults to 127.0.0.1.<br>          proxy_port             = optional(number), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen. Defaults to 0.<br>          proxy_type             = optional(string), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Available values: "", socks. Defaults to "".<br>          tcp_keep_alive         = optional(string), # The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server. Defaults to 30s.<br>          tls_timeout            = optional(string), # Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server. Defaults to 10s.<br>        })),<br>        ingress_rules = list(object({<br>          hostname = optional(string),<br>          path     = optional(string),<br>          service  = string,<br>          origin_request = optional(object({<br>            access = optional(object({<br>              aud_tag   = optional(list(string)), # Audience tags of the access rule.<br>              required  = optional(bool),         # Whether the access rule is required.<br>              team_name = optional(string),       # Name of the team to which the access rule applies.<br>            })),<br>            bastion_mode             = optional(bool),<br>            ca_pool                  = optional(string), # Path to the certificate authority (CA) for the certificate of your origin. This option should be used only if your certificate is not signed by Cloudflare. Defaults to "".<br>            connect_timeout          = optional(string), # Timeout for establishing a new TCP connection to your origin server. This excludes the time taken to establish TLS, which is controlled by tlsTimeout. Defaults to 30s.<br>            disable_chunked_encoding = optional(bool),   # Disables chunked transfer encoding. Useful if you are running a Web Server Gateway Interface (WSGI) server. Defaults to false.<br>            http2_origin             = optional(bool),   # Enables HTTP/2 support for the origin connection. Defaults to false.<br>            http_host_header         = optional(string), # Sets the HTTP Host header on requests sent to the local service. Defaults to "".<br>            ip_rules = optional(object({<br>              allow  = optional(bool),         # Whether to allow the IP prefix.<br>              ports  = optional(list(number)), # Ports to use within the IP rule.<br>              prefix = optional(string),       # IP rule prefix.<br>            })),<br>            keep_alive_connections = optional(number), # Maximum number of idle keepalive connections between Tunnel and your origin. This does not restrict the total number of concurrent connections. Defaults to 100.<br>            keep_alive_timeout     = optional(string), # Timeout after which an idle keepalive connection can be discarded. Defaults to 1m30s.<br>            no_happy_eyeballs      = optional(bool),   # Disable the “happy eyeballs” algorithm for IPv4/IPv6 fallback if your local network has misconfigured one of the protocols. Defaults to false.<br>            no_tls_verify          = optional(bool),   # Disables TLS verification of the certificate presented by your origin. Will allow any certificate from the origin to be accepted. Defaults to false.<br>            origin_server_name     = optional(string), # Hostname that cloudflared should expect from your origin server certificate. Defaults to "".<br>            proxy_address          = optional(string)  # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen address for that proxy. Defaults to 127.0.0.1.<br>            proxy_port             = optional(number), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures the listen port for that proxy. If set to zero, an unused port will randomly be chosen. Defaults to 0.<br>            proxy_type             = optional(string), # cloudflared starts a proxy server to translate HTTP traffic into TCP when proxying, for example, SSH or RDP. This configures what type of proxy will be started. Available values: "", socks. Defaults to "".<br>            tcp_keep_alive         = optional(string), # The timeout after which a TCP keepalive packet is sent on a connection between Tunnel and the origin server. Defaults to 30s.<br>            tls_timeout            = optional(string), # Timeout for completing a TLS handshake to your origin server, if you have chosen to connect Tunnel to an HTTPS server. Defaults to 10s.<br>          })),<br>        })),<br>      }),<br>    }))),<br>    access_applications = optional(list(object({<br>      zone_id                   = string,<br>      name                      = string,<br>      domain                    = optional(string),<br>      type                      = string,<br>      session_duration          = string,<br>      auto_redirect_to_identity = bool,<br>      allowed_idps              = optional(list(string)),<br>      self_hosted_domains       = optional(list(string)),<br>      saas_app = optional(object({<br>        auth_type          = optional(string),<br>        redirect_uris      = optional(list(string)), # OIDC: The permitted URL's for Cloudflare to return Authorization codes and Access/ID tokens. example: ["https://saas-app.example/sso/oauth2/callback"]<br>        grant_types        = optional(list(string)), # OIDC: The OIDC flows supported by this application. Example: ["authorization_code"]<br>        scopes             = optional(list(string)), # OIDC: Define the user information shared with access. Example: ["openid", "email", "profile", "groups"]<br>        app_launcher_url   = optional(string),       # OIDC: The URL where this applications tile redirects users. Example: "https://saas-app.example/sso/login"<br>        group_filter_regex = optional(string),       # OIDC: A regex to filter Cloudflare groups returned in ID token and userinfo endpoint. Default: ".*"<br>      }))<br>    })))<br>    access_policies = optional(list(object({<br>      application_id = optional(string),<br>      zone_id        = string,<br>      name           = string,<br>      precedence     = number,<br>      decision       = string,<br>      include = object({<br>        login_method  = optional(list(string)),<br>        email_domain  = optional(list(string)),<br>        service_token = optional(list(string)),<br>      }),<br>    }))),<br>    access_service_tokens = optional(list(object({<br>      account_id = string,<br>      name       = string,<br>    })))<br>    spectrum_applications = optional(list(object({<br>      zone_id       = string,<br>      name          = string,<br>      protocol      = string,<br>      origin_direct = optional(list(string)),<br>      origin_dns = optional(object({<br>        name = string,<br>      })),<br>      origin_port = optional(number)<br>      tls         = optional(string),<br>    })))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_publishing"></a> [service\_publishing](#output\_service\_publishing) | Service Publishing output object. |
<!-- END_TF_DOCS -->