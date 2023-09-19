{ options, config, lib, pkgs, ... }:
with lib;
with lib.internal;
let
  cfg = config.hardware.networking;
in
{
  options.hardware.networking = with types; {
    enable = mkBoolOpt false "Enable pipewire";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
