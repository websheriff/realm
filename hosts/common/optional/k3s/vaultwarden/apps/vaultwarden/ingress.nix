{ config, ... }: {

  sops.templates."vaultwarden/vaultwarden-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: vaultwarden
        namespace: vaultwarden
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."vaultwarden/domain"}`)
          kind: Rule
          services:
          - name: vaultwarden
            port: 80
    '';

    path = "/var/lib/rancher/k3s/server/manifests/vaultwarden-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
