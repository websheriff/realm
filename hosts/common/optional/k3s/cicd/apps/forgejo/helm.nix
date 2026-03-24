{ ... } :{

  services.k3s.autoDeployCharts.forgejo = {
    name = "forgejo";
    targetNamespace = "cicd";
    createNamespace = true;
    repo = "oci://code.forgejo.org/forgejo-helm/forgejo";
    version = "16.2.1";
  };
}
