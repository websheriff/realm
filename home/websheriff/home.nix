{ config, pkgs, ...  }:

{
	home.username = "websheriff";
	home.homeDirectory = "/home/${config.home.username}";
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "websheriff";
				email = "websheriff@fastmail.com";
			};
			init.defaultBranch = "master";
		};
	};
	home.stateVersion = "25.11";

	home.file.".config/nvim".source = ../common/config/nvim;

	home.packages = with pkgs; [
		git
    neovim
		ripgrep
		nil
		nixpkgs-fmt
		nodejs
		gcc
	];

}
