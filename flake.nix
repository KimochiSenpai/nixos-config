{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.impermanence.url = "github:nix-community/impermanence";

  outputs = { self, nixpkgs, impermanence, ... }:
    let
      mypkgs = import ./pkgs self;
    in
    {
      nixosModules =
        { inherit (impermanence.nixosModules) impermanence; } //
        nixpkgs.lib.mapAttrs'
          (name: type: {
            name = nixpkgs.lib.removeSuffix ".nix" name;
            value = import (./modules + "/${name}");
          })
          (builtins.readDir ./modules);

      nixosModule = { pkgs, ... }: {
        imports = builtins.attrValues self.nixosModules;
        nixpkgs.overlays = [ (_: mypkgs) ];
      };

      nixosConfigurations = self.lib.getHosts {
        path = ./hosts;
        inherit nixpkgs;
        inherit (self) nixosModule;
      };

      lib = {
        getHosts = import lib/hosts.nix;
        morphHosts = import lib/morph.nix;
        forAllSystems = f: builtins.mapAttrs
          (name: _: f name)
          (nixpkgs.legacyPackages);
      };

      packages = self.lib.forAllSystems
        (system: mypkgs nixpkgs.legacyPackages.${system});

      apps = self.lib.forAllSystems (system:
        with nixpkgs.legacyPackages.${system};
        let
          jupy = python3.withPackages (p: with p; [ jupyterlab ipython ]);
        in
        {
          jupyterlab = writeShellScriptBin "jupyterlab" ''
            exec ${jupy}/bin/python -m jupyterlab "$@"
          '';
        }
      );
    };
}
