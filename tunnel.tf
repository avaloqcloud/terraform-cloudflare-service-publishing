# Tunnels
resource "random_id" "these" {
  for_each    = (var.service_publishing.tunnels != null) ? ({ for tunnel in var.service_publishing.tunnels : tunnel.name => tunnel }) : ({})
  byte_length = 35
}

resource "cloudflare_tunnel" "these" {
  for_each   = (var.service_publishing.tunnels != null) ? ({ for tunnel in var.service_publishing.tunnels : tunnel.name => tunnel }) : ({})
  account_id = each.value.account_id
  name       = each.value.name
  secret     = random_id.these["${each.key}"].b64_std
}

resource "cloudflare_tunnel_config" "these" {
  for_each   = (var.service_publishing.tunnels_config != null) ? ({ for tunnel_config in var.service_publishing.tunnels_config : tunnel_config.name => tunnel_config }) : ({})
  account_id = each.value.account_id
  # If Tunnel found with matching name use reference of tunnel, else take tunnel_id from input
  tunnel_id = (try(cloudflare_tunnel.these["${each.key}"], null) != null) ? (cloudflare_tunnel.these["${each.key}"].id) : (each.value.tunnel_id)
  dynamic "config" {
    for_each = (try(each.value, null) != null) ? ([each.value.config]) : ([])
    content {
      dynamic "ingress_rule" {
        for_each = config.value.ingress_rules
        content {
          hostname = try(ingress_rule.value.hostname, null)
          path     = try(ingress_rule.value.path, null)
          service  = ingress_rule.value.service
          dynamic "origin_request" {
            for_each = (try(ingress_rule.value.origin_request, null) != null) ? ([ingress_rule.value.origin_request]) : ([])
            content {
              dynamic "access" {
                for_each = (try(origin_request.value.access, null) != null) ? ([origin_request.value.access]) : ([])
                content {
                  aud_tag   = try(access.value.aud_tag, null)
                  required  = try(access.value.required, null)
                  team_name = try(access.value.team_name, null)
                }
              }
              bastion_mode             = try(origin_request.value.bastion_mode, null)
              ca_pool                  = try(origin_request.value.ca_pool, null)
              connect_timeout          = try(origin_request.value.connect_timeout, null)
              disable_chunked_encoding = try(origin_request.value.disable_chunked_encoding, null)
              http2_origin             = try(origin_request.value.http2_origin, null)
              http_host_header         = try(origin_request.value.http_host_header, null)
              dynamic "ip_rules" {
                for_each = (try(origin_request.value.ip_rules, null) != null) ? ([origin_request.value.ip_rules]) : ([])
                content {
                  allow  = try(ip_rules.value.allow, null)
                  ports  = try(ip_rules.value.ports, null)
                  prefix = try(ip_rules.value.prefix, null)
                }
              }
              keep_alive_connections = try(origin_request.value.keep_alive_connections, null)
              keep_alive_timeout     = try(origin_request.value.keep_alive_timeout, null)
              no_happy_eyeballs      = try(origin_request.value.no_happy_eyeballs, null)
              no_tls_verify          = try(origin_request.value.no_tls_verify, null)
              origin_server_name     = try(origin_request.value.origin_server_name, null)
              proxy_address          = try(origin_request.value.proxy_address, null)
              proxy_port             = try(origin_request.value.proxy_port, null)
              proxy_type             = try(origin_request.value.proxy_type, null)
              tcp_keep_alive         = try(origin_request.value.tcp_keep_alive, null)
              tls_timeout            = try(origin_request.value.tls_timeout, null)
            }
          }
        }
      }
      dynamic "origin_request" {
        for_each = (try(config.value.default_origin_request, null) != null) ? ([config.value.default_origin_request]) : ([])
        content {
          dynamic "access" {
            for_each = (try(origin_request.value.access, null) != null) ? ([origin_request.value.access]) : ([])
            content {
              aud_tag   = try(access.value.aud_tag, null)
              required  = try(access.value.required, null)
              team_name = try(access.value.team_name, null)
            }
          }
          bastion_mode             = try(origin_request.value.bastion_mode, null)
          ca_pool                  = try(origin_request.value.ca_pool, null)
          connect_timeout          = try(origin_request.value.connect_timeout, null)
          disable_chunked_encoding = try(origin_request.value.disable_chunked_encoding, null)
          http2_origin             = try(origin_request.value.http2_origin, null)
          http_host_header         = try(origin_request.value.http_host_header, null)
          dynamic "ip_rules" {
            for_each = (try(origin_request.value.ip_rules, null) != null) ? ([origin_request.value.ip_rules]) : ([])
            content {
              allow  = try(ip_rules.value.allow, null)
              ports  = try(ip_rules.value.ports, null)
              prefix = try(ip_rules.value.prefix, null)
            }
          }
          keep_alive_connections = try(origin_request.value.keep_alive_connections, null)
          keep_alive_timeout     = try(origin_request.value.keep_alive_timeout, null)
          no_happy_eyeballs      = try(origin_request.value.no_happy_eyeballs, null)
          no_tls_verify          = try(origin_request.value.no_tls_verify, null)
          origin_server_name     = try(origin_request.value.origin_server_name, null)
          proxy_address          = try(origin_request.value.proxy_address, null)
          proxy_port             = try(origin_request.value.proxy_port, null)
          proxy_type             = try(origin_request.value.proxy_type, null)
          tcp_keep_alive         = try(origin_request.value.tcp_keep_alive, null)
          tls_timeout            = try(origin_request.value.tls_timeout, null)
        }
      }
    }
  }
}