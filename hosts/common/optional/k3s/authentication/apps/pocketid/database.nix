{ config, ... }: {

  sops.templates."pocketid/pocketid-database.yaml" = {
    content = ''
      apiVersion: postgresql.cnpg.io/v1
      kind: Cluster
      metadata:
        name: pocketid-db
        namespace: authentication
      spec:
        instances: 1

        bootstrap:
          initdb:
            database: pocketid
            owner: ${config.sops.placeholder."pocketid/database/user"}
            secret:
              name: pocketid-db-auth

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

    path = "/var/lib/rancher/k3s/server/manifests/pocketid-database.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
