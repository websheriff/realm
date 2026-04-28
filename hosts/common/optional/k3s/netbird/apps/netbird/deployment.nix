{ ... }: {

  sops.templates."netbird/deploy" = {
    content = ''
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: netbird
        namespace: netbird
      spec:
        replicas: 1

        selector:
          matchLabels:
            app: netbird

        template:
          metadata:
            labels:
              app: netbird
          spec:
            containers:
              - name: netbird
                image: netbirdio/netbird:latest
                env:
                  - name: NB_SETUP_KEY
                    valueFrom:
                      secretKeyRef:
                        name: netbird
                        key: setup-key
                  - name: NB_HOSTNAME
                    value: "netbird-k3s-router"
                  - name: NB_LOG_LEVEL
                    value: "info"
                securityContext:
                  capabilities:
                    add:
                      - NET_ADMIN
                      - SYS_RESOURCE
                      - SYS_ADMIN
                livenessProbe:
                  exec:
                    command: ["netbird", "status", "--check", "live"]
                  initialDelaySeconds: 5
                  periodSeconds: 10
                  timeoutSeconds: 5
                  failureThreshold: 3
                readinessProbe:
                  exec:
                    command: ["netbird", "status", "--check", "ready"]
                  initialDelaySeconds: 5
                  periodSeconds: 10
                  timeoutSeconds: 5
                  failureThreshold: 3
                startupProbe:
                  exec:
                    command: ["netbird", "status", "--check", "startup"]
                  periodSeconds: 2
                  timeoutSeconds: 10
                  failureThreshold: 30
    '';

    path = "/var/lib/rancher/k3s/server/manifests/netbird-deploy.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
