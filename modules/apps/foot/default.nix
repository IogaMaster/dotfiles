{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.apps.foot;
in {
  options.apps.foot = with types; {
    enable = mkBoolOpt false "Enable or disable the foot terminal.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.foot];

    home.configFile."foot/foot.ini".source = ./foot.ini;
  };
}
