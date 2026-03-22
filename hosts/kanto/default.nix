{ config, ... }: {
  imports = [
    ../common
    ../common/optional
    ./configuration.nix
    ./hardware-configuration.nix
    ../../services
    ./secrets.nix
  ];

  optional = {
  #  k3s.enable = false;
    
    services = {
      caddy.enable = true;
      acme.enable = true;
      forgejo.enable = true;
    };
  };  
}
