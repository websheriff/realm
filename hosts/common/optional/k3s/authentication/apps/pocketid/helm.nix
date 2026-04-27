{ config, ... }: {

  sops.templates."pocketid/pocketid-helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: pocketid
        namespace: kube-system
      spec:
        repo: https://anza-labs.github.io/charts
        chart: pocket-id
        version: "2.1.0"
        targetNamespace: authentication
        createNamespace: false
        valuesContent: |

          host: "https://${config.sops.placeholder."pocketid/domain"}"

          timeZone: "America/Chicago"

          config:
            ui:
              settings:
                smtp:
                  port: 587
                  tls: "starttls"

                email:
                  loginNotificationEnabled: true

          service:
            type: LoadBalancer
            annotations: "metallb.io/address-pool" = "exposed-pool";
    '';

    path = "/var/lib/rancher/k3s/server/manifests/pocketid-helm.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
