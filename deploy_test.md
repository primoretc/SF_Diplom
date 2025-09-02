## Развертывание инфраструктуры
cd terraform && terraform apply
cd ../ansible && ansible-playbook -i inventory/production playbooks/setup-infrastructure.yml

## Настройка Slack алертинга
./scripts/setup-slack-alerts.sh "https://hooks.slack.com/services/XXX/XXX/XXX"

## Тестирование алертинга
### "Убиваем" приложение
kubectl delete pod -l app=django-app-app

## Проверяем логи
docker logs $(docker ps -q -f "name=alertmanager")

## Проверяем дашборды
### Grafana: http://srv-ip:3000 (admin/admin123)
### Prometheus: http://srv-ip:9090
### Loki: http://srv-ip:3100
