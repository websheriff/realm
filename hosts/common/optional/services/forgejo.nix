{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.optional.services.forgejo;
  forgecfg = config.services.forgejo;
  srv = forgecfg.settings.server;
  certloc = "/var/lib/acme/dev.002042.xyz";
  git-devDomain = "git.dev.002042.xyz";
in {
  options.optional.services.forgejo.enable = mkEnableOption "enable forgejo";
  config = mkIf cfg.enable {

    services.caddy = {
      virtualHosts."${git-devDomain}".extraConfig = ''
        reverse_proxy http://localhost:3000

        tls ${certloc}/cert.pem ${certloc}/key.pem {
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
          DOMAIN = "${git-devDomain}";
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
        #url = "https://${config.sops.secrets."forgego/dev/domain".path}";
        #tokenFile = ;
        #label = [
          #"native:host"
        #];
      #};
    };
}
