{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.desktop.addons.gtklock;
  colors = inputs.nix-colors.colorschemes.${builtins.toString config.desktop.colorscheme}.colors;
in {
  options.desktop.addons.gtklock = with types; {
    enable = mkBoolOpt false "Enable or disable the gtklock screen locker.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gtklock
    ];
    security.pam.services.gtklock = {};

    home.configFile."gtklock/style.css".text = ''
      window {
         background-size: cover;
         background-repeat: no-repeat;
         background-position: center;
         background-color: #${colors.base00};
      }

      clock-label {
          color: #${colors.base05};
      }
    '';
  };
}
