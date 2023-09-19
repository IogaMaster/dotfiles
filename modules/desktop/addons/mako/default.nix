{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.desktop.addons.mako;
in {
  options.desktop.addons.mako = with types; {
    enable = mkBoolOpt false "Enable or disable mako";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mako
      libnotify
    ];

    home.configFile."mako/config".source = ./config;
  };
}
