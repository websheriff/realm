{ config, ... }: {

  sops.templates."authentik/authentik.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: authentik
        namespace: kube-system
      spec:
        repo: https://charts.goauthentik.io
        chart: authentik
        version: "2026.2.1"
        targetNamespace: authentik-system
        createNamespace: true
        valuesContent: |
          authentik:
            secret_key:

            postgresql:
              host:
              user:
              password:

            email:
              hosts: "smtp.fastmail.com"
              port: 587
              username: ""
              password: ""
              use_tls: true
              use_ssl: false
              timeout: 30
              from: ""

          server:
            ingress:
              ingressClassName: traefik
              enabled: true
              hosts:
                -
    ''
  };
}
