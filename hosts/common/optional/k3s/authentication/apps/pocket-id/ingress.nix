{ config, ... }: {

  sops.templates."pocket-id/pocket-id-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: pocket-id
        namespace: authentication
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."pocket-id/domain"}`)
          kind: Rule
          services:
          - name: pocket-id
            port: 1411
    '';

    path = "/var/lib/rancher/k3s/server/manifests/pocket-id-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
