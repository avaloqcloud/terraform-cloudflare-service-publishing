resource "cloudflare_load_balancer" "these" {
  for_each             = (var.service_publishing.load_balancers != null) ? ({ for load_balancer in var.service_publishing.load_balancers : load_balancer.name => load_balancer }) : ({})
  zone_id              = each.value.zone_id
  name                 = each.value.name
  fallback_pool_id     = cloudflare_load_balancer_pool.these["${each.key}"].id
  default_pool_ids     = [cloudflare_load_balancer_pool.these["${each.key}"].id] # get matching lb pool id
  enabled              = try(each.value.enabled, null)
  proxied              = try(each.value.proxied, null)
  ttl                  = try(each.value.ttl, null)
  session_affinity     = try(each.value.session_affinity, null)
  session_affinity_ttl = try(each.value.session_affinity_ttl, null)
  dynamic "session_affinity_attributes" {
    for_each = (try(each.value.session_affinity_attributes, null) != null) ? ([each.value.session_affinity_attributes]) : ([])
    content {
      samesite               = try(session_affinity_attributes.samesite, null)
      secure                 = try(session_affinity_attributes.secure, null)
      drain_duration         = try(session_affinity_attributes.drain_duration, null)
      zero_downtime_failover = try(session_affinity_attributes.zero_downtime_failover, null)
    }
  }
  steering_policy = "off" # hard-code to always use default_pool_ids
  dynamic "rules" {
    for_each = (try(each.value.rules, null) != null) ? (each.value.rules) : ([])
    content {
      name      = try(rules.value.name, null)
      condition = try(rules.value.condition, null)
      disabled  = try(rules.value.disabled, null)
      dynamic "fixed_response" {
        for_each = (try(rules.value.fixed_response, null) != null) ? ([rules.value.fixed_response]) : ([])
        content {
          content_type = try(fixed_response.value.content_type, null)
          location     = try(fixed_response.value.location, null)
          message_body = try(fixed_response.value.message_body, null)
          status_code  = try(fixed_response.value.status_code, null)
        }
      }
      dynamic "overrides" {
        for_each = (try(rules.value.overrides, null) != null) ? (rules.value.overrides) : ([])
        content {
          default_pools        = try(overrides.value.default_pools, null)
          ttl                  = try(overrides.value.ttl, null)
          session_affinity     = try(overrides.value.session_affinity, null)
          session_affinity_ttl = try(overrides.value.session_affinity_ttl, null)
          dynamic "session_affinity_attributes" {
            for_each = (try(overrides.value.session_affinity_attributes, null) != null) ? ([overrides.value.session_affinity_attributes]) : ([])
            content {
              # not yet implemented drain_duration = try(session_affinity_attributes.value.drain_duration, null)
              headers                = try(session_affinity_attributes.value.headers, null)
              require_all_headers    = try(session_affinity_attributes.value.require_all_headers, null)
              samesite               = try(session_affinity_attributes.value.samesite, null)
              secure                 = try(session_affinity_attributes.value.secure, null)
              zero_downtime_failover = try(session_affinity_attributes.value.zero_downtime_failover, null)
            }
          }
        }
      }
      priority   = try(rules.value.priority, null)
      terminates = try(rules.value.terminates, null)
    }
  }
}

resource "cloudflare_load_balancer_pool" "these" {
  for_each   = (var.service_publishing.load_balancers != null) ? ({ for load_balancer in var.service_publishing.load_balancers : load_balancer.name => load_balancer }) : ({})
  account_id = each.value.default_pool.account_id
  name       = each.value.name                                                     # take name from load_balancer.name since we ever only have one pool per lb for simplicity.
  monitor    = try(cloudflare_load_balancer_monitor.these["${each.key}"].id, null) # if lb.default_pool.monitor defined get id
  dynamic "origins" {
    for_each = (try(each.value.default_pool.origins, null) != null) ? (each.value.default_pool.origins) : ([])
    content {
      name    = origins.value.name
      address = origins.value.address
      enabled = try(origins.value.enabled, null)
      dynamic "header" {
        for_each = (try(origins.value.header, null) != null) ? ([origins.value.header]) : ([])
        content {
          header = header.value.header
          values = header.value.values
        }
      }
    }
  }
}

resource "cloudflare_load_balancer_monitor" "these" {
  for_each = (var.service_publishing.load_balancers != null) ? (
    alltrue(flatten([
      for lb in var.service_publishing.load_balancers :
      (lb.default_pool.monitor != null) # only process if optional load_balancer.default_pool.monitor is defined
    ])) ? ({ for load_balancer in var.service_publishing.load_balancers : load_balancer.name => load_balancer }) : ({})
  ) : ({})
  account_id       = each.value.default_pool.account_id
  allow_insecure   = try(each.value.default_pool.monitor.allow_insecure, null)
  consecutive_down = try(each.value.default_pool.monitor.consecutive_down, null)
  consecutive_up   = try(each.value.default_pool.monitor.consecutive_up, null)
  description      = try(each.value.default_pool.monitor.description, null)
  expected_body    = try(each.value.default_pool.monitor.expected_body, null)
  expected_codes   = try(each.value.default_pool.monitor.expected_codes, null)
  follow_redirects = try(each.value.default_pool.monitor.follow_redirects, null)
  dynamic "header" {
    for_each = (try(each.value.default_pool.monitor.header, null) != null) ? ([each.value.default_pool.monitor.header]) : ([])
    content {
      header = header.value.header
      values = header.value.values
    }
  }
  interval   = try(each.value.default_pool.monitor.interval, null)
  method     = try(each.value.default_pool.monitor.method, null)
  path       = try(each.value.default_pool.monitor.path, null)
  port       = try(each.value.default_pool.monitor.expectedport_body, null)
  probe_zone = try(each.value.default_pool.monitor.probe_zone, null)
  retries    = try(each.value.default_pool.monitor.retries, null)
  timeout    = try(each.value.default_pool.monitor.timeout, null)
  type       = try(each.value.default_pool.monitor.type, null)
}