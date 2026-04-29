{ config, ... }: {

  sops = {
    secrets."linkwarden/domain" = {};
    secrets."linkwarden/nextauth-secret" = {};
    secrets."linkwarden/database/host" = {};
    secrets."linkwarden/database/user" = {};
    secrets."linkwarden/database/password" = {};
    secrets."linkwarden/sso/client-id" = {};
    secrets."linkwarden/sso/client-secret" = {};
    
    templates = {
      "linkwarden/secret.yaml" = {
        content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: linkwarden
            namespace: documentation
          type: Opaque
          stringData:
            db-uri: "postgresql://${config.sops.placeholder."linkwarden/database/user"}:${config.sops.placeholder."linkwarden/database/password"}@${config.sops.placeholder."linkwarden/database/host"}:5432/linkwarden"
            nextauth-secret: "${config.sops.placeholder."linkwarden/nextauth-secret"}"

            sso-client-id: "${config.sops.placeholder."linkwarden/sso/client-id"}"
            sso-client-secret: "${config.sops.placeholder."linkwarden/sso/client-secret"}"        
        '';

        path = "/var/lib/rancher/k3s/server/manifests/linkwarden-secret.yaml";
        owner = "root";
        group = "root";
        mode = "0644";
      };

      "linkwarden/database-auth.yaml" = {
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
    };
  };
}
