# Records
resource "cloudflare_record" "these" {
  for_each = (var.service_publishing.records != null) ? ({ for record in var.service_publishing.records : record.name => record }) : ({})
  zone_id  = each.value.zone_id
  name     = each.value.name
  # If Tunnel found with matching name assume CNAME for type of record, else take value for DNS record from input
  type = (try(cloudflare_tunnel.these["${each.key}"], null) != null) ? ("CNAME") : (each.value.type)
  # If Tunnel found with matching name use reference of tunnel, else take value for DNS record from input
  value   = (try(cloudflare_tunnel.these["${each.key}"], null) != null) ? (cloudflare_tunnel.these["${each.key}"].cname) : (each.value.value)
  ttl     = each.value.ttl
  proxied = each.value.proxied
}


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
                for_each = (try(ingress_rule.value.access, null) != null) ? ([ingress_rule.value.access]) : ([])
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
                for_each = (try(ingress_rule.value.ip_rules, null) != null) ? ([ingress_rule.value.ip_rules]) : ([])
                content {
                  allow  = try(access.value.allow, null)
                  ports  = try(access.value.ports, null)
                  prefix = try(access.value.prefix, null)
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
        for_each = (try(config.default_origin_request, null) != null) ? ([config.value.default_origin_request]) : ([])
        content {
          dynamic "access" {
            for_each = (try(config.value.access, null) != null) ? ([config.value.access]) : ([])
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
            for_each = (try(config.value.ip_rules, null) != null) ? ([config.value.ip_rules]) : ([])
            content {
              allow  = try(access.value.allow, null)
              ports  = try(access.value.ports, null)
              prefix = try(access.value.prefix, null)
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


# Access Applications
resource "cloudflare_access_application" "these" {
  for_each = (var.service_publishing.access_applications != null) ? ({ for access_application in var.service_publishing.access_applications : access_application.name => access_application }) : ({})
  zone_id  = each.value.zone_id
  name     = each.value.name
  # If DNS Record found with matching name use name from record, else take value from input
  domain                    = (try(cloudflare_record.these["${each.key}"], null) != null) ? (cloudflare_record.these["${each.key}"].hostname) : (each.value.domain)
  self_hosted_domains       = each.value.self_hosted_domains
  type                      = each.value.type
  session_duration          = each.value.session_duration
  auto_redirect_to_identity = each.value.auto_redirect_to_identity
  app_launcher_visible      = false
  allowed_idps              = each.value.allowed_idps
  dynamic "saas_app" {
    for_each = (
      (try(each.value, null) != null) && (try(each.value.saas_app, null) != null)
    ) ? ([each.value]) : ([])
    content {
      auth_type          = try(each.value.saas_app.auth_type, null)
      redirect_uris      = try(each.value.saas_app.redirect_uris, null)
      grant_types        = try(each.value.saas_app.grant_types, null)
      scopes             = try(each.value.saas_app.scopes, null)
      app_launcher_url   = try(each.value.saas_app.app_launcher_url, null)
      group_filter_regex = try(each.value.saas_app.group_filter_regex, ".*")
    }
  }
}


# Access Policies
resource "cloudflare_access_policy" "these" {
  for_each = (var.service_publishing.access_policies != null) ? ({ for access_policy in var.service_publishing.access_policies : access_policy.name => access_policy }) : ({})
  # If Access Application found with matching name use that id, else take from input
  application_id = (try(cloudflare_access_application.these["${each.key}"], null) != null) ? (cloudflare_access_application.these["${each.key}"].id) : (each.value.application_id)
  zone_id        = each.value.zone_id
  name           = each.value.name
  precedence     = each.value.precedence
  decision       = each.value.decision
  dynamic "include" {
    for_each = (try(each.value, null) != null) ? ([each.value]) : ([])
    content {
      login_method = try(each.value.include.login_method, null)
      email_domain = try(each.value.include.email_domain, null)
      # If Access Service Token found with matching name and decision is 'non_identity' use that id, else take from input
      service_token = (try(cloudflare_access_service_token.these["${each.key}"], null) != null) && each.value.decision == "non_identity" ? ([cloudflare_access_service_token.these["${each.key}"].id]) : try(each.value.include.service_token, null)
    }
  }
}


# Access Service Tokens
resource "cloudflare_access_service_token" "these" {
  for_each   = (var.service_publishing.access_service_tokens != null) ? ({ for service_token in var.service_publishing.access_service_tokens : service_token.name => service_token }) : ({})
  account_id = each.value.account_id
  name       = each.value.name
}


# Spectrum Applications (Arbritary TCP/UDP)
resource "cloudflare_spectrum_application" "these" {
  for_each           = (var.service_publishing.spectrum_applications != null) ? ({ for spectrum_application in var.service_publishing.spectrum_applications : spectrum_application.name => spectrum_application }) : ({})
  zone_id            = each.value.zone_id
  protocol           = each.value.protocol
  traffic_type       = "direct"
  argo_smart_routing = true
  dns {
    type = "CNAME"
    name = each.value.name
  }
  origin_direct = try(each.value.origin_direct, null)
  dynamic "origin_dns" {
    for_each = (
      (try(each.value, null) != null) && (try(each.value.origin_dns, null) != null)
    ) ? ([each.value]) : ([])
    content {
      name = try(each.value.origin_dns.name, null)
    }
  }
  origin_port    = try(each.value.origin_port, null)
  ip_firewall    = false
  proxy_protocol = "off"
  tls            = each.value.tls
  edge_ips {
    type         = "dynamic"
    connectivity = "all"
  }
}