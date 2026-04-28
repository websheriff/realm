{ config, ... } :{

  sops.templates."forgejo/helm.yaml" = {
    content = ''
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: forgejo
        namespace: kube-system
      spec:
        repo: oci://code.forgejo.org/forgejo-helm/forgejo
        version: "16.2.1"
        chart: forgejo
        targetNamespace: cicd
        createNamespace: false
        valuesContent: |
          gitea:
            metrics:
              enabled: true
              serviceMonitor:
                enabled: true

            admin:
              exisitingSecret: forgejo-admin

            config:
              database:
                DB_TYPE: postgres
                NAME: forgejo

            additionalConfigFromEnvs:
              - name: FORGEJO__DATABASE__HOST
                valueFrom:
                  secretKeyRef:
                    name: forgejo-db
                    key: host
              - name: FORGEJO__DATABASE__USER
                valueFrom:
                  secretKeyRef:
                    name: forgejo-db
                    key: user
              - name: FORGEJO__DATABASE__PASSWD
                valueFrom:
                  secretKeyRef:
                    name: forgejo-db
                    key: password
          service:
            http:
              type: LoadBalancer
              annotations:
                metallb.io/address-pool: internal-pool
                metallb.io/allow-shared-ip: "forgejo"
            ssh:
              type: LoadBalancer
              annotations:
                metallb.io/address-pool: internal-pool
                metallb.io/allow-shared-ip: "forgejo"

          ingress:
            enabled: false
            hosts:
              - host: ${config.sops.placeholder."forgejo/prod/domain"}
    '';
  };
}
