{ config, lib, pkgs, ... }: {
  
  imports =
    [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices {
    cryptroot = {
      device = "/dev/disk/by-partlabel/luks";
      allowDiscard = true;
    };
  };
  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%";
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 5;
    memoryPercent = 50;
  };

  networking.hostName = "sevii01";

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
      "20-vlan30" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan30";
        };
        vlanConfig.Id = 30;
      };
      "20-vlan40" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan40";
        };
        vlanConfig.Id = 40;
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
        address = [ "10.5.5.10/24" ];
        gateway = [ "10.5.5.1" ];
        dns = [ "10.5.5.1" ];
        vlan = [
          "vlan50"
          "vlan100"
        ];
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan30" = {
        matchConfig.Name = "vlan30";
        DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan40" = {
        matchConfig.Name = "vlan40";
        DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan50" = {
        matchConfig.Name = "vlan50";
        DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan100" = {
        matchConfig.Name = "vlan100";
        DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  networking.nftables.enable = true;

  networking.firewall.allowedTCPPorts = [ 
    6443 #k3s
  # 2379 #k3s etcd clients
  # 2380 #k3s etcd peers
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 #k3s flannel
  ];

  services.xserver.videoDrivers = [ "i915" ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  services.openssh.enable = true;

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--debug"
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

}

