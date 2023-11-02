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
  cfg = config.desktop.hyprland;
  inherit (inputs.nix-colors.colorschemes.${builtins.toString config.desktop.colorscheme}) colors;
in {
  options.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Enable or disable the hyprland window manager.";
  };

  config = mkIf cfg.enable {
    # Desktop additions
    desktop.addons = {
      waybar.enable = true;
      swww.enable = true;
      wofi.enable = true;
      mako.enable = true;
      gtklock.enable = true;
      wlogout.enable = true;
    };

    apps.foot.enable = true;

    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland

    environment.systemPackages = with pkgs; [
      grim
      slurp
      swappy
      imagemagick

      (writeShellScriptBin "screenshot" ''
        grim -g "$(slurp)" - | convert - -shave 1x1 PNG:- | wl-copy
      '')
      (writeShellScriptBin "screenshot-edit" ''
        wl-paste | swappy -f -
      '')
    ];

    # Hyprland configuration files
    home.configFile = {
      "hypr/launch".source = ./launch;
      "hypr/hyprland.conf".source = ./hyprland.conf;
      "hypr/colors.conf" = {
        text = ''
          general {
            col.active_border = 0xff${colors.base0C} 0xff${colors.base0D} 270deg
            col.inactive_border = 0xff${colors.base00}
          }
        '';
      };
    };
  };
}
