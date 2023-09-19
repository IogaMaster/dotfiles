{ options, config, lib, pkgs, ... }:
with lib;
with lib.internal;
let
  cfg = config.services.ssh;
in
{
  options.services.ssh = with types; {
    enable = mkBoolOpt false "Enable ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = lib.mkForce "no";
      ports = [ 22 ];
    };
  };
}
