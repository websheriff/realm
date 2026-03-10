{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
in
{
  
  imports =
    [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kanto";

  time.timeZone = "America/Chicago";

  users.users.websheriff = {
      isNormalUser = true;
      extraGroups = [ "wheel" "minecraft" ];
      packages = with pkgs; [
        tree
	      neovim
      ];
    };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ghostty
    fosrl-newt
    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
  ];
  environment.variables.EDITOR = "nvim";

  networking = {
    usePredictableInterfaceNames = true;
    networkmanager.enable = false;
  };

  systemd.network.enable = true;
  networking.useDHCP = false;
  systemd.network = {
    netdevs = {
      "20-vlan5" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan5";
        };
        vlanConfig.Id = 5;
      };
      "20-vlan50" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan50";
        };
        vlanConfig.Id = 50;
      };
      "20-vlan100" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan100";
        };
        vlanConfig.Id = 100;
      };
    };

    networks = {
      "10-eno1" = {
        enable = true;
        matchConfig.Name = "eno1";
        address = [ "10.5.5.15/24" ];
        gateway = [ "10.5.5.1" ];
        dns = [ "10.5.5.1" ];
        vlan = [
          "vlan50"
          "vlan100"
        ];
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "routable";
      };
      "30-vlan50" = {
        matchConfig.Name = "vlan50";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan100" = {
        matchConfig.Name = "vlan100";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  networking.nftables.enable = true;

  networking.firewall.allowedTCPPorts = [ 
    25565
    3000
  ];
  networking.firewall.allowedUDPPorts = [
  ];
  
  services.openssh.enable = true;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.vanilla-latest = {
      enable = true;
      autoStart = true;
      jvmOpts = "-Xmx6G -Xms6G";

      package = pkgs.paperServers.paper;

      serverProperties = {
        difficulty = 2;
        gamemode = 0;
        white-list = true;
      };
      operators = {
        supreme_loser = "3443b3e3-709b-4e9c-bc70-50806be0eb30";
      };
      whitelist = {
        supreme_loser = "3443b3e3-709b-4e9c-bc70-50806be0eb30";
        BrockyDiesel = "b866d032-84f1-4ce2-a221-d659901c4757";
      };
    };
  };

  services.newt = {
    enable = true;
    environmentFile = config.age.secrets.secret-newtMC.path;
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      server = {
        DOMAIN = "git-bak.int.002042.xyz";
        ROOT_URL = "https://${srv.DOMAIN}/";
        HTTP_PORT = 3000;
      };

      service.DISABLE_REGISTRATION = true;

      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      mailer = {
        ENABLED = false;
      };
    };
  };
  services = {
    forgejo.settings.server.SSH_PORT = lib.head config.services.openssh.ports;
  };
  #services.gitea-actions-runner = {
  #  package = pkgs.foregejo-runner;
  #  instances.default = {
  #    enable = true;
  #    name = "";
  #    url = "https://git-bak.int.002042.xyz";
  #    tokenFile = config.age.secrets.secret-forgejoRunner.path;
  #    labels = [
  #      "native:host"
  #    ];
  #  };
  #};

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

}

