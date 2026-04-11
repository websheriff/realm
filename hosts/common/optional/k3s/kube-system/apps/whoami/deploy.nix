{ ... }: {

  services.k3s.manifests.whoami-deployment.content = {

    apiVersion = "apps/v1";
    kind = "Deployment";
    metadata = {
      name = "whoami-deployment";
    };
    spec = {
      selector = {
        matchLabels = {
          app = "whoami";
        };
      };
      replicas = 1;
      template = {
        metadata = {
          labels = {
            app = "whoami";
          };
        };
        spec = {
          containers = [
            {
              image = "traefik/whoami:latest";
              name = "whoami";
              ports = [
                {
                  containerPort =  80;
                }
              ];
            }
          ];
        };
      };
    };
  };
}
