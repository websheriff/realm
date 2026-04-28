{ config, ... }: {

  sops.templates."forgejo/forgejo-ingress.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: forgejo
        namespace: cicd
      spec:
        entryPoints:
          - websecure
        routes:
        - match: Host(`${config.sops.placeholder."forgejo/prod/domain"}`)
          kind: Rule
          services:
            - name: forgejo
              port: 3000
    '';

    path = "/var/lib/rancher/k3s/server/manifests/forgejo-ingress.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
