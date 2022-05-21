{
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixpkgs-master.url = "github:NixOS/nixpkgs/master";

  outputs = { self, nixpkgs-unstable, nixpkgs-master }: {
    nixosConfigurations.nixos-asus = nixpkgs-master.lib.nixosSystem {
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

