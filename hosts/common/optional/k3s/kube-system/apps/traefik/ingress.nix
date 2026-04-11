{ config, ... }: {

  sops.templates."traefik-dashboard-ingressroute.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: IngressRoute
      metadata:
        name: traefik-dashboard
        namespace: kube-system
        annotations:
          kubernetes.io/ingress.class: traefik
        labels:
          app.kubernetes.io/name: traefik-dashboard
          app.kubernetes.io/instance: traefik
      spec:
        entryPoints:
          - web
          - websecure
        routes:
          - kind: Rule
            match: "Host(`${config.sops.placeholder."traefik-dashboard/domain"}`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`))"
            services:
              - kind: TraefikService
                name: api@internal
          - kind: Rule
            match: "Host(`${config.sops.placeholder."traefik-dashboard/domain"}`) && Path(`/`)"
            middlewares:
              - name: traefik-dashboard-redirect
            services:
              - kind: TraefikService
                name: api@internal
    '';

    path = "/var/lib/rancher/k3s/server/manifests/traefik-dashboard-ingressroute.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
