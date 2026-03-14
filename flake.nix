{
	description = "Nixcfg Flake";
	inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
		nixpkgs.url = "nixpkgs/nixos-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
		home-manager = {
			url = "github:nix-community/home-manager/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		sops-nix = {
		  url = "github:Mic92/sops-nix";
		  inputs.nixpkgs.follows = "nixpkgs";
		};
    flake-parts.url = "github:hercules-ci/flake-parts";
    agenix.url = "github:ryantm/agenix";
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	};

	outputs = {
	  self,
	  agenix,
	  sops-nix,
	  flake-parts,
	  nixpkgs,
	  nixpkgs-unstable,
	  disko,
	  impermanence,
	  home-manager,
	  ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      homeManagerModules = import ./modules/home-manager;

		  nixosConfigurations = {
			  kanto = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
			    modules = [
				    ./hosts/kanto
            agenix.nixosModules.default
            sops-nix.nixosModules.sops
			    ];
		    };
	    };
      #nixosConfigurations = {
      #  charizard = nixpkgs.lib.nixosSystem {
      #    specialArgs = { inherit inputs outputs; };
      #    modules = [
      #      ./hosts/charizard
      #    ];
      #  };
      #};
      nixosConfigurations = {
        sevii01 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/sevii01
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            agenix.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
      };
#      homeConfigurations = {
#        "websheriff@charizard" = home-manager.lib.homeManagerConfiguration {
#          pkgs = nixpkgs.legacyPackages."x86_64-linux";
#          extraSpecialArgs = { inherit inputs outputs; };
#          modules = [
#            ./home/websheriff/home.nix
#          ];
#        };
#        "websheriff@kanto" = home-manager.lib.homeManagerConfiguration {
#          pkgs = nixpkgs.legacyPackages."x86_64-linux";
#          extraSpecialArgs = { inherit inputs outputs; };
#          modules = [
#            ./home/websheriff/home.nix
#          ];
#        };
#        "aiRunner@kanto" = home-manager.lib.homeManagerConfiguration {
#          pkgs = nixpkgs.legacyPackages."x86_64-linux";
#          extraSpecialArgs = { inherit inputs outputs; };
#          modules = [
#            ./home/aiRunner/home.nix
#          ];
#        };
#        "websheriff@sevii01" = home-manager.lib.homeManagerConfiguration {
#          pkgs = nixpkgs.legacyPackages."x86_64-linux";
#          extraSpecialArgs = { inherit inputs outputs; };
#          modules = [
#            ./home/websheriff/home.nix
#          ];
#        };
#      };
    };
}
