{ ... }: {

  services.k3s.manifests.cnpg-cluster.content = [
    {
      apiVersion = "postgresql.cnpg.io/v1";
      kind = "Cluster";
      metadata = {
        name = "cnpg-cluster";
      };
      spec = {
        instances = 1;
        storage = {
          size = "1Gi";
        };
      };
    }
  {
    apiVersion = "monitoring.coreos.com/v1";
    kind = "PodMonitor";
    metadata = {
      name = "cnpg-cluster-metrics";
    };
    spec = {
      selector = {
        matchLabels = {
          "cnpg.io/cluster" = "cnpg-cluster-metrics";
        };
        podMetricsEndpoints = [
          {
            port = "metrics";  
          }
        ];
      };
    };
  }
  ];
}
