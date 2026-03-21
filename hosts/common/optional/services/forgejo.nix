{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.optional.services.forgejo;
in
let
  forgecfg = config.services.forgejo;
  srv = forgecfg.settings.server;
in {
  options.optional.services.caddy.enable = mkEnableOption "enable forgejo";
  config = mkIf cfg.enable {

    services.caddy = {
      virtualHosts."git.dev.${config.sops.sercrets."admin/base-domain"}.path
        services.caddy = {
          virtualHosts."git.dev.${config.sops.sercrets."admin/base-domain"}.path".extraConfig = ''
          reverse_proxy http://localhost:3000

         tls /var/lib/acme/dev.${config.sops.secrets."admin/base-domain"}.path/cert.pem /var/lib/acme/dev.${config.sops.secrets."admin/base-domain"}.path/key.pem {
            protocols tls1.3
          }
        '';
        };"
          .extraConfig = ''
        reverse_proxy http://localhost:3000

        tls /var/lib/acme/dev.${config.sops.secrets."admin/base-domain"}.path/cert.pem /var/lib/acme/dev.${config.sops.secrets."admin/base-domain"}.path/key.pem {
          protocols tls1.3
        }
      '';
    };
    
    services.forgejo = {
      enable = true;
      database.type = "postgres";
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = "git.dev.${config.sops.secrets."admin/base-domain"}.path";
          ROOT_URL = "https://${srv.DOMAIN}/";
          HTTP_PORT = 3000;
        };

        service.DISABLE_REGISTRATION = true;

        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };

        mailer = {
          ENABLED = false;
        };
      };
    };
  
    services = {
      forgejo.settings.server.SSH_PORT = lib.head config.services.openssh.ports;
    };

    #services.gitea-actions-runner = {
      #package = pkgs.forgejo-runner;
      #instances.default = {
        #enable = true;
        #name = "";
        #url = "https://git.dev.${config.sops.secrets."admin/base-domain"}.path";
        #tokenFile = ;
        #label = [
          #"native:host"
        #];
      #};
    #};
}
