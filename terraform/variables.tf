variable "subscription_id" {
  description = "Azure Subscription ID where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "microservice-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "EAST US"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "microserviceacr"
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "microservice-aks"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "standard_dc2ds_v3" # 2 vCPUs, 8GB RAM (cost-effective, meets AKS requirements)
}