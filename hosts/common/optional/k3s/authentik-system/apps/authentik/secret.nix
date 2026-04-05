{ config, ... }: {

  sops.templates."authentik/authentik-secrets.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: authentik-secrets
        namespace: authentik-system
      type: Opaque
      stringData:
        secret-key: "${config.sops.placeholder."authentik/secret-key"}"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/authentik-secret.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
