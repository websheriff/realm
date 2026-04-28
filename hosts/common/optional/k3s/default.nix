{ ... }: {
  imports = [
    ./kube-system
    ./metallb-system
    ./cert-manager
    ./cnpg-system
    ./authentik-system
    ./vaultwarden
    ./documentation
    ./authentication
    ./netbird
  ];
}
