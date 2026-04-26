{ config, ... }: {

  sops.templates."linkwarden/linkwarden-database-auth.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: linkwarden-db-auth
        namespace: documentation
      stringData:
        username: "${config.sops.placeholder."linkwarden/database/user"}"
        password: "${config.sops.placeholder."linkwarden/database/password"}"
      type: kubernetes.io/basic-auth
    '';

    path = "/var/lib/rancher/k3s/server/manifests/linkwarden-database-auth.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
