{ config, ... }: {

  sops.templates."cert-manager/cloudflare-api-token.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: cloudflare-api-token
        namespace: cert-manager
      type: Opaque
      stringData:
        email: "${config.sops.placeholder."admin/emails/admin"}"
        apiToken: "${config.sops.placeholder."cert-manager/cloudflare-apiToken"}"
    '';

    path = "/var/lib/rancher/k3s/server/manifests/cloudflare-api-token.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  }; 
}
