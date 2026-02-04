let
  disk1 = "/dev/nvme0n1";
  disk2 = "/dev/nvme2n1";
in
{
  disko.devices = {
    disk = {
      ${disk1} = {
        device = "${disk1}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "EFI";
              name = "ESP";
              size = "1024M";
              type = "EF00" ;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "btrfs";
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" "-m raid1 -d raid1" "${disk2}" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "subvol=root" "compress=zstd" "noatime" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "subvol=home" "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                  };
                  "/nix/persist" = {
                    mountpoint = "/nix/persist";
                    mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
                  };
                  "/nix/persist/snapshots" = {
                    mountpoint = "/nix/persist/.snapshots";
                    mountOptions = [ "subvol=snapshots" "compress=zstd" "noatime" ];
                  };
                  "/lib" = {
                    mountpoint = "/var/lib";
                    mountOptions = [ "subvol=lib" "compress=zstd" "noatime" ];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "subvol=log" "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
    fileSystems."/nix/persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;
    fileSystems."/var/lib".neededForBoot = true;
}
