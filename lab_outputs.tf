# Outputs for Terraform

output "Generated_Access_Key" {
  value = tls_private_key.generated_access_key.private_key_pem
}

output "Jumphost_IP" {
  value = azurerm_public_ip.jumpbox_eip.ip_address
}
