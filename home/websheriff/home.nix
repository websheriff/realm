{ config, pkgs, ...  }:

{
	home.username = "websheriff";
	home.homeDirectory = "/home/${config.home.username}";
	home.stateVersion = "25.11"; 	
	home.packages = with pkgs; [
		
	];
	
	programs.home-manager.enable = true;
	
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
}
