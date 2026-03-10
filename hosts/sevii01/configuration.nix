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

  users.users.websheriff = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialHashedPassword = config.age.secrets.secret-websheriffHash.path;
      packages = with pkgs; [];
    };
  users.groups.websheriff = {};

  environment.systemPackages = with pkgs; [
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
  ];
  environment.variables = {
    EDITOR = "hx";
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
      "--disable-network-policy"
      "--disable-kube-proxy"
      "--disable servicelb"
      "--disable local-storage"
      "--disable traefik"
      "--disable coredns"
      "--disable metrics-server"
      "--flannel-backend none"
      # "--debug"
    ];
  };

  environment.etc."k3s/helmfile.yaml" = {
    mode = "0750";
    text = ''
      releases:
        - name: cilium
          namespace: kube-system
          chart: oci://quay.io/cilium/charts/cilium
          version: 1.19.1
          values: ["${../../services/k3s/core/networking/cilium/operator/helm-values.yaml}"]
          wait: true
        - name: coredns
          namespace: kube-system
          chart: oci://ghcr.io/coredns/charts/coredns
          version: 1.45.2
          values: ["${../../services/k3s/core/networking/coredns/app/helm-values.yaml}"]
          wait: true
        - name: flux-operator
          namespace: flux-system
          chart: oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator
          version: 0.43.0
          wait: true
        - name: flux-instance
          namespace: flux-system
          chart: oci://ghcr.io/controlplaneio-fluxcd/charts/flux-instance
          version: 0.43.0
          values: ["${../../services/k3s/gitops/flux-instance/app/helm-values.yaml}", "${../../services/k3s/config/settings/flux.yaml}"]
          wait: true
          needs:
            - flux-system/flux-operator
    '';
  };
  #Temporary Cloudflare token until figure out SOPS
  #system.activationScripts.cloudflareK3sSecret = ''
  #  ${pkgs.kubectl}/bin/kubectl --kubeconfig=/etc/rancher/k3s/k3s.yaml \
  #    create secret generic cloudflare-api-token \
  #    --namespace cert-manager \
  #    --from-literal=api-token=$(cat ${config.age.secrets.secret-cloudflareToken.path}) \
  #    --dry-run=client -o yaml \
  #    | ${pkgs.kubectl}/bin/kubectl apply -f - || true
  #  '';
  
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

