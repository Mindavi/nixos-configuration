{
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-mindavi-new-hydra.url = "github:Mindavi/nixpkgs/hydra-update/2021-12-17";

  outputs = { self, nixpkgs-unstable, nixpkgs-mindavi-new-hydra }: {
    nixosConfigurations.nixos-asus = nixpkgs-mindavi-new-hydra.lib.nixosSystem {
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

