{ ... }: {
  sops = {
    defaultSopsFile = ../../../secrets.yaml;
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    #Common
    secrets."admin/email" = {};
    secrets."admin/base-domain" = {};
    secrets."admin/dev-domain" = {};
    secrets."admin/prod-domain" = {};
    secrets."admin/cloudflare-api" = {};

    #Users
    secrets."users/websheriff/password" = {};
    secrets."users/websheriff/email" = {};

    #FluxCD
    secrets."fluxcd/ssh-key" = {};

    #Forgejo
    secrets."forgejo/dev/domain" = {};
    secrets."forgejo/dev/known-host" = {};
    secrets."forgejo/dev/access-token" = {};
  };
}
