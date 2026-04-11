{ config, ... }: {

  sops.templates."authentik/authentik-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: authentik
        namespace: authentik
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."authentik/domain"}`)
          kind: Rule
          services:
          - name: authentik-server
            port: 9000
    '';

    path = "/var/lib/rancher/k3s/server/manifests/authentik-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
