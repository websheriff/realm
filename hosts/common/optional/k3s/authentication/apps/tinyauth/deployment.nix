{ config, ... }: {

  sops.templates."tinyauth/tinyauth-deployment.yaml" = {
    content = ''
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: tinyauth
        labels:
          app: tinyauth
        namespace: authentication
        
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: tinyauth

        template:
          metadata:
            labels:
              app: tinyauth
          spec:
            containers:
              - name: tinyauth
                image: ghcr.io/steveiliop56/tinyauth:v5
                ports:
                  - containerPort: 3000

                env:
                  - name: TINYAUTH_APPURL
                    value: ${config.sops.placeholder."tinyauth/domain"}
                  - name: TINYAUTH_OAUTH_PROVIDERS_POCKETID_CLIENTID
                    value: ${config.sops.placeholder."tinyauth/pocket-id/client-id"}
                  - name: TINYAUTH_OAUTH_PROVIDERS_POCKETID_CLIENTSECRET
                    value: ${config.sops.placeholder."tinyauth/pocket-id/client-secret"}
                  - name: TINYAUTH_OAUTH_PROVIDERS_POCKETID_AUTHURL
                    value: ${config.sops.placeholder."pocket-id/domain"}/authorize
                  - name: TINYAUTH_OAUTH_PROVIDERS_POCKETID_TOKENURL
                    value: ${config.sops.placeholder."pocket-id/domain"}/oidc/token
                  - name: TINYAUTH_OAUTH_PROVIDERS_POCKETID_USERINFOURL
                    value: ${config.sops.placeholder."pocket-id/domain"}/api/oidc/userinfo
                  - name: TINYAUTH_OAUTH_PROVIDERS_POCKETID_REDIRECTURL
                    value: ${config.sops.placeholder."pocket-id/domain"}/api/oauth/callback/pocketid
                  - name: TINYAUTH_OAUTH_PROVIDERS_POCKETID_SCOPES
                    value: openid email profile groups
                  - name: TINYAUTH_OAUTH_PROVIDERS_POCKETID_NAME
                    value: Pocket ID

                livenessProbe:
                  exec:
                    command:
                      - tinyauth
                      - healthcheck
                  initialDelaySeconds: 10
                  periodSeconds: 30

                readinessProbe:
                  exec:
                    command:
                      - tinyauth
                      - healthcheck
                  initialDelaySeconds: 5
                  periodSeconds: 10
    '';
  };
}
