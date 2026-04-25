{ config, ... }: {

  sops.templates."vaultwarden/secret-oidc.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: vaultwarden-oidc
        namespace: vaultwarden
      type: Opaque
      stringData:
        sso-client-id: "${config.sops.placeholder."vaultwarden/sso/client-id"}"
        sso-client-secret: "${config.sops.placeholder."vaultwarden/sso/client-secret"}"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vaultwarden-secret-oidc.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
