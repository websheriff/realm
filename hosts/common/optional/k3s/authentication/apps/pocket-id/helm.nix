{ config, ... }: {

  sops.templates."pocket-id/pocket-id-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: pocket-id
        namespace: kube-system
      spec:
        repo:
        chart: pocket-id
        version:
        targetNamespace: authentication
        createNamespace: false
        valuesContent: |

          host: "https://${config.sops.placeholder."pocket-id/domain"}"

          config:
            ui:
              settings:
                smtp:
                  host: "smtp.fastmail.com"
                  port: 587
                  from: "${config.sops.placeholder."admin/emails/noreply"}"
                  user: "${config.sops.placeholder."pocket-id/email/user"}"
                  password: "${config.sops.placeholder."pocket-id/email/password"}"
                  tls: "starttls"

          database:
            connectionString: "${config.sops.placeholder."pocket-id/database"}"

          service:
            type: LoadBalancer
            annotations: "metallb.io/address-pool" = "exposed-pool";
    '';

    path = "/var/lib/rancher/k3s/server/manifests/pocket-id-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
