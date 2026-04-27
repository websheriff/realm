{ config, ... }: {

  sops.templates."pocketid/pocketid-database-auth.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: pocketid-db-auth
        namespace: authentication
      stringData:
        username: "${config.sops.placeholder."pocketid/database/user"}"
        password: "${config.sops.placeholder."pocketid/database/password"}"
      type: kubernetes.io/basic-auth
    '';

    path = "/var/lib/rancher/k3s/server/manifests/pocketid-database-auth.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
