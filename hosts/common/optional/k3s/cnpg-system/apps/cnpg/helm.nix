{ ... }: {

  services.k3s.autoDeployCharts.cloudnative-pg = {
    name = "cloudnative-pg";
    repo = "https://cloudnative-pg.io/charts";
    hash = "sha256-gdN4lPNgbfm9kcVRkFP0GnnoM9KKyiUv+zkpTLnLGa4";
    targetNamespace = "cnpg-system";
    createNamespace = true;
    version = "0.28.0";
  };
}
