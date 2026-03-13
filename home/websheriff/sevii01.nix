{
  imports = [
    ../core
    ../features/cli
    ./home.nix
  ];

  features = {
    cli = {
      fish.enable = false;
      nushell.enable = true;
    };
  };
}
