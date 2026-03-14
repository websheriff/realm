{ pkgs, ... }: {

  imports = [
    ./niri
    ./ghostty.nix
    ./zen
    ./gaming.nix
    ./media.nix
    ./fonts.nix
  ];

  #additional pkgs
  home.packages = with pkgs; [
    signal-desktop
    bitwarden-desktop
    element-desktop
  ];

  
}
