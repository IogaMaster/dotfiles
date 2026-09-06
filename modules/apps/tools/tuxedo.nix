{
  lib,
  config,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.apps.tools.tuxedo" {
  options = with lib; {
    enable = mkBoolOpt' true; # enable by default
  };
  config =
    { cfg }:
    {
      environment.systemPackages = with pkgs; [
        tuxedo
      ];
      environment.shellAliases = {
        t = "tuxedo";
      };
    };
}
