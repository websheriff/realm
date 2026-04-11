{ config, ... }: {

  sops.templates."traefik-dashboard-redirect.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: Middleware
      metadata:
        name: traefik-dashboard-redirect
        namespace: kube-system
      spec:
        redirectRegex:
          regex: "^https://${config.sops.placeholder."traefik-dashboard/domain"}/?$"
          replacement: "https://${config.sops.placeholder."traefik-dashboard/domain"}/dashboard/"
          permanent: true
    '';

    path = "/var/lib/rancher/k3s/server/manifests/traefik-dashboard-redirect.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
