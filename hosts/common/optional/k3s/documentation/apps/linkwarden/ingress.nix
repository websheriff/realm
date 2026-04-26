{ config, ... }: {

  sops.templates."linkwarden/linkwarden-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: linkwarden
        namespace: documentation
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."linkwarden/domain"}`)
          kind: Rule
          services:
          - name: linkwarden-svc
            port: 3000
    '';

    path = "/var/lib/rancher/k3s/server/manifests/linkwarden-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
