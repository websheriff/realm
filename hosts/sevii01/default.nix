{ config, ... }: {
  imports = [
    ../common
    ./configuration.nix
    ./hardware-configuration.nix
    ./disk-config.nix
    #./impermanence.nix
  ];

  nixpkgs.config.allowUnfree = true;


}
