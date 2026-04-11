{ ... }: {

  services.k3s.manifests.authentik-svc.content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "authentik-server";
      namespace = "authentik";
      annotations = {
        "metallb.io/address-pool" = "exposed-pool";
      };
      labels = {
        "app.kubernetes.io/name" = "authentik";
        "app.kubernetes.io/instance" = "authentik";
      };
    };
    
    spec = {
      ports = [
        {
          name = "http";
          protocol = "TCP";
          port = 80;
          targetPort = 9000;
        }
        {
          name = "https";
          protocol = "TCP";
          port = 443;
          targetPort = 9443;
        }
      ];
      
      selector = {
        app = "authentik";
      };
      
      type = "LoadBalancer";
    };
  };
}
