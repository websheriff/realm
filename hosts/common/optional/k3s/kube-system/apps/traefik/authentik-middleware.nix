{ ... }: {

  sops.templates."traefik-forward-auth-middleware.yaml" = {
    content = ''
      apiVersion: traefik.io/v1alpha1
      kind: Middleware
      metadata:
        name: authentik
        namespace: kube-system
      
      spec:
        forwardAuth:
          address: "http://authentik-server.authentik.svc.cluster.local:9000/outpost.goauthentik.io/auth/traefik"
          trustForwardHeader: true
          authResponseHeaders:
            - X-authentik-username
            - X-authentik-groups
            - X-authentik-entitlements
            - X-authentik-email
            - X-authentik-name
            - X-authentik-uid
            - X-authentik-jwt
            - X-authentik-meta-jwks
            - X-authentik-meta-outpost
            - X-authentik-meta-provider
            - X-authentik-meta-app
            - X-authentik-version
    '';

    path = "/var/lib/rancher/k3s/server/manifests/traefik-forward-auth-middleware.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
