{ config, ... }: {
  imports = [
    #../common
    #../common/optional/services/llm.nix
    ./configuration.nix
    ./hardware-configuration.nix
    ../../services
    ./secrets.nix
  ];
}
