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
    secrets."admin/smtp/host" = {};
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

    #pocketid
    secrets."pocketid/domain" = {};
    secrets."pocketid/encryption-key" = {};
    secrets."pocketid/smtp-pass" = {};
    secrets."pocketid/database/host" = {};
    secrets."pocketid/database/user" = {};
    secrets."pocketid/database/password" = {};
    
    #traefik
    secrets."traefik-dashboard/domain" = {};
    secrets."traefik/ip" = {};

    #metallb
    secrets."metallb/asn" = {};

    #opnsense
    secrets."opnsense/asn" = {};
    secrets."opnsense/ip" = {};

    #linkwarden
    secrets."linkwarden/domain" = {};
    secrets."linkwarden/nextauth-secret" = {};
    secrets."linkwarden/database/host" = {};
    secrets."linkwarden/database/user" = {};
    secrets."linkwarden/database/password" = {};

    #vaultwarden
    secrets."vaultwarden/domain" = {};
    secrets."vaultwarden/admin-token" = {};
    secrets."vaultwarden/sso/client-id" = {};
    secrets."vaultwarden/sso/client-secret" = {};
    secrets."vaultwarden/sso/auth-url" = {};
    secrets."vaultwarden/database/host" = {};
    secrets."vaultwarden/database/user" = {};
    secrets."vaultwarden/database/password" = {};
  };
}
