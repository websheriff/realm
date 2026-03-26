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
        globalArguments:
          - "--global.sendanonymoususage=false"
          
        deployment:
          replicas: 3

        affinity:
          podAntiAffinity:
            preferredDuringSchedulingIgnoredDuringExecution:
              - weight: 100
                podAffinityTerm:
                  labelSelector:
                    matchLabels:
                      app.kubernetes.io/name: traefik
                  topologyKey: kubernetes.io/hostname
        service:
          enabled: true
          type: LoadBalancer
          externalTrafficPolicy: Local
          
        ports:
          web:
            port: 8000
            expose:
              default: true
            exposedPort: 80
            protocol: TCP
          websecure:
            port: 8443
            expose:
              default: true
            exposedPort: 443
            protocol: TCP
            tls:
              enabled: true

        providers:
          kubernetesIngress:
            enabled: true
            ingressClass: traefik
            kubernetesCRD:
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
          - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
          - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      '';
    };
  };
}
