{ delib, ... }:
let
  system = "x86_64-linux";
  stateVersion = "24.05";
in
delib.host {
  name = "aurora";
  homeManagerSystem = system;
  home.home.stateVersion = stateVersion;
  nixos = {
    nixpkgs.hostPlatform = system;
    system.stateVersion = stateVersion;
  };
}
