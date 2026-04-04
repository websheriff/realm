{ ... }: {

  imports = [
    ./apps/netbird
  ];

  services.k3s.manifests.netbird-ns.content = {
    apiVersion = "v1";
    kind = "Namespace";
    metadata = {
      name = "netbird";
    };
  };
}
