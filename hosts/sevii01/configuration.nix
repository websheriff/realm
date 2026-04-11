{ config, lib, pkgs, inputs, ... }: {
  
  imports =
    [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-partlabel/luks";
      allowDiscards = true;
      preLVM = true;
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

  environment.systemPackages = with pkgs; [
    age
    sops
    helix
    nil
    nixfmt
    yaml-language-server
    helm-ls
    git
    inputs.agenix.packages."${stdenv.hostPlatform.system}".default
    ghostty
    k3s
    nfs-utils
    yazi
    just
    wget
  ];
  environment.variables = {
    EDITOR = "hx";
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

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
          Name = "eno1.5";
        };
        vlanConfig.Id = 5;
      };
      "30-vlan50" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "eno1.50";
        };
        vlanConfig.Id = 50;
      };
      "40-vlan100" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "eno1.100";
        };
        vlanConfig.Id = 100;
      };
    };

    networks = {
      "10-eno1" = {
        enable = true;
        matchConfig.Name = "eno1";
        vlan = [
          "eno1.5"
          "eno1.50"
          "eno1.100"
        ];
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };
      "20-vlan5" = {
        matchConfig.Name = "eno1.5";
        networkConfig = {
          Address = "10.5.5.10/24";
          Gateway = "10.5.5.1";
          DNS = [ "10.5.5.1" ];
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "30-vlan50" = {
        matchConfig.Name = "eno1.50";
        networkConfig = {
          Address = "10.5.50.2/32";
          Gateway = "10.5.50.1";
        };
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };
      "40-vlan100" = {
        matchConfig.Name = "eno1.100";
        networkConfig = {
          Address = "10.5.100.2/32";
          Gateway = "10.5.100.1";
        };
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  networking.nftables.enable = true;
networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 
    6443 #k3s
  # 2379 #k3s etcd clients
  # 2380 #k3s etcd peers
    80
    443
    179
  ];
  networking.firewall.allowedUDPPorts = [
    8472
  ];

  services.xserver.videoDrivers = [ "i915" ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  services.openssh.enable = true;

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--write-kubeconfig-mode \"0644\""
      "--disable servicelb"
      "--disable metrics-server"
      # "--debug"
    ];
  };

  services.openiscsi = {
    enable = true;
    name = "iqn.2024-11.xyz.002042:sevii01";
  };
  #Longhorn fix
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";

}

