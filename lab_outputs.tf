# Outputs for Terraform

resource "local_file" "aviadmin_pem" {
    content     = tls_private_key.generated_access_key.private_key_pem
    filename = "${path.module}/aviadmin.pem"
    depends_on        = [tls_private_key.generated_access_key]
}

output "Generated_Access_Key" {
  value = tls_private_key.generated_access_key.private_key_pem
}

output "Jumphost_IP" {
  value = azurerm_public_ip.jumpbox_eip.ip_address
}
