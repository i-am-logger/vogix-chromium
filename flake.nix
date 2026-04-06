{
  description = "vogix-chromium — Privacy-hardened Chromium with runtime theme switching";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.ungoogled-chromium.overrideAttrs (old: {
      pname = "vogix-chromium";

      patches = (old.patches or []) ++ [
        ./patches/001-omarchy-theme-switcher.patch
        ./patches/002-omarchy-policy-reload.patch
        ./patches/003-policy-theme-fixes.patch
        # TODO: 004-user-level-policy-path.patch — needs writing against Chromium source
      ];

      meta = (old.meta or {}) // {
        description = "Privacy-hardened Chromium with vogix runtime theme switching";
        homepage = "https://github.com/i-am-logger/vogix-chromium";
      };
    });

    overlays.default = final: prev: {
      vogix-chromium = self.packages.${prev.system}.default;
    };
  };
}
