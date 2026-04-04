{ ... }: {
  imports = [
    ./kube-system
    ./metallb-system
    ./cert-manager
    ./storage
    ./cnpg-system
  ];
}
