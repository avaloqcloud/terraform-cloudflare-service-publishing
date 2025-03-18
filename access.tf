# Access Applications
resource "cloudflare_zero_trust_access_application" "these" {
  for_each = (var.service_publishing.access_applications != null) ? ({ for access_application in var.service_publishing.access_applications : access_application.name => access_application }) : ({})
  zone_id  = data.cloudflare_zone.these["${each.key}"].id
  name     = each.value.name
  # If DNS Record found with matching name use name from record, else take value from input
  domain                    = (try(cloudflare_record.these["${each.key}"], null) != null) ? (cloudflare_record.these["${each.key}"].hostname) : (each.value.domain)
  self_hosted_domains       = each.value.self_hosted_domains
  type                      = each.value.type
  session_duration          = try(each.value.session_duration, null)
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
resource "cloudflare_zero_trust_access_policy" "these" {
  for_each = (var.service_publishing.access_policies != null) ? ({ for access_policy in var.service_publishing.access_policies : access_policy.name => access_policy }) : ({})
  # If Access Application found with matching name use that id, else take from input
  application_id = (try(cloudflare_zero_trust_access_application.these["${each.key}"], null) != null) ? (cloudflare_zero_trust_access_application.these["${each.key}"].id) : (each.value.application_id)
  zone_id        = data.cloudflare_zone.these["${each.key}"].id
  name           = each.value.name
  precedence     = each.value.precedence
  decision       = each.value.decision
  dynamic "include" {
    for_each = (try(each.value, null) != null) ? ([each.value]) : ([])
    content {
      login_method = try(each.value.include.login_method, null)
      email_domain = try(each.value.include.email_domain, null)
      # If Access Service Token found with matching name and decision is 'non_identity' use that id, else take from input
      service_token = (try(cloudflare_zero_trust_access_service_token.these["${each.key}"], null) != null) && each.value.decision == "non_identity" ? ([cloudflare_zero_trust_access_service_token.these["${each.key}"].id]) : try(each.value.include.service_token, null)
    }
  }
}

# Access Service Tokens
resource "cloudflare_zero_trust_access_service_token" "these" {
  for_each   = (var.service_publishing.access_service_tokens != null) ? ({ for service_token in var.service_publishing.access_service_tokens : service_token.name => service_token }) : ({})
  account_id = each.value.account_id
  name       = each.value.name
}