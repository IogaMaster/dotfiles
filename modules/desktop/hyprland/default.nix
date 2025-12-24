{ lib, colors, pkgs, inputs, config, ... }@args:
lib.mkModule args "ioga.desktop.hyprland" {
  imports = with inputs; [ ];
  config = { cfg }: {
    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;
    xdg.portal.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL =
      "1"; # Hint electron apps to use wayland

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wayfreeze
      swappy
      imagemagick
      killall
      wl-clipboard

      (writeShellScriptBin "screenshot" ''
        killall wayfreeze
        killall grim
        killall slurp
        sleep .1
        wayfreeze & PID=$!; sleep .1; grim -g "$(slurp)" - | convert - -shave 1x1 PNG:- | wl-copy; kill $PID
      '')

      (writeShellScriptBin "screenshot-edit" ''
        wl-paste | swappy -f -
      '')

      pulseaudio
    ];

    services.xserver.enable = true;

    home.configFiles."wallpapers".source = inputs.prism.packages.prism {
      inherit pkgs;
      wallpapersDir = ../wallpapers;
      colorscheme = inputs.nix-colors.colorSchemes.${config.colors.scheme};
    };

    home.configFiles = {
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
