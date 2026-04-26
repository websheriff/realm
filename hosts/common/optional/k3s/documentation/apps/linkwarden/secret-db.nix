{ config, ... }: {

  sops.templates."linkwarden/secret-db.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: linkwarden-db
        namespace: documentation
      type: Opaque
      stringData:
        uri: "postgresql://${config.sops.placeholder."linkwarden/database/user"}:${config.sops.placeholder."linkwarden/database/password"}@${config.sops.placeholder."linkwarden/database/host"}:5432/linkwarden"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/linkwarden-secret-db.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
