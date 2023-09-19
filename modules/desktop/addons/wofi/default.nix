{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.desktop.addons.wofi;
in {
  options.desktop.addons.wofi = with types; {
    enable = mkBoolOpt false "Enable or disable the wofi run launcher.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wofi
    ];

    home.configFile."wofi/config".source = ./config;
    home.configFile."wofi/style.css".source = ./style.css;
  };
}
