{
  delib,
  pkgs,
  lib,
  ...
}:
let
  shared.nix = {
    # plan to stay on this version because it's impossible with my method to read .config/sops/age/keys.txt in pure mode on a newer versions.
    package = lib.mkForce pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };
in
delib.module {
  name = "nix";

  nixos.always = shared;
  home.always = shared;
}
