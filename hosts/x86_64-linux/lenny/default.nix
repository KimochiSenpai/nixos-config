{ pkgs, ... }:
{
  services = {
    openssh.enable = true;
  };

  users.mutableUsers = false;
  users.users.root.passwordFile = "/nix/persist/shadow_sean";
  users.users.sean.passwordFile = "/nix/persist/shadow_sean";

  environment.etc."NetworkManager/system-connections".source =
    "/nix/persist/etc/NetworkManager/system-connections";

  environment.persistence."/nix/persist" = {
    directories = [ "/var/log" ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
  };

  sconfig = {
    gnome = true;
    profile = "desktop";
    hardware = "physical";
  };

  environment.systemPackages = [ pkgs.vmware-horizon-client ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems = {
    "/" = { device = "tmpfs"; fsType = "tmpfs"; options = [ "mode=755" ]; };
    "/nix" = { device = "lenny/locker/nix"; fsType = "zfs"; };
    "/home" = { device = "lenny/locker/home"; fsType = "zfs"; };
    "/boot" = { device = "/dev/disk/by-partlabel/_esp"; fsType = "vfat"; };
  };

  system.stateVersion = "21.11";
}