{ ... }: {

  imports = [
    ./apps/linkwarden
  ];

  services.k3s.manifests.documentation-ns.content = {
    apiVersion = "v1";
    kind = "Namespace";
    metadata.name = "documentation";
  };
}
