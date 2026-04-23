{ ... }: {

  imports = [];

  services.k3s.manifests.authentication-ns.content = {
    apiVersion = "v1";
    kind = "Namespace";
    metadata.name = "authentication";
  };
}
