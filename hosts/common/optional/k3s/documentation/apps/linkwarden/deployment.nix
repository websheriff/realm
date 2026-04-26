{ config, ... }: {

  sops.templates."linkwarden/linkwarden-deploy.yaml" = {
    content = ''
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: linkwarden
        namespace: documentation
      spec:
        selector:
          matchLabels:
            app: linkwarden

        replicas: 1

        strategy:
          type: Recreate

        template:
          metadata:
            labels:
              app: linkwarden

          spec:
            containers:
              - name: linkwarden
                image: ghcr.io/linkwarden/linkwarden:v2.14.1
                env:
                  - name: DATABASE_URL
                    valueFrom:
                      secretKeyRef:
                        name: linkwarden-db
                        key: uri
                        optional: false
                  - name: NEXTAUTH_SECRET
                    valueFrom:
                      secretKeyRef:
                        name: linkwarden
                        key: nextauth-secret
                        optional: false
                  - name: NEXTAUTH_URL
                    value: https://${config.sops.placeholder."linkwarden/domain"}/api/v1/auth
                ports:
                  - containerPort: 3000
                    protocol: TCP
                    name: linkwarden
                resources:
                  memory: "1Gi"

            restartPolice: Always
    '';

    path = "/var/lib/rancher/k3s/server/manifests/linkwarden-deploy.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
