output "service_publishing" {
  value = {
    records               = cloudflare_record.these
    tunnels               = cloudflare_tunnel.these
    access_applications   = cloudflare_access_application.these
    access_service_tokens = cloudflare_access_service_token.these
    spectrum_applications = cloudflare_spectrum_application.these
  }
  sensitive   = true
  description = "Service Publishing output object."
}