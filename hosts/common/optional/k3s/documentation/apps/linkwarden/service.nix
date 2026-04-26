{ ... }: {

  services.k3s.manifests.linkwarden-svc.content = {
    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "linkwarden-svc";
      namespace = "documentation";
      annotations = {
        "metallb.io/address-pool" = "internal-pool";
      };
    };

    spec = {
      ports = [
        {
          port = 3000;
          targetPort = 3000;
        }
      ];

      selector = {
        app = "linkwarden";
      };

      type = "LoadBalancer";
    };
  };
}
