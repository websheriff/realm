{ ... }: {

  imports = [
    ./helm.nix
    ./namespace.nix
    ./metallb-ip-pools.nix
    ./metallb-bgp-peers.nix
    ./metallb-bgp-advertisements.nix
  ];
}
