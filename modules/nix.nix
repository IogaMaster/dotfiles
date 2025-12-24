{ lib, config, pkgs, ... }@args:
lib.mkModule args "ioga.nix" {
  options = with lib;
    with lib.types; {
      enable = mkBoolOpt' true; # enable by default
      extraUsers = mkOpt' (listOf str) [ ];
    };
  config = { cfg }: {
    environment.systemPackages = with pkgs; [ nil nixd nixfmt manix statix ];
    nix = let users = [ "root" config.user.name ];
    in {
      settings = {
        experimental-features = "nix-command flakes";
        http-connections = 50;
        warn-dirty = false;
        log-lines = 50;
        sandbox = "relaxed";
        auto-optimise-store = true;
        trusted-users = users ++ cfg.extraUsers;
        allowed-users = users;
        substituters = [ "https://cache.nixos.org/" ];
        trusted-public-keys = [ ];
        keep-outputs = true;
        keep-derivations = true;
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    nixpkgs.config.allowUnfree = true;
  };
}
