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