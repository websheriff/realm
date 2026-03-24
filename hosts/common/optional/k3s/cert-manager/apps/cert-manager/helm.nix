{ ... }: {
  
  services.k3s.autoDeployCharts.cert-manager = {
    name = "cert-manager";
    repo = "https://charts.jetstack.io";
    target-namespace = "cert-manager";
    create-namespace = "true";
    version = "1.20.0";
    values = {
      installCRDs = true;
    };
  };
}
