{ config, ... }: {

  sops.templates."forgejo/database.yaml" = {
    content = ''
      apiVersion: postgresql.cnpg.io/v1
      kind: Cluster
      metadata:
        name: forgejo-db
        namespace: cicd
      spec:
        instances: 1

        bootstrap:
          initdb:
            database: forgejo
            owner: ${config.sops.placeholder."forgejo/prod/database/user"}
            secret:
              name: forgejo-db-auth

        managed:
          services:
            disabledDefaultServices: [ "ro", "r" ]

        storage:
          storageClass: local-path
          size: 1Gi
        walStorage:
          storageClass: local-path
          size: 1Gi
    '';

    path = "/var/lib/rancher/k3s/server/manifests/forgejo-database.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
