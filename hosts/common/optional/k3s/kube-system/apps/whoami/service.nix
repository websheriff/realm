{ ... }: {

  services.k3s.manifests.whoami-service.content = {

    apiVersion = "v1";
    kind = "Service";
    metadata = {
      name = "whoami-svc";
    };
    spec = {
      ports = [
        {
          port =  80;
          targetPort = 80;
          protocol = "TCP";
        }
      ];
      selector = {
        app = "whoami";
      };
    };
  };
}
