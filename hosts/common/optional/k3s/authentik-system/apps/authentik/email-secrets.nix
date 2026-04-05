{ config, ... }: {

  sops.templates."authentik/authentik-email-secrets.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: authentik-email-secrets
        namespace: authentik-system
      type: Opaque
      stringData:
        username: "${config.sops.placeholder."authentik/email/user"}"
        password: "${config.sops.placeholder."authentik/email/password"}"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/authentik-email-secrets.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
