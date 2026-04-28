{ config, ... }: {

  sops.templates."pocketid/pocketid-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: pocketid
        namespace: authentication
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."pocketid/domain"}`)
          kind: Rule
          services:
          - name: pocketid-pocket-id
            port: 1411
    '';

    path = "/var/lib/rancher/k3s/server/manifests/pocketid-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
