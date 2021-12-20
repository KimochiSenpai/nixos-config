{ pkgs, ... }:
{
  networking.hostName = "hp";

  services = {
    openssh.enable = true;
  };

  users.mutableUsers = false;
  users.users.root.passwordFile = "/nix/persist/shadow_sean";
  users.users.sean.passwordFile = "/nix/persist/shadow_sean";

  environment.etc =
    builtins.listToAttrs (map
      (name: { inherit name; value.source = "/nix/persist/etc/${name}"; })
      [
        "machine-id"
        "NetworkManager/system-connections"
        "ssh/ssh_host_ed25519_key"
        "ssh/ssh_host_rsa_key"
      ]);

  sconfig = {
    gnome = true;
    profile = "desktop";
  };

  environment.systemPackages = [ pkgs.vmware-horizon-client ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
  };

  fileSystems = {
    "/" = { device = "tmpfs"; fsType = "tmpfs"; options = [ "mode=755" ]; };
    "/nix" = { device = "zroot/locker/nix"; fsType = "zfs"; };
    "/home" = { device = "zroot/locker/home"; fsType = "zfs"; };
    "/boot" = { device = "/dev/disk/by-partlabel/EFI\\x20system\\x20partition"; fsType = "vfat"; };
    "/var/log" = { device = "/nix/persist/var/log"; noCheck = true; options = [ "bind" ]; };
  };

  system.stateVersion = "21.05";
}