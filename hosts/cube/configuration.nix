{ pkgs, ... }:
{
  sconfig = {
    gnome = true;
    profile = "desktop";
    hardware = "physical";
    security-tools = true;
    i3.extraConfig = ''
      exec xrandr --output DisplayPort-0 --mode 2560x1440 --rate 165
      exec xrandr --output DisplayPort-1 --mode 2560x1440 --rate 165
    '';
  };

  environment.etc."sway/config.d/sconfig.conf".source = pkgs.writeText "sway.conf" ''
    output DP-1 position    0 0 resolution 2560x1440@165Hz
    output DP-2 position 2560 0 resolution 2560x1440@165Hz
  '';

  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
    ];
    directories = [
      "/home"
      "/var/log"
    ];
  };

  environment.systemPackages = with pkgs; [
    wine
    vmware-horizon-client
    (writeShellScriptBin "game" "exec xrandr --output DisplayPort-1 --off")
    (writeShellScriptBin "work" "exec xrandr --output DisplayPort-1 --mode 2560x1440 --rate 165 --right-of DisplayPort-0")
  ];

  services.openssh.enable = true;

  users.mutableUsers = false;
  users.users.sean.passwordFile = "/persist/shadow/sean";
  users.users.root.passwordFile = "/persist/shadow/sean";

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = map (x: "video=DP-${x}:1280x720@60") [ "0" "1" "2" ];
  };

  fileSystems = {
    "/" = { device = "tmpfs"; fsType = "tmpfs"; options = [ "mode=755" ]; };
    "/boot" = { device = "/dev/disk/by-partlabel/_esp"; fsType = "vfat"; };
    "/nix" = { device = "cube/locker/nix"; fsType = "zfs"; };
    "/persist" = { device = "cube/locker/persist"; fsType = "zfs"; neededForBoot = true; };
  };

  system.stateVersion = "21.05";
}
