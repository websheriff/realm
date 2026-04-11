{ ... }: {

  imports = [
    ./helm.nix
    ./ingress.nix
    ./middleware.nix
    ./service.nix
    ./authentik-ingressroute.nix
    ./authentik-middleware.nix
  ];
}
