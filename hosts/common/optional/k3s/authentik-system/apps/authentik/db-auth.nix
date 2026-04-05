{ config, ... }: {

  sops.templates."authentik/authentik-database-auth.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: authentik-db-auth
        namespace: authentik-system
      stringData:
        username: "${config.sops.placeholder."authentik/database/user"}"
        password: "${config.sops.placeholder."authentik/database/password"}"
      type: kubernetes.io/basic-auth
    '';

    path = "/var/lib/rancher/k3s/server/manifests/authentik-database-auth.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
