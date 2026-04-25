{ ... }: {

  imports = [
    ./helm.nix
    ./database.nix
    ./db-auth.nix
    ./secret-db.nix
    ./secret-admin.nix
    ./secret-oidc.nix
    ./ingress.nix
  ];
}
