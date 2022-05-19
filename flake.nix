{
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-new-hydra.url = "github:mayflower/nixpkgs/hydra-updates";
  #inputs.nixpkgs-new-hydra.url = "github:NickCao/nixpkgs/hydra-update";

  outputs = { self, nixpkgs-unstable, nixpkgs-new-hydra }: {
    nixosConfigurations.nixos-asus = nixpkgs-new-hydra.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/nixos-asus/default.nix
      ];
    };
    nixosConfigurations.aqua = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/aqua/default.nix
      ];
    };
  };
}

