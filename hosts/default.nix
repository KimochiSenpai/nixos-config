{ modules, nixpkgs, unstable }:
let

  hostMetadata =
    let
      fs = builtins.readDir ./.;
      inherit (builtins) concatMap attrNames;
      hostNames = concatMap (x: if fs.${x} == "directory" then [ x ] else [ ]) (attrNames fs);
    in
    builtins.listToAttrs (map
      (hn: { name = hn; value = import (./. + "/${hn}"); })
      hostNames);

  hardwareModule = hardware: (
    {
      qemu = (x: { imports = [ "${x.modulesPath}/profiles/qemu-guest.nix" ]; });
      physical = (x: { imports = [ "${x.modulesPath}/installer/scan/not-detected.nix" ]; });
    }
  ).${hardware};

in
builtins.mapAttrs
  (n: v:
    let pkgs = { inherit nixpkgs unstable; }.${v.pkgs};
    in
    pkgs.lib.nixosSystem {
      inherit (v) system;
      modules = modules ++ [
        (./. + "/${n}/configuration.nix")
        (hardwareModule v.hardware)
        ({ ... }: { networking.hostName = n; })
      ];
    }
  )
  hostMetadata
