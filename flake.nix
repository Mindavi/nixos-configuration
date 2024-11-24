{
  inputs.nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  #inputs.nixos-unstable.url = "github:qowoz/nixpkgs/hydra-meson";
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixos-unstable";
    inputs.nuschtosSearch.follows = "";
    inputs.home-manager.follows = "";
    inputs.nix-darwin.follows = "";
    inputs.devshell.follows = "";
    inputs.treefmt-nix.follows = "";
    inputs.git-hooks.follows = "";
    inputs.flake-compat.follows = "";
  };

  outputs =
    {
      self,
      nixos-unstable,
      nixvim,
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
          nixvim.nixosModules.nixvim
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
        ];
        specialArgs = {
          inherit nixos-unstable;
        };
      };
    };
}
