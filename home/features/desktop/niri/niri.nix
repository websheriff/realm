{ config, lib, inputs, ... }:
with lib; let
  cfg = config.features.desktop.niri;
in {
  options.features.desktop.niri.enable = mkEnableOption "enable niri";
  config = mkIf cfg.enable {

    programs.niri.enable = true;
    xdg.configFile."niri/config.kdl".source = ./config/config.kdl;
    
    #DMS flake
    imports = [
      inputs.dms.homeModules.dank-material-shell
      inputs.dms-plugin-registry.modules.default
    ];
    
    programs.dank-material-shell = {
      enable = true;

      systemd = {
        enable = true;
        restartIfChanged = true;
      };
      #dgop flake
      enableSystemMonitoring = true;
      dgop.package = inputs.dgop.packages.${pkgs.system};
      
      enableVPN = true;
      enableDynamicTheming = false;
      enableAudioWaveLength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;

      plugins = {
        homeAssistantMonitor.enable = true;
        dankKDEConnect.enable = true;
        aiAssistant.enable = true;
      };
    };
  };
}
