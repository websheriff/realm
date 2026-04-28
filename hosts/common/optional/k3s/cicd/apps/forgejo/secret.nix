{ config, ... }: {

  sops = {
    secrets."forgejo/prod/domain" = {};
    secrets."forgejo/admin/user" = {};
    secrets."forgejo/admin/password" = {};
    secrets."forgejo/prod/database/host" = {};
    secrets."forgejo/prod/database/user" = {};
    secrets."forgejo/prod/database/password" = {};
    
    templates = {
      "forgejo/secret-admin.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: forgejo-admin
            namespace: cicd
          type: Opaque
          stringData:
            username: "${config.sops.placeholder."forgejo/admin/user"}"
            password: "${config.sops.placeholder."forgejo/admin/password"}"
            email: "${config.sops.placeholder."users/websheriff/email"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/forgejo-secret-admin.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "forgejo/secret-db.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: forgejo-db
            namespace: cicd
          type: Opaque
          stringData:
            host: "${config.sops.placeholder."forgejo/prod/database/host"}"
            user: "${config.sops.placeholder."forgejo/prod/database/user"}"
            password: "${config.sops.placeholder."forgejo/prod/database/password"}"
        '';

        path = "/var/lib/rancher/k3s/server/manifests/forgejo-secret-db.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "forgejo/database-auth.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: forgejo-db-auth
            namespace: cicd
          type: Opaque
          stringData:
            username: "${config.sops.placeholder."forgejo/prod/database/user"}"
            password: "${config.sops.placeholder."forgejo/prod/database/password"}"
          type: kubernetes.io/basic-auth
        '';

        path = "/var/lib/rancher/k3s/server/manifests/forgejo-database-auth.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };
    };
  };
}
