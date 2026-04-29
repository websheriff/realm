{ config, ... }: {

  sops.templates."vaultwarden/vaultwarden-helm" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: vaultwarden
        namespace: kube-system
      spec:
        repo: https://gissilabs.github.io/charts/
        chart: vaultwarden
        version: "1.4.0"
        targetNamespace: vaultwarden
        createNamespace: true
        valuesContent: |

          vaultwarden:
            domain: "https://${config.sops.placeholder."vaultwarden/domain"}"
            allowSignups: false

            admin:
              enabled: true
              existingSecret: "vaultwarden-admin"

            sso:
              enabled: true
              authority: ${config.sops.placeholder."vaultwarden/sso/auth-url"}
              scopes: "email profile groups offline_access"
              existingSecret: "vaultwarden-oidc"

          service:
            type: LoadBalancer
            annotations:
              metallb.io/address-pool: internal-pool

          database:
            type: postgresql
            existingSecret: "vaultwarden-db"
            existingSecretKey: "uri"

          persistence:
            enabled: true
            size: "2Gi"
            storageClass: "local-path"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vaultwarden-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
