{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.desktop.addons.gtklock;
in {
  options.desktop.addons.gtklock = with types; {
    enable = mkBoolOpt false "Enable or disable the gtklock screen locker.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gtklock
    ];
    security.pam.services.gtklock = {};

    home.configFile."gtklock/style.css".source = ./style.css;
  };
}
