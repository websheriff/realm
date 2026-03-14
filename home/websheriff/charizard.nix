{ ...  }: {

  imports = [
   ./home.nix
   ../core
   ../features/cli
   ../features/desktop
  ];

  features = {
    cli = {
      fish.enable = false;
      nushell.enable = true;
      starship.enable = true;
      secrets.enable = true;
    };
    desktop = {
      niri.enable = true;
      ghostty.enable = true;
      fonts.enable = true;
      media.enable = true;
      gaming.enable = true;
      zen.enable = true;
    };
  };  
}
