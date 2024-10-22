{
  inputs.nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  inputs.nixvim = {
    url = "github:nix-community/nixvim";
    inputs.nixpkgs.follows = "nixos-unstable";
  };

  outputs =
    {
      self,
      nixos-unstable,
      nixvim,
    }:
    {
      nixosConfigurations.nixos-asus = nixos-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/nixos-asus/default.nix
          nixvim.nixosModules.nixvim
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
