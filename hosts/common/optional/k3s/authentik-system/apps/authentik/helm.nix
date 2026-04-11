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
        targetNamespace: authentik
        createNamespace: true
        valuesContent: |
        
          authentik:
            secret_key: "${config.sops.placeholder."authentik/secret-key"}"
              
            postgresql:
              host: ${config.sops.placeholder."authentik/database/host"}
              name: authentik
              user: ${config.sops.placeholder."authentik/database/user"}
              password: ${config.sops.placeholder."authentik/database/password"}

            email:
              host: "smtp.fastmail.com"
              port: 465
              use_tls: false
              use_ssl: true
              timeout: 30
              from: "${config.sops.placeholder."admin/emails/noreply"}"

          server:
            podLabels:
              app: authentik
            ingress:
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
