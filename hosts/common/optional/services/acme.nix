{ config, pkgs, ... }:
with lib; let
  cfg =
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = config.sops.secrets."admin/email".path;

    certs."dev."
  };
}
