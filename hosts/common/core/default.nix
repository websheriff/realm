{ ... }: {
  imports = [
    ./sops.nix
    ./fish.nix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  #home-manager.useGlobalPkgs = true;
}
