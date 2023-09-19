{
  description = "You could not live with your own failure. Where did that bring you? Back to me. - Thanos";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url =
      "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators.url =
      github:nix-community/nixos-generators;
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    arion.url = "github:hercules-ci/arion";
    arion.inputs.nixpkgs.follows = "nixpkgs";

    webcord.url = "github:fufexan/webcord-flake";

    neovim = {
      url = github:IogaMaster/neovim;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
      };
    in
    lib.mkFlake {
      inherit inputs;
      package-namespace = "custom";

      src = ./.;
      channels-config.allowUnfree = true;

      overlays = with inputs; [
        webcord.overlays.default
        neovim.overlays.x86_64-linux.neovim
      ];

      systems.modules = with inputs; [
        nix-ld.nixosModules.nix-ld
        arion.nixosModules.arion
        disko.nixosModules.disko
      ];
    };
}
