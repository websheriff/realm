{ config, lib, pkgs, inputs, ... }:
let
  custom-kubernetes-helm = with pkgs; wrapHelm kubernetes-helm {
    plugins = with pkgs.kubernetes-helmPlugins; [
      helm-diff
      helm-secrets
      helm-s3
      helm-git
    ];
  };

  custom-helmfile = pkgs.helmfile-wrapped.override {
    inherit (custom-kubernetes-helm) pluginsDir;
  };
in
{
  
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

  #sops.secrets."users/websheriff/password".neededForUsers = true;
  #users.mutableUsers = false;

#  users.users.websheriff = {
#      isNormalUser = true;
#      extraGroups = [ "wheel" ];
#      hashedPasswordFile = config.sops.secrets.websheriff-password.path;
#      packages = with pkgs; [];
#    };
#  users.groups.websheriff = {};

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
    custom-kubernetes-helm
    custom-helmfile
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
        linkConfig.RequiredForOnline = "routable";
      };
      "30-vlan30" = {
        matchConfig.Name = "vlan30";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan40" = {
        matchConfig.Name = "vlan40";
        linkConfig.RequiredForOnline = "no";
      };
      "30-vlan50" = {
        matchConfig.Name = "vlan50";
        networkConfig.LinkLocalAddressing = "no";
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
    6443 #k3s
  # 2379 #k3s etcd clients
  # 2380 #k3s etcd peers
    443
  ];
  networking.firewall.allowedUDPPorts = [
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
      "--disable local-storage"
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

