{ config, pkgs, ... }: {

  imports = [
    ./fish.nix
    ./nushell.nix
  ];
  
  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  home.packages = with pkgs; [
    fd
    btop
    just
    ripgrep
    yazi
  ];
}
