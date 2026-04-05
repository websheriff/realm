{ config, ... }: {

  sops.templates."authentik/authentik-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: authentik
        namespace: kube-system
      spec:
        repo: https://charts.goauthentik.io
        chart: authentik
        version: "2026.2.1"
        targetNamespace: authentik-system
        createNamespace: true
        valuesContent: |
          authentik:
            global:
              env:
                - name: AUTHENTIK_POSTGRESQL__HOST
                  valueFrom:
                    secretKeyRef:
                      name: authentik-db-secrets
                      key: host
                - name: AUTHENTIK_POSTGRESQL__USER
                  valueFrom:
                    secretKeyRef:
                      name: authentik-db-secrets
                      key: user
                - name: AUTHENTIK_POSTGRESQL__PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: authentik-db-secrets
                      key: password
                - name: AUTHENTIK_SECRET_KEY
                  valueFrom:
                    secretKeyRef:
                      name: authentik-secrets
                      key: secret-key
                - name: AUTHENTIK_EMAIL__USERNAME
                  valueFrom:
                    secretKeyRef:
                      name: authentik-email-secrets
                      key: username
                - name: AUTHENTIK_EMAIL__PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: authentik-email-secrets
                      key: password

            postgresql:
              name: authentik

            email:
              host: "smtp.fastmail.com"
              port: 465
              use_tls: false
              use_ssl: true
              timeout: 30
              from: "${config.sops.placeholder."admin/emails/noreply"}"

          server:
            ingress:
              ingressClassName: traefik
              enabled: true
              hosts:
                - ${config.sops.placeholder."authentik/domain"}
    '';

    path = "/var/lib/rancher/k3s/server/manifests/authentik-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
