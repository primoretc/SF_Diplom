resource "yandex_vpc_network" "main" {
  name = "main-network"
}

resource "yandex_vpc_subnet" "main" {
  name           = "main-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Security group for Kubernetes
resource "yandex_vpc_security_group" "k8s" {
  name        = "k8s-security-group"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "Kubernetes API"
    protocol       = "TCP"
    port           = 6443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "NodePort services"
    protocol       = "TCP"
    from_port      = 30000
    to_port        = 32767
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for SRV server
resource "yandex_vpc_security_group" "srv" {
  name        = "srv-security-group"
  network_id  = yandex_vpc_network.main.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Grafana"
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Kubernetes master node
resource "yandex_compute_instance" "k8s_master" {
  name        = "k8s-master"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 22.04
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.k8s.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

# Kubernetes worker node
resource "yandex_compute_instance" "k8s_worker" {
  name        = "k8s-worker"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 8
    memory = 16
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 22.04
      size     = 100
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.k8s.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

# SRV server for tools
resource "yandex_compute_instance" "srv_server" {
  name        = var.srv_server_name
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 8
    memory = 16
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" # Ubuntu 22.04
      size     = 100
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.main.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.srv.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}
