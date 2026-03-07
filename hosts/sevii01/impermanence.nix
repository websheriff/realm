{ config, lib, ... }: {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    echo "Rollback running..." > /mnt/rollback.log
    mkdir -p /mnt
    mount -t btrfs /dev/mapper/cryptroot /mnt

    btrfs subvolume list -o /mnt/root | cut -f9 -d' ' | while read subvolume; do
      echo "Deleting /$subvolume subvolume..." >> /mnt/rollback.log
      btrfs subvolume delete "/mnt/$subvolume"
    done

    echo "Deleting /root subvolume..." >> /mnt/rollback.log
    btrfs subvolume delete /mnt/root

    echo "Restoring clean /root subvolume..." >> /mnt/rollback.log
    btrfs subvolume snapshot /mnt/root-clean /mnt/root

    umount /mnt
  '';

  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/rancher"
      "/etc/iscsi"
      "/var/spool"
      "/srv"
    ];
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"   
    ];
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
