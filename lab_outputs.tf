# Outputs for Terraform

output "Generated_Access_Key" {
  value = tls_private_key.generated_access_key.private_key_pem
}
