{
  imports = [
    ../core/sops.nix
    ../features/cli
    ./home.nix
  ];

  features = {
    cli = {
      fish.enable = false;
      nushell.enable = true;
      starship.enable = true;
    };
  };  
}
