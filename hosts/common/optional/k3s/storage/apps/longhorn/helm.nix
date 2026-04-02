{ ... }:{

  services.k3s.autoDeployCharts.longhorn = {
    name = "longhorn";
    repo = "https://charts.longhorn.io";
    hash = "sha256-qT9gBS5ebjCNB+k/s+zA5NM2u9MjtyXwaJ3y5NaVJFs=";
    targetNamespace = "longhorn-system";
    createNamespace = true;
    version = "1.11.1";
  };
}
