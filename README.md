# Infrastructure as Code для проекта

## Предварительные требования

1. Учетная запись в Яндекс.Облаке
2. Установленный Terraform (>= 1.0)
3. Установленный Ansible (>= 2.10)
4. SSH ключ для доступа к серверам

## Настройка окружения

### 1. Подготовка Яндекс.Облака

```bash
# Создайте сервисный аккаунт
yc iam service-account create --name terraform

# Назначьте права
yc resource-manager folder add-access-binding \
  --role editor \
  --subject serviceAccount:<service-account-id>

# Создайте статический ключ
yc iam access-key create --service-account-name terraform
```
### 2. Настройка переменных

#### Создайте файл terraform/terraform.tfvars:
```bash
hcl
yc_token        = "your_oauth_token"
yc_cloud_id     = "your_cloud_id"
yc_folder_id    = "your_folder_id"
yc_access_key   = "your_access_key"
yc_secret_key   = "your_secret_key"
ssh_public_key  = "ssh-rsa AAAAB3NzaC1yc2E..."
```
### 3. Развертывание инфраструктуры

```bash
cd terraform
```
#### Инициализация
```bash
terraform init
```

#### Планирование
```bash
terraform plan
```
#### Применение
```bash
terraform apply
```

### 4. Настройка инвентаря Ansible
Обновите ansible/inventory/production с IP-адресами из вывода Terraform.

### 5. Запуск Ansible
```bash
cd ansible
```
#### Установка ролей
```bash
ansible-galaxy install -r requirements.yml
```
#### Запуск плейбука
```bash
ansible-playbook -i inventory/production playbooks/setup-infrastructure.yml
```

## Ручные действия после развертывания
#### На Kubernetes master:
Получите токен для доступа к dashboard:

```bash
kubectl -n kubernetes-dashboard create token admin-user
```
Настройте доступ к кластеру локально:

```bash
mkdir -p ~/.kube
scp ubuntu@<master-ip>:~/.kube/config ~/.kube/config
```
#### На SRV сервере:
Настройте GitLab Runner:

```bash
sudo gitlab-runner register
```
#### Настройте мониторинг:

```bash
# Проверьте доступность Grafana
curl http://localhost:3000
```
Доступ к сервисам
Kubernetes Dashboard: https://<master-ip>:30443

Grafana: http://<srv-ip>:3000

Prometheus: http://<srv-ip>:9090

#### Безопасность
Все секреты хранятся в переменных окружения

Используются security groups

SSH доступ только по ключам

Сети изолированы

#### Мониторинг и логи
Prometheus для метрик

Grafana для визуализации

Loki для логов

Alertmanager для оповещений