{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.features.cli.fish;
in {
  options.features.cli.fish.enable = mkEnableOption "enable fish";
  config = mkIf cfg.enable {
  
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
      shellAbbrs = {
        k = "kubectl";
        grep = "rg";
      };
    };
  };
}
