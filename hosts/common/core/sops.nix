{ ... }: {
  sops = {
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    #common
    secrets."admin/emails/admin" = {};
    secrets."admin/emails/noreply" = {};
    secrets."admin/emails/alerts" = {};
    secrets."admin/base-domain" = {};
    secrets."admin/dev-domain" = {};
    secrets."admin/prod-domain" = {};
    secrets."admin/cloudflare-api" = {};

    #hosts
    secrets."hosts/sevii01/ip" = {};
    
    #users
    secrets."users/websheriff/password" = {};
    secrets."users/websheriff/email" = {};

    #authentik
    secrets."authentik/secret-key" = {};
    secrets."authentik/domain" = {};
    secrets."authentik/database/host" = {};
    secrets."authentik/database/user" = {};
    secrets."authentik/database/password" = {};
    secrets."authentik/email/user" = {};
    secrets."authentik/email/password" = {};
    
    #forgejo
    secrets."forgejo/dev/domain" = {};
    secrets."forgejo/dev/known-host" = {};
    secrets."forgejo/dev/access-token" = {};

    #cert-manager
    secrets."cert-manager/cloudflare-apiToken" = {};

    #traefik
    secrets."traefik-dashboard/domain" = {};
    secrets."traefik/ip" = {};

    #metallb
    secrets."metallb/asn" = {};

    #opnsense
    secrets."opnsense/asn" = {};
    secrets."opnsense/ip" = {};
  };
}
