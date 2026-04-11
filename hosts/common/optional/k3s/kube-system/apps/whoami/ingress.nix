{ ... }: {

  services.k3s.manifests.whoami-ingress.content = {

    apiVersion = "traefik.io/v1alpha1";
    kind = "IngressRoute";
    metadata = {
      name = "whoami-service-ingressroute";
      annotations = {
        "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure";
      };
    };
    spec = {
      routes = [
        {
          match =  "Host(`whoami.prod.002042.xyz`)";
          kind = "Rule";
          services = [ 
            {
              name = "whoami-svc";
              port = 80;
              scheme = "http";
            }
          ];
        }
      ];
    };
  };
}
