{ ... }: {
#Configures K3s installed traefik

  services.k3s.manifests.traefik-config.content = {
    apiVersion = "helm.cattle.io/v1";
    kind = "HelmChartConfig";
    metadata = {
      name = "traefik";
      namespace = "kube-system";
    };
    spec = {
      valuesContent = ''
        rbac:
          enabled: true
          namespaced: false

        globalArguments:
          - "--global.sendanonymoususage=false"
          
        deployment:
          enabled: true
          replicas: 1

        service:
          enabled: true
          type: LoadBalancer
          externalTrafficPolicy: Local
          
        ports:
          web:
            http:
              redirections:
                entryPoint:
                  to: websecure
                  scheme: https
                  permanent: true
          websecure:
            http3:
              enabled: true
            advertisedPort: 4443
            tls:
              enabled: true

        providers:
          kubernetesIngress:
            enabled: true
            allowExternalNameServices: true
            publishedSerivce:
              enabled: false
          kubernetesCRD:
            enabled: true
            allowExternalNameServices: true
            allowCrossNamespace: true

        ingressClass:
          enabled: true
          isDefaultClass: true

        tlsStore:
          default:
            defaultCertificate:
              secretName: prod-wildcard-tls

        experimental:
          kubernetesGateway:
            enabled: false

        additionalArguments:
          - "--log.level=INFO"
          - "--serversTransport.insecureSkipVerify=true"
      '';
    };
  };
}
