{ ... }: {

  imports = [
    ./apps/argocd
    ./apps/forgejo
  ];

  services.k3s.manifests.cicd-ns.content = {
    apiVersion = "v1";
    kind = "namespace";
    metadata.name = "cicd";
  };
}
