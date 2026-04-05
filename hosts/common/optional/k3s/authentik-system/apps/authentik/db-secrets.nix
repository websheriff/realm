{ config, ... }: {

  sops.templates."authentik/database-secrets.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: authentik-db-secrets
        namespace: authentik-system
      type: Opaque
      stringData:
        host: "${config.sops.placeholder."authentik/database/host"}"
        user: "${config.sops.placeholder."authentik/database/user"}"
        password: "${config.sops.placeholder."authentik/database/password"}"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/authentik-database-secrets.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
