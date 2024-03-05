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