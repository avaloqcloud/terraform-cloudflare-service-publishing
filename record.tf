# Records
resource "cloudflare_record" "these" {
  for_each = (var.service_publishing.records != null) ? ({ for record in var.service_publishing.records : record.name => record }) : ({})
  zone_id  = data.cloudflare_zone.these["${each.key}"].id
  name     = each.value.name
  # If Tunnel found with matching name assume CNAME for type of record, else take 'content' for DNS record from input
  type = (try(cloudflare_tunnel.these["${each.key}"], null) != null) ? ("CNAME") : (each.value.type)
  # If Tunnel found with matching name use reference of tunnel, else take value for DNS record from input
  content = (try(cloudflare_tunnel.these["${each.key}"], null) != null) ? (cloudflare_tunnel.these["${each.key}"].cname) : (each.value.content)
  ttl     = each.value.ttl
  proxied = each.value.proxied
}