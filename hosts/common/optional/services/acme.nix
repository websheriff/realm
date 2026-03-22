{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.optional.services.acme;
  email = config.sops.secrets."admin/email".path;
  dev-domain = config.sops.secrets."admin/dev-domain".path;
in {
  options.optional.services.acme.enable = mkEnableOption "enable acme";
  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = "${email}";
      defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";

      certs = {
        "${dev-domain}" = {
          group = config.services.caddy.group;

          domain = "*.${dev-domain}";
          dnsProvider = "cloudflare";
          dnsResolver = "1.1.1.1:53";
          dnsPropagationCheck = true;
          environmentFile = config.sops.secrets."admin/cloudflare-api".path;     
        };
      };
    };
  };
}
