{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-lsp-booster = {
      url = "github:slotThe/emacs-lsp-booster-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    nixos-hardware,
    nixos-wsl,
    home-manager,
    emacs-lsp-booster,
    ...
  }: let
    lib = nixpkgs.lib;
    mkConfigs = attrs: lib.mapAttrs (k: v: v k) attrs;

    mkSystem = type: (name: mkSystemExtra type [] name);
    mkSystemExtra = type: extraModules: (name: lib.nixosSystem {
      system = type;
      specialArgs = { inherit inputs; };
      modules = [
        (./host + "/${name}/system.nix")
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.deirn = import (./host + "/${name}/home.nix");
        } {
          nixpkgs.overlays = [
            emacs-lsp-booster.overlays.default
          ];
        }
      ] ++ extraModules;
    });
  in {
    nixosConfigurations = mkConfigs {
      g14 = mkSystem "x86_64-linux";

      wsl = mkSystemExtra "x86_64-linux" [
        nixos-wsl.nixosModules.default
      ];
    };
  };
}
