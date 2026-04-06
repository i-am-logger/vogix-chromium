{
  description = "vogix-chromium — Privacy-hardened Chromium with runtime theme switching";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
  in {
    overlays.default = final: prev: {
      # Override the unwrapped chromium build to include theme patches
      # Then ungoogled-chromium picks it up automatically
      chromium = prev.chromium.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ./patches/001-omarchy-theme-switcher.patch
          ./patches/002-omarchy-policy-reload.patch
          ./patches/003-policy-theme-fixes.patch
        ];
      });
    };

    # Direct package output
    packages.${system}.default = let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };
    in pkgs.ungoogled-chromium;
  };
}
