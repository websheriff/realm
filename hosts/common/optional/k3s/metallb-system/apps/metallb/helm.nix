{ ... }: {

  services.k3s.autoDeployCharts.metallb = {
    name = "metallb";
    targetNamespace = "metallb-system";
    createNamespace = true;
    repo = "https://metallb.github.io/metallb";
    version = "0.15.3";   
  };
}
