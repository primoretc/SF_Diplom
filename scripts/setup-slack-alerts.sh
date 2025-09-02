#!/bin/bash

SLACK_WEBHOOK=$1

if [ -z "$SLACK_WEBHOOK" ]; then
  echo "Usage: $0 <slack-webhook-url>"
  exit 1
fi

# Update Alertmanager config
cat >/opt/tools/prometheus/alertmanager.yml <<EOF
global:
  slack_api_url: '$SLACK_WEBHOOK'
route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h
  receiver: 'slack-notifications'
receivers:
  - name: 'slack-notifications'
    slack_configs:
      - channel: '#alerts'
        send_resolved: true
        title: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'
        text: |-
          {{ range .Alerts }}
          *Alert:* {{ .Annotations.summary }}
          *Description:* {{ .Annotations.description }}
          *Severity:* {{ .Labels.severity }}
          *Instance:* {{ .Labels.instance }}
          *Time:* {{ .StartsAt }}
          {{ end }}
EOF

# Restart Alertmanager
docker-compose -f /opt/tools/prometheus/docker-compose.yml restart alertmanager

echo "Slack alerts configured successfully!"
