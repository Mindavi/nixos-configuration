{
  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs-unstable }: {
    nixosConfigurations.nixos-asus = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/nixos-asus/default.nix
      ];
    };
  };
}
