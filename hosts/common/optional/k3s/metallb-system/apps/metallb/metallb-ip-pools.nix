{ ... }: {

  services.k3s.manifests.metallb-ip-pools.content = [
    {
     apiVersion = "metallb.io/v1beta1";
     kind = "IPAddressPool";
     metadata = {
       name = "internal-pool";
       namespace = "metallb-system";
       labels = {
         environment = "internal";
         vlan = "50";
       };
     };
     spec = {
       addresses = "10.5.50.100-10.5.50.200";
       autoAssign = true;
       avoidBuggyIPs = true;
     }; 
    }
    {
      apiVersion = "metallb.io/v1beta1";
      kind = "IPAddressPool";
      metadata = {
        name = "exposed-pool";
        namespace = "metallb-system";
        labels = {
          environment = "exposed";
          vlan = "100";
        };
      };
      spec = {
        address = "10.5.100.145-10.5.100.150";
        autoAssign = false;
        avoidBuggyIPs = true;
      };
    }
  ];
}
