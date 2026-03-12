{ ... }: {
  imports = [
    ../common/core
    ./configuration.nix
    ./hardware-configuration.nix
    ./disk-config.nix
    #./impermanence.nix
    ./secrets.nix
  ];
}
