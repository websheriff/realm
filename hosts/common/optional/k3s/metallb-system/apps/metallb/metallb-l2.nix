{ ... }: {

  services.k3s.manifests.metallb-l2.content = [
    {
      apiVersion = "metallb.io/v1beta1";
      kind = "L2Advertisement";
      metadata = {
        name = "internal-l2";
        namespace = "metallb-system";
      };
      spec = {
       ipAddressPools = "internal-pool";
       interfaces = "eno1.50";
      };
    }
    {
      apiVersion = "metallb.io/v1beta1";
      kind = "L2Advertisement";
      metadata = {
        name = "exposed-l2";
        namespace = "metallb-system";
      };
      spec = {
        ipAddressPools = "exposed-pool";
        interfaces = "eno1.100";
      };
    }
  ];
}
