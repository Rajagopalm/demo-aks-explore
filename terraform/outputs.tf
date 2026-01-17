output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "sp_client_id" {
  value = azuread_application.github_actions.application_id
}

output "sp_client_secret" {
  value     = azuread_service_principal_password.github_actions.value
  sensitive = true
}

output "sp_tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}

output "sp_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}