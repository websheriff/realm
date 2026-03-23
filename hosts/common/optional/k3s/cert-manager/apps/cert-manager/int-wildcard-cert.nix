{ config, ... }: {

  sops.templates."cert-manager/prod-wildcard-cert.yaml" = {
    content = ''
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: prod-wildcard
        namespace: traefik
      spec:
        secretName: prod-wildcard-tls
        dnsNames:
          - "*.${config.sops.placeholder."admin/prod-domain"}"
        issuerRef:
          name: letsencrypt-prod
          kind: ClusterIssuer
    '';

    path = "/var/lib/rancher/k3s/server/manifests/prod-wildcard-cert.yaml";
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
