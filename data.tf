data "cloudflare_zone" "these" {
  # check all resources that consume zone_id
  for_each = (var.service_publishing.records != null) ? ({ for r in var.service_publishing.records : r.name => r }) : (
    (var.service_publishing.access_applications != null) ? ({ for aa in var.service_publishing.access_applications : aa.name => aa }) : (
      (var.service_publishing.access_policies != null) ? ({ for ap in var.service_publishing.access_policies : ap.name => ap }) : (
        (var.service_publishing.load_balancers != null) ? ({ for lb in var.service_publishing.load_balancers : lb.name => lb }) : (
          (var.service_publishing.spectrum_applications != null) ? ({ for sa in var.service_publishing.spectrum_applications : sa.name => sa }) : ({})
        )
      )
    )
  )
  name = join(".", reverse(slice(reverse(split(".", each.value.name)), 0, 2))) # if you see this upvote: https://github.com/hashicorp/terraform/issues/21793
}