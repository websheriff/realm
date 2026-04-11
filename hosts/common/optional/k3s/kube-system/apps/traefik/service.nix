{ ... }: {

  services.k3s.manifests.traefik-svc-dashboard.content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "traefik-dashboard";
      namespace = "kube-system";
      annotations = {
        "metallb.io/address-pool" = "internal-pool";
      };
      labels = {
        "app.kubernetes.io/name" = "traefik-dashboard";
        "app.kubernetes.io/instance" = "traefik";
      };
    };
    
    spec = {
      ports = [
        {
          name = "traefik";
          port = 8080;
          targetPort = 8080;
          protocol = "TCP";
        }
      ];
      
      selector = {
        "app.kubernetes.io/name" = "traefik";
        "app.kubernetes.io/instance" = "traefik-kube-system";    
      };
    };
  };
}
