{ ... }: {
  imports = [
    ./kube-system
    ./metallb-system
    ./cert-manager
    ./cnpg-system
    ./vaultwarden
    ./documentation
    ./authentication
    ./netbird
  ];
}
