output "k8s_master_public_ip" {
  description = "Public IP of Kubernetes master node"
  value       = yandex_compute_instance.k8s_master.network_interface.0.nat_ip_address
}

output "k8s_worker_public_ip" {
  description = "Public IP of Kubernetes worker node"
  value       = yandex_compute_instance.k8s_worker.network_interface.0.nat_ip_address
}

output "srv_server_public_ip" {
  description = "Public IP of SRV server"
  value       = yandex_compute_instance.srv_server.network_interface.0.nat_ip_address
}

output "k8s_master_private_ip" {
  description = "Private IP of Kubernetes master node"
  value       = yandex_compute_instance.k8s_master.network_interface.0.ip_address
}

output "k8s_worker_private_ip" {
  description = "Private IP of Kubernetes worker node"
  value       = yandex_compute_instance.k8s_worker.network_interface.0.ip_address
}

output "srv_server_private_ip" {
  description = "Private IP of SRV server"
  value       = yandex_compute_instance.srv_server.network_interface.0.ip_address
}
