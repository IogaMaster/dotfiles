{
  description = "You could not live with your own failure. Where did that bring you? Back to me. - Thanos";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    denix = {
      url = "github:yunfachi/denix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    prism.url = "github:IogaMaster/prism";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    persist-retro.url = "github:Geometer1729/persist-retro";
  };

  outputs =
    {
      denix,
      nixpkgs,
      ...
    }@inputs:
    let
      mkConfigurations =
        isHomeManager:
        denix.lib.configurations {
          homeManagerNixpkgs = nixpkgs;
          homeManagerUser = "iogamaster"; # !!! REPLACEME
          inherit isHomeManager;

          paths = [
            ./hosts
            ./modules
            ./rices
          ];

          specialArgs = {
            inherit inputs;
          };
        };
    in
    {
      nixosConfigurations = mkConfigurations false;
      homeConfigurations = mkConfigurations true;
    };
}
