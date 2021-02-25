[

  (self: super: {
    powerline-go = super.callPackage
      (super.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/65211f5afcc3637c55423b327157a5eae05dff67/pkgs/tools/misc/powerline-go/default.nix";
        sha256 = "79a60a12da011ed12dc46aabd0b43e928604759b6e7d1e0b0fd7afc3cedfd4ad";
      })
      { };
  })

  (self: super: {
    brave = super.brave.overrideAttrs (oldAttrs: rec {
      version = "1.20.110";
      src = super.fetchurl {
        url = "https://github.com/brave/brave-browser/releases/download/v${version}/brave-browser_${version}_amd64.deb";
        sha256 = "0xmf74qh85f2jvi90q4cw2n7cvx5p46xmdr2iznfy09hdsymxfry";
      };
    });
  })

]
