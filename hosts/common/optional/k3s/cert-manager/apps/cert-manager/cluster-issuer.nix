{ config, ... }: {

  sops.templates."cert-manager/cluster-issuer.yaml" = {
    content = ''
      apiVersion: cert-manager.io/v1
      kind: ClusterIssuer
      metadata:
        name: letsencrypt-prod
      spec:
        acme:
          email: "${config.sops.placeholder."admin/email"}"
          server: https://acme-staging-v02.api.letsencrypt.org/directory
          privateKeySecretRef:
            name: letsencrypt
          solvers:
            - dns01
                cloudflare:
                  email: "${config.sops.placeholder."admin/email"}"
                  apiTokenSecretRef:
                    name: cloudflare-api-token
                    key: apiToken
    '';
  
    path = "/var/lib/rancher/k3s/server/manifests/cert-manager-cluster-issuer.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
