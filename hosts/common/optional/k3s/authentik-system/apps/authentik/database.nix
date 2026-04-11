{ config, ... }: {

  sops.templates."authentik/authentik-database.yaml" = {
    content = ''
      apiVersion: postgresql.cnpg.io/v1
      kind: Cluster
      metadata:
        name: authentik-db
        namespace: authentik
      spec:
        instances: 1

        bootstrap:
          initdb:
            database: authentik
            owner: ${config.sops.placeholder."authentik/database/user"}
            secret:
              name: authentik-db-auth

        managed:
          services:
            disabledDefaultServices: [ "ro", "r" ]

        storage:
          storageClass: local-path
          size: 3Gi
        walStorage:
          storageClass: local-path
          size: 3Gi
    '';

    path = "/var/lib/rancher/k3s/server/manifests/authentik-database.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
