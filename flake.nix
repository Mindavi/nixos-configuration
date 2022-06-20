{
  inputs.nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixos-new-hydra.url = "github:NickCao/nixpkgs/hydra-bump";

  outputs = { self, nixos-unstable, nixos-new-hydra }: {
    nixosConfigurations.nixos-asus = nixos-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/nixos-asus/default.nix
      ];
    };
    nixosConfigurations.aqua = nixos-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/aqua/default.nix
      ];
    };
  };
}

