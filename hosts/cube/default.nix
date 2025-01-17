{ config, lib, pkgs, ... }:
{
  networking.hostName = "cube";

  # imports = [ ./monitors.nix ];

  sconfig = {
    gnome = true;
    profile = "desktop";
    gaming.enable = true;
    horizon.enable = true;
  };

  environment.etc =
    lib.genAttrs
      [
        "machine-id"
        "ssh/ssh_host_ed25519_key"
        "ssh/ssh_host_rsa_key"
      ]
      (name: { source = "/nix/persist/etc/${name}"; });

  services.openssh.enable = true;

  users.mutableUsers = false;
  users.users.sean.passwordFile = "/nix/persist/shadow_sean";
  users.users.root.passwordFile = "/nix/persist/shadow_sean";

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = map (x: "video=DP-${x}:1280x720@60") [ "0" "1" "2" ];
  };

  fileSystems = {
    "/" = { device = "tmpfs"; fsType = "tmpfs"; options = [ "mode=755" ]; };
    "/boot" = { device = "/dev/disk/by-partlabel/_esp"; fsType = "vfat"; };
    "/nix" = { device = "cube/locker/nix"; fsType = "zfs"; };
    "/home" = { device = "cube/locker/home"; fsType = "zfs"; };
    "/var/log" = { device = "cube/locker/log"; fsType = "zfs"; };
  };

  system.stateVersion = "21.11";
}
