{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.swaync;
  inherit (inputs.nix-colors.colorschemes.${builtins.toString config.desktop.colorscheme}) colors;
in {
  options.desktop.addons.swaync = with types; {
    enable = mkBoolOpt false "Enable or disable swaync";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swaync
      libnotify
    ];
  };
}
