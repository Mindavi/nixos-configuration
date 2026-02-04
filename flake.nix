{
  #inputs.nixos-unstable.url = "git:/home/rick/nixpkgs?ref=nixos-unstable";
  # TODO(Mindavi): Go back to nixos-unstable when #453713 goes through.
  #                https://nixpk.gs/pr-tracker.html?pr=453713
  # Upstream issue: https://github.com/systemd/systemd/issues/38932
  # and upstream fix: https://github.com/systemd/systemd/pull/39089
  inputs.nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  #  inputs.nixvim = {
  #    url = "github:nix-community/nixvim";
  #    inputs.nixpkgs.follows = "nixos-unstable";
  #    inputs.nuschtosSearch.follows = "";
  #    inputs.home-manager.follows = "";
  #    inputs.nix-darwin.follows = "";
  #    inputs.devshell.follows = "";
  #    inputs.treefmt-nix.follows = "";
  #    inputs.git-hooks.follows = "";
  #    inputs.flake-compat.follows = "";
  #  };

  inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixos-unstable";
  };

  inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixos-unstable";
  };

  inputs.impermanence = {
    url = "github:nix-community/impermanence";
  };

  outputs =
    {
      self,
      disko,
      impermanence,
      nixos-unstable,
      sops-nix,
      #nixvim,
    }:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system}.hydra_exporter =
        nixos-unstable.legacyPackages.${system}.callPackage ./packages/hydra_exporter
          { };
      nixosConfigurations.nixos-asus = nixos-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/nixos-asus/default.nix
          #nixvim.nixosModules.nixvim
          sops-nix.nixosModules.sops
        ];
        specialArgs = {
          hydra_exporter = self.packages.${system}.hydra_exporter;
          inherit nixos-unstable;
        };
      };
      nixosConfigurations.aqua = nixos-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/aqua/default.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
        ];
        specialArgs = {
          inherit nixos-unstable;
        };
      };
      nixosConfigurations.castle = nixos-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/castle/default.nix
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
        ];
        specialArgs = {
          inherit nixos-unstable;
        };
      };

    };
}
