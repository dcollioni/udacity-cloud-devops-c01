output "backend_public_ip_dns" {
  value = azurerm_public_ip.backend.fqdn
}

output "backend_public_ip" {
  value = azurerm_public_ip.backend.ip_address
}
