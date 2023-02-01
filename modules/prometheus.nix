{ pkgs, lib, config, secrets, ... }:
{

  networking = {
    firewall.allowedTCPPorts = [
      3000 # grafana
      9090 # prometheus
      31337 # pushgw
    ];
    useDHCP = true;
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 0;
        grpc_listen_port = 0;
      };
      positions.filename = "/tmp/positions.yaml";
      client.url = secrets.loki_ingestion_url;
      scrape_configs = [{
        job_name = "system";
        static_configs = [{
          targets = [ "localhost" ];
          labels = {
            job = "varlogs";
            __path__ = "/var/log/*.log";
          };
        }];
      }];
    };
  };
  services.prometheus = {
    enable = true;
    pushgateway = {
      enable = true;
      web = {
        listen-address = ":31337";
      };
    };
    exporters = {
      node.enable = true;
      systemd.enable = true;
      #      unifi.enable = true;
    };
    remoteWrite = [{
      url = "https://prometheus-prod-01-eu-west-0.grafana.net/api/prom/push";
      basic_auth = {
        username = secrets.prometheus_user;
        password = secrets.prometheus_pass;
      };
    }];
    rules = [
      ''
        groups:
        - name: basics
          rules:

          # heartbeat alert
          - alert: Heartbeat
            expr: vector(1)
            labels:
              event: "Heartbeat"
              instance: "prometheus"
              monitor: "prometheus"
              severity: "major"
              timeout: "120"
            annotations:
              summary: "Heartbeat from prometheus"
              description: "Heartbeat from from prometheus"

          # service availability alert
          - alert: service_down
            expr: up == 0
            labels:
              service: Platform
              severity: major
              correlate: service_up,service_down
            annotations:
              description: Service {{ $labels.instance }} is unavailable.
              value: DOWN ({{ $value }})
              runbook: http://wiki.alerta.io/RunBook/{app}/Event/{alertname}

          - alert: service_up
            expr: up == 1
            labels:
              service: Platform
              severity: normal
              correlate: service_up,service_down
            annotations:
              description: Service {{ $labels.instance }} is available.
              value: UP ({{ $value }})

          # system load alert
          - alert: high_load
            expr: node_load1 > 0.5
            annotations:
              description: '{{ $labels.instance }} of job {{ $labels.job }} is under high load.'
              summary: Instance {{ $labels.instance }} under high load
              value: '{{ $value }}'

          # disk space alert (with resource=<instance>:<mountpoint> event=disk_space
          - alert: disk_space
            expr: (node_filesystem_size_bytes - node_filesystem_free_bytes) * 100 / node_filesystem_size_bytes > 5
            labels:
              instance: '{{ $labels.instance }}:{{ $labels.mountpoint }}'
            annotations:
              value: '{{ humanize $value }}%'

          # disk space alert (with resource=<instance> event=disk_util:<mountpoint>
          - alert: disk_util
            expr: (node_filesystem_size_bytes - node_filesystem_free_bytes) * 100 / node_filesystem_size_bytes > 5
            labels:
              instance: '{{ $labels.instance }}'
              event: '{alertname}:{{ $labels.mountpoint }}'  # python templating rendered by Alerta
            annotations:
              value: '{{ humanize $value }}%'

          # API request rate alert
          - alert: api_requests_high
            expr: rate(alerta_alerts_queries_count{instance="alerta:8080",job="alerta"}[5m]) > 5
            labels:
              service: Alerta,Platform
              severity: major
            annotations:
              description: API request rate of {{ $value | printf "%.1f" }} req/s is high (threshold 5 req/s)
              summary: API request rate high
              value: '{{ humanize $value }} req/s'
      ''
    ];
    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "10s";
        static_configs = [
          {
            targets = [
              "mhub:9100"
            ];
            labels = {
              alias = "mhub";
            };
          }
          {
            targets = [
              "mbox:9100"
            ];
            labels = {
              alias = "mbox";
            };
          }
          {
            targets = [
              "mhub:31337"
            ];
            labels = {
              alias = "pushgateway";
            };
          }
          {
            targets = [
              "mspace:9100"
            ];
            labels = {
              alias = "mspace";
            };
          }
          {
            targets = [ "localhost:8485" ];
            labels = {
              alias = "miniflux";
            };
          }
          {
            targets = [ "mdoze.lan:9182" ];
            labels = {
              alias = "mdoze";
            };
          }
        ];

      }
      {
        job_name = "integrations/hass";

        scrape_interval = "60s";
        metrics_path = "/api/prometheus";
        bearer_token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiI2ODgzNDU3Zjg3MmI0OTIwOWQwYjE4ODhhMGIxYWUxZCIsImlhdCI6MTY1OTgyMzU5NSwiZXhwIjoxOTc1MTgzNTk1fQ.uF2tqmVA24DpaxMYg99CBQ0VUCBxEZ54Ft4j0dQtKlo";


        static_configs = [
          {
            targets = [
              "mhub:8123"
            ];
            labels = {
              alias = "hass";
            };
          }
        ];
      }
    ];
  };
}
