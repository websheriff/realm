{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.features.desktop.gaming;
in {
  
  options.features.desktop.gaming.enable = mkEnableOption "enable gaming related pkgs";

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };

    programs.gamemode.enable = true;
    
    home.packages = with pkgs; [
      gamescope-wsi
      proton-ge-bin
      protonplus
      mangohud
    ];
  
} 
