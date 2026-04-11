{ config, ... }: {

  sops.templates."traefik-authentik-catchall.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: authentik-catchall
        namespace: kube-system
      spec:
        entryPoints:
          - websecure

        routes:
          - kind: Rule
            match: Host(`*.${config.sops.placeholder."admin/prod-domain"}`) && PathPrefix(`/outpost.goauthentik.io/`)
            priority: 100
            services:
              - kind: Service
                name: authentik-server
                port: 80

          - kind: Rule
            match: Host(`*.${config.sops.placeholder."admin/prod-domain"}`)
            priority: 90
            middlewares:
              - name: authentik
                namespace: kube-system
            services:
              - kind: Service
                name: noop@internal
                namespace: kube-system
                port: 80
    '';

    path = "/var/lib/rancher/k3s/server/manifests/traefik-authentik-catchall.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
