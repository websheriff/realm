{ ... }: {

  services.k3s.manifest.cert-manager-helm.content = {
    apiVersion = "helm.cattle.io/v1";
    kind = "HelmChart";
    metadata = {
      name = "cert-manager";
      namespace = "cert-manager";
    };
    spec = {
      repo = "https://charts.jetstack.io";
      chart = "cert-manager";
      version = "1.20.0";
      targetNameSpace = "cert-manager";
      createNamespace = "true";
      valuesContent = ''
        installCRDs: true
      '';
    };
  };
}
