terraform {
  required_version = ">= 1.0"
  
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.95"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-state-bucket"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = var.yc_access_key
    secret_key = var.yc_secret_key
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = "ru-central1-a"
}
