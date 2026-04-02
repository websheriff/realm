{ config, ... }: {

  sops.templates."traefik-ingress-dashboard.yaml" = {
    content = ''
      apiVersion: networking.k8s.io/v1
      kind: Ingress
      metadata:
        name: traefik-dashboard
        namespace: kube-system
      spec:
        ingressClassName: traefik
        rules:
        - host: "${config.sops.placeholder."traefik-dashboard/domain"}"
          http:
            paths:
            - path: /dashboard
              pathType: Prefix
              backend:
                service:
                  name: traefik-dashboard
                  port:
                    number: 8080
            - path: /api
              pathType: Prefix
              backend:
                service:
                  name: traefik-dashboard
                  port:
                    number: 8080
    '';

    path = "/var/lib/rancher/k3s/server/manifests/traefik-ingress-dashboard.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
