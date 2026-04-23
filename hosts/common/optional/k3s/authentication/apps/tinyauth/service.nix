{ ... }: {

  services.k3s.manifests.tinyauth-svc.content = {
    apiVerison = "v1";
    kind = "Service";
    metadata = {
      name = "tinyauth";
      namespace = "authentication";
    };

    spec = {
      selector = {
        app = "tinyauth";
      };
      
      ports = [
        {
          port = 3000;
          targetPort = 3000;
        }
      ];
      
      type = "ClusterIP"; 
    };
  };
}
