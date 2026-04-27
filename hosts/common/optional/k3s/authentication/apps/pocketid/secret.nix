{ config, ... }: {

  sops.templates."pocketid/pocketid-secret.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: pocketid-secret
        namespace: authentication
      type: Opaque
      stringData:
        ENCRYPTION_KEY: "${config.sops.placeholder."pocketid/encryption-key"}"
        DATABASE_CONNECTION_STRING: "postgresql:${config.sops.placeholder."pocketid/database/user"}:${config.sops.placeholder."pocketid/database/password"}@${config.sops.placeholder."pocketid/database/host"}:5432/pocketid"

        SMTP_HOST: "${config.sops.placeholder."admin/smtp/host"}"
        SMTP_USER: "${config.sops.placeholder."admin/noreply"}"
        SMTP_PASSWORD: "${config.sops.placeholder."pocketid/smtp-pass"}"
        SMTP_FROM: "${config.sops.placeholder."admin/noreply"}"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/pocketid-secret.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
