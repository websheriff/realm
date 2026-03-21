{ lib, ... }:
with lib; let
  cfg = config.features.editors.helix;
in {
  options.features.editors.helix.enable = mkEnableOption "enable fish";
  config = mkIf cfg.enable {

    programs.helix = {
      enable = true;
      settings = {
        theme = "autumn_night";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
      languages.language = [{
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt}";
      }];
    };
  };
}
