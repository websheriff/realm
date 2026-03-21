{ inputs, ... }: {
  
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  
  sops = {
    age.keyFile = "/home/websheriff/.config/sops/age/keys.txt";

    defaultSopsFile = ../../secrets.yaml;
    validateSopsFile = false;

    secrets."websheriff/private_key" = {
      path = "/home/websheriff/.ssh/id_ed25519";
    };
  };
}
