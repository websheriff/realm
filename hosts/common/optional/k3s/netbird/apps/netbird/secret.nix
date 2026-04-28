{ config, ... }: {

  sops = {
    secrets."netbird/domain" = {};
    secrets."netbird/setup-key" = {};

    templates = {
      "netbird/secret.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: netbird
            namespace: netbird
          type: Opaque
          stringData:
            setup-key: "${config.sops.placeholder."netbird/setup-key"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/netbird-secret.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };
    };
  };
}
