{ config, ... }: {

  sops.templates."linkwarden/linkwarden-database.yaml" = {
    content = ''
      apiVersion: postgresql.cnpg.io/v1
      kind: Cluster
      metadata:
        name: linkwarden-db
        namespace: documentation
      spec:
        instances: 1

        bootstrap:
          initdb:
            database: linkwarden
            owner: ${config.sops.placeholder."linkwarden/database/user"}
            secret:
              name: linkwarden-db-auth

        managed:
          services:
            disabledDefaultServices: [ "ro", "r" ]

        storage:
          storageClass: local-path
          size: 2Gi
        walStorage:
          storageClass: local-path
          size: 2Gi
    '';

    path = "/var/lib/rancher/k3s/server/manifests/linkwarden-database.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
