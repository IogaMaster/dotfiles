{
  description = ''
    Knowing this, that our old man was crucified with Him,
    that the body of sin might be done away with,
    that we should no longer be slaves of sin.
    - Romans 6:6 (NKJV)
  '';

  inputs = {
    # --- Core ---
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hjem.url = "github:feel-co/hjem";
    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
    vault-secrets.url = "github:serokell/vault-secrets";
    nixos-generators.url = "github:nix-community/nixos-generators";

    # --- Graphical ---
    mac-style-plymouth.url = "github:SergioRibera/s4rchiso-plymouth-theme";
    nix-colors.url = "github:misterio77/nix-colors";
    prism.url = "github:IogaMaster/prism";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let lib = (import ./lib/default.nix { inherit nixpkgs inputs; }).mkLib;
    in {
      inherit lib;
      nixosConfigurations = lib.makeSystems ./hosts {
        specialArgs = { inherit lib inputs; };
        extraModules = lib.findModules ./modules;
      };
      
      images = lib.mkImages ./images {
        specialArgs = { inherit lib inputs; };
        extraModules = lib.findModules ./modules;
      };

      devShells = import ./shell.nix { inherit lib; };
    };
}
