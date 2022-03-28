{
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  #inputs.nixpkgs-mindavi-new-hydra.url = "github:Mindavi/nixpkgs/hydra-update/2021-12-17";
  inputs.nixpkgs-mayflower-new-hydra.url = "github:mayflower/nixpkgs/hydra-updates";

  outputs = { self, nixpkgs-unstable, nixpkgs-mayflower-new-hydra }: {
    nixosConfigurations.nixos-asus = nixpkgs-mayflower-new-hydra.lib.nixosSystem {
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

