variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  sensitive   = true
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "yc_access_key" {
  description = "Yandex Cloud Storage access key"
  type        = string
  sensitive   = true
}

variable "yc_secret_key" {
  description = "Yandex Cloud Storage secret key"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for server access"
  type        = string
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = "main-cluster"
}

variable "srv_server_name" {
  description = "SRV server name"
  type        = string
  default     = "srv-tools"
}
