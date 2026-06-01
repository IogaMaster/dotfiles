{
  lib,
  config,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.apps.tools.nixpkgs" {
  options = with lib; {
    enable = mkBoolOpt' true; # enable by default
  };
  config =
    { cfg }:
    {
      environment.systemPackages = with pkgs; [
        nixfmt
        nixpkgs-lint-community
        nixpkgs-hammering
        nixpkgs-review
        nix-update
        nixpkgs-vet
        nixpkgs-track
        nurl
        nix-init
        nix-diff
      ];
    };
}
