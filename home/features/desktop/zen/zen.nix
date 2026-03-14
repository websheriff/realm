{ config, lib, ... }:
with lib; let
  cfg = config.features.desktop.zenbrowser;
in {
  options.features.desktop.zenbrowser = mkEnableOption "enable zen browser";

  config = mkIf cfg.enable {
    imports = [ inputs.zen-browser.homeModules.beta ];

    programs.zen-browser = {
      enable = true;
      languagePacks = ["en-US"];

      setAsDefaultBrowser = true;

      profiles.default = rec {
        settings = {
          "zen.workspaces.continue-where-left-off" = true;
        };
      };

      pins = {
        
      };

      spacesForce = True;
      spaces = {
        
      };
    };
  };
}
