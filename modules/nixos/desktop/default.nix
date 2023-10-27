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
  cfg = config.desktop;
in {
  options.desktop = with types; {
    colorscheme = mkOpt string "catppuccin-mocha" "Theme to use for the desktop";
  };

  config = {
    prism = {
      enable = true;
      wallpapers = ./wallpapers;
      colorscheme = inputs.nix-colors.colorschemes.${cfg.colorscheme};
    };

    environment.variables = {
      GTK_THEME = "Catppuccin-Mocha-Compact-Blue-dark";
    };

    home.extraOptions.gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Mocha-Compact-Blue-dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          size = "compact";
          variant = "mocha";
        };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}
