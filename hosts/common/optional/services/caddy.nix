{ pkgs, config, ... }:
with lib; let
  cfg = config.optional.services.caddy;
in {
  options.optional.services.caddy.enable = mkEnableOption "enable caddy";
  config = mkIf cfg.enable {

    services.caddy = {
      enable = true;
  };
}
