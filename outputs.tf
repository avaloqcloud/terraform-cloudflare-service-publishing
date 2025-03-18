output "service_publishing" {
  value = {
    records               = cloudflare_record.these
    tunnels               = cloudflare_zero_trust_tunnel_cloudflared.these
    access_applications   = cloudflare_zero_trust_access_application.these
    access_service_tokens = cloudflare_zero_trust_access_service_token.these
    spectrum_applications = cloudflare_spectrum_application.these
    load_balancers        = cloudflare_load_balancer.these
  }
  sensitive   = true
  description = "Service Publishing output object."
}