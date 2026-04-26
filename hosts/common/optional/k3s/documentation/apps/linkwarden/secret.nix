{ config, ... }: {

  sops.templates."linkwarden/secret.yaml" = {
    content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: linkwarden
        namespace: documentation
      type: Opaque
      stringData:
        nextauth-secret: "${config.sops.placeholder."linkwarden/nextauth-secret"}"        
    '';

    path = "/var/lib/rancher/k3s/server/manifests/linkwarden-secret.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
