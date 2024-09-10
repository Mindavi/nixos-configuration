{
  inputs.nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  outputs = { self, nixos-unstable }: {
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

