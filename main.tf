module "cloudflared" {
  source = "git::https://github.com/avaloqcloud/terraform-oci-container-instance.git?ref=new-approach"

  container_instance = var.cloudflared
}
