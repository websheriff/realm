{ config, pkgs, inputs, ... }:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  sops.secrets."users/websheriff/password".neededForUsers = true;
  users.users.websheriff = {
    isNormalUser = true;
    extraGroups = ifExists [
      "wheel"
      "networkmanager"
      "flatpak"
      "audio"
      "video"
      "minecraft"
     ];
    hashedPasswordFile = config.sops.secrets."users/websheriff/password".path;
    packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
  users.groups.websheriff = {};

  home-manager.users.websheriff = import ../../../home/websheriff/${config.networking.hostName}.nix;
}
